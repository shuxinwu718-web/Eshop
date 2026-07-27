package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.GithubUser;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.utils.GithubOAuth2Client;
import com.shopsphere.eshop.utils.JwtUtil;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/api/oauth2/github")
@RequiredArgsConstructor
@Tag(name = "特殊登录接口（github）", description = "获取github的许可和根据github生成信息判断是登录还是注册")
public class OAuth2Controller {

    private final GithubOAuth2Client githubClient;
    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;
    private final StringRedisTemplate redisTemplate;

    @Value("${oauth2.frontend-url:http://localhost:3000}")
    private String frontendUrl;

    @GetMapping("/authorize")
    public Result<String> authorize() {
        return Result.success(githubClient.getAuthorizeUrl());
    }

    @GetMapping("/callback")
    public void callback(@RequestParam String code, HttpServletResponse response) throws IOException {

        // a. 用 code 换 access_token
        String accessToken = githubClient.getAccessToken(code);

        // b. 用 token 获取 GitHub 用户信息
        GithubUser githubUser = githubClient.getUser(accessToken);

        // c. 查数据库：这个 GitHub 账号是否绑定过用户
        User user = userMapper.findByGithubId(String.valueOf(githubUser.getId()));

        if (user == null) {
            // d. 首次登录 → 自动注册
            user = new User();
            user.setGithubId(String.valueOf(githubUser.getId()));
            user.setUsername("github_" + githubUser.getLogin());
            user.setNickname(githubUser.getName() != null ? githubUser.getName() : githubUser.getLogin());
            user.setAvatar(githubUser.getAvatarUrl());
            user.setEmail(githubUser.getEmail());
            user.setPassword(BCrypt.hashpw(UUID.randomUUID().toString(), BCrypt.gensalt()));
            user.setRole("USER");
            user.setStatus(1);
            userMapper.insert(user);
        }

        // 递增会话版本，旧 token 自动失效（一号一端）
        Long sver = redisTemplate.opsForValue().increment("user:sver:" + user.getId());

        // e. 生成 JWT
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole(), sver);

        // f. 重定向到前端页面，token 通过 URL 参数传递
        response.sendRedirect(frontendUrl + "/#/oauth2/callback?token=" + token);
    }
}