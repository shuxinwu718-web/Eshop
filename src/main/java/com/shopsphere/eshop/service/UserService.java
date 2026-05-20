package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.LoginRequest;
import com.shopsphere.eshop.dto.RegisterRequest;
import com.shopsphere.eshop.dto.UserPageQueryDTO;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.vo.UserVO;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Map;

public interface  UserService {
    Map<String, String> register(RegisterRequest request);

    Map<String, String> login(LoginRequest request);

    UserVO getUserInfo(Long userId);

    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;

    // 管理员分页查询用户（支持筛选）
    Page<UserVO> adminPageQuery(UserPageQueryDTO dto);

    // 冻结用户（管理员）
    void freezeUser(Long userId);

    // 解冻用户（管理员）
    void unfreezeUser(Long userId);

    // 搜索用户（根据关键词）
    Page<UserVO> searchUsers(String keyword, Integer pageNum, Integer pageSize);

    // 用户注销账号（本人）
    void deactivateAccount(Long userId);

    User getById(Long userId);

    void updateById(User user);

    User findByEmail(String email);
}
