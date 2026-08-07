package com.shopsphere.eshop;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.utils.JwtUtil;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * A6 安全 / 越权 / 错误码 集成测试
 *
 * 覆盖整改项：
 * - S1/S2：普通用户访问管理端接口 → 403；管理员 → 200
 * - S4：未登录上传 → 403（Security 入口点）；.html 白名单外类型 → 400；空文件 → 400
 * - S6/A1：图形验证码一次性（二次使用同一验证码 → 400）
 * - A5：业务参数错误 → 400、未匹配路径 → 404、未登录受保护接口 → 403
 */
@SpringBootTest
@AutoConfigureMockMvc
class A6SecurityIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 为指定用户名签发一个「永不过期」的 JWT（sver 取超大值，避免与其它测试递增会话版本产生竞态）。
     */
    private String tokenOf(String username) {
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            throw new IllegalStateException("测试依赖的种子用户不存在: " + username);
        }
        return jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole(), 999_999_999L);
    }

    @Test
    void normalUserGets403OnAdminApi() throws Exception {
        mockMvc.perform(get("/api/user/admin/page")
                        .param("pageNum", "1")
                        .param("pageSize", "10")
                        .header("Authorization", "Bearer " + tokenOf("lisi")))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.code").value(403))
                .andExpect(jsonPath("$.msg").value("权限不足，无法访问该资源"));
    }

    @Test
    void adminTokenCanAccessAdminApi() throws Exception {
        mockMvc.perform(get("/api/user/admin/page")
                        .param("pageNum", "1")
                        .param("pageSize", "10")
                        .header("Authorization", "Bearer " + tokenOf("admin")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }

    @Test
    void unauthenticatedUploadReturns403() throws Exception {
        mockMvc.perform(multipart("/api/v1/files")
                        .file(new MockMultipartFile("file", "a.txt", "text/plain", "x".getBytes())))
                .andExpect(status().isForbidden());
    }

    @Test
    void htmlFileRejectedByWhitelist() throws Exception {
        mockMvc.perform(multipart("/api/v1/files")
                        .file(new MockMultipartFile("file", "evil.html", "text/html", "<script>".getBytes()))
                        .header("Authorization", "Bearer " + tokenOf("lisi")))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(400))
                .andExpect(jsonPath("$.msg").value("不支持的文件类型，仅允许图片/文档/压缩包等常见格式"));
    }

    @Test
    void emptyFileRejected() throws Exception {
        mockMvc.perform(multipart("/api/v1/files")
                        .file(new MockMultipartFile("file", "empty.txt", "text/plain", new byte[0]))
                        .header("Authorization", "Bearer " + tokenOf("lisi")))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(400))
                .andExpect(jsonPath("$.msg").value("上传文件不能为空"));
    }

    @Test
    void unknownPathReturns404() throws Exception {
        mockMvc.perform(get("/api/not-exist")
                        .header("Authorization", "Bearer " + tokenOf("lisi")))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value(404))
                .andExpect(jsonPath("$.msg").value("请求的接口不存在"));
    }

    @Test
    void resetPasswordWrongCodeReturns400() throws Exception {
        mockMvc.perform(post("/api/user/reset-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"noone@test.com\",\"code\":\"000000\",\"newPassword\":\"123456\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(400))
                .andExpect(jsonPath("$.msg").value("验证码错误或已过期"));
    }

    @Test
    void captchaCodeIsOneTime() throws Exception {
        // 直接向 Redis 写入验证码，模拟 /api/captcha/image 发放
        String key = UUID.randomUUID().toString();
        redisTemplate.opsForValue().set("captcha:" + key, "abcd", 5, TimeUnit.MINUTES);

        String loginBody = "{\"username\":\"lisi\",\"password\":\"123456\",\"captchaKey\":\""
                + key + "\",\"captchaCode\":\"abcd\"}";

        // 第一次：正确验证码 + 正确凭据 → 200
        mockMvc.perform(post("/api/user/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));

        // 第二次：复用同一验证码 → 400（一次性防重放）
        mockMvc.perform(post("/api/user/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginBody))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.msg").value("验证码已过期，请刷新"));
    }
}
