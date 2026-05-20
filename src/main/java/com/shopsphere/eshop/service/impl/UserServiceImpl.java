package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.LoginRequest;
import com.shopsphere.eshop.dto.RegisterRequest;
import com.shopsphere.eshop.dto.UserPageQueryDTO;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.service.UserService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.vo.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    @Autowired
    private UserCouponService userCouponService;


    @Value("${shop.newbie.coupon-ids:}")
    private String newbieCouponIds;

    @Override
    public Map<String, String> register(RegisterRequest request) {
        // 检查用户名是否已存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, request.getUsername());
        if (userMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("用户名已存在");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setStatus(0);
        userMapper.insert(user);

        Map<String, String> result = new HashMap<>();
        result.put("message", "注册成功");


        // 3. 发放新人礼包（如果配置了券ID）
        if (StringUtils.hasText(newbieCouponIds)) {
            grantNewbiePackage(user.getId());
        }
        
        return result;
    }

    private void grantNewbiePackage(Long userId) {
        String[] ids = newbieCouponIds.split(",");
        for (String idStr : ids) {
            Long couponId = Long.parseLong(idStr.trim());
            try {
                userCouponService.grantCoupon(userId, couponId);
            } catch (Exception e) {
                log.error("发放新人券失败 userId={}, couponId={}", userId, couponId, e);
                // 不抛出异常，避免注册中断
            }
        }
    }

    @Override
    public Map<String, String> login(LoginRequest request) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, request.getUsername());
        User user = userMapper.selectOne(wrapper);
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        if (user.getStatus() == 1) {
            throw new BusinessException("账号已被冻结，请联系管理员");
        }
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
        Map<String, String> result = new HashMap<>();
        result.put("token", token);
        log.info("生成的完整 token: {}", token);
        return result;
    }

    @Override
    public UserVO getUserInfo(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        UserVO vo = new UserVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. 根据用户名查询用户
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        User user = userMapper.selectOne(wrapper);
        if (user == null) {
            throw new UsernameNotFoundException("用户不存在: " + username);
        }

        // 2. 将用户的角色转为 Spring Security 的 GrantedAuthority
        // 注意：角色名需要加 "ROLE_" 前缀
        String role = "ROLE_" + user.getRole();  // 假设 user.getRole() 返回 "USER", "ADMIN", "MERCHANT"
        List<SimpleGrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority(role));

        // 3. 返回 UserDetails 对象（可以使用 Spring Security 内置的 User 类，或者自定义）
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getUsername())
                .password(user.getPassword())  // 已经加密
                .authorities(authorities)
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }

    @Override
    public Page<UserVO> adminPageQuery(UserPageQueryDTO dto) {
        Page<User> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(dto.getUsername())) {
            wrapper.like(User::getUsername, dto.getUsername());
        }
        if (StringUtils.hasText(dto.getPhone())) {
            wrapper.like(User::getPhone, dto.getPhone());
        }
        if (StringUtils.hasText(dto.getEmail())) {
            wrapper.like(User::getEmail, dto.getEmail());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(User::getStatus, dto.getStatus());
        }
        // 注意：管理员查询时，deleted=0（未注销的用户）
        wrapper.eq(User::getDeleted, 0);
        wrapper.orderByDesc(User::getCreateTime);

        Page<User> userPage = userMapper.selectPage(page, wrapper);
        Page<UserVO> voPage = new Page<>(userPage.getCurrent(), userPage.getSize(), userPage.getTotal());
        voPage.setRecords(userPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList()));
        return voPage;
    }

    @Override
    @Transactional
    public void freezeUser(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        if (user.getDeleted() == 1) {
            throw new BusinessException("已注销的用户无法冻结");
        }
        user.setStatus(1);
        userMapper.updateById(user);
    }

    @Override
    @Transactional
    public void unfreezeUser(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        user.setStatus(0);
        userMapper.updateById(user);
    }

    @Override
    public Page<UserVO> searchUsers(String keyword, Integer pageNum, Integer pageSize) {
        Page<User> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(User::getUsername, keyword)
                    .or()
                    .like(User::getPhone, keyword)
                    .or()
                    .like(User::getEmail, keyword);
        }
        wrapper.eq(User::getDeleted, 0);
        wrapper.orderByDesc(User::getCreateTime);
        Page<User> userPage = userMapper.selectPage(page, wrapper);
        Page<UserVO> voPage = new Page<>(userPage.getCurrent(), userPage.getSize(), userPage.getTotal());
        voPage.setRecords(userPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList()));
        return voPage;
    }

    @Override
    @Transactional
    public void deactivateAccount(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        // 检查是否有未完成订单（可选）
        // 可以查询 order 表中 user_id = userId 且 order_status in (0,1) 是否有记录，若有则提示先处理订单
        // 为简单起见，这里跳过订单检查，直接执行注销

        // 匿名化处理：修改用户名、清空手机号、邮箱、密码置为随机值，标记 deleted=1
        String anonymous = "deleted_" + UUID.randomUUID().toString().substring(0, 8);
        user.setUsername(anonymous);
        user.setPhone(null);
        user.setEmail(null);
        user.setPassword(UUID.randomUUID().toString());  // 清空密码，无法登录
        user.setDeleted(1);
        userMapper.updateById(user);
    }

    @Override
    public User getById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public void updateById(User user) {
        userMapper.updateById(user);
    }
    private UserVO convertToVO(User user) {
        UserVO vo = new UserVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }


    @Override
    public User findByEmail(String email) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email);
        return userMapper.selectOne(wrapper);
    }



}