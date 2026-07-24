package com.shopsphere.eshop.utils;

import com.shopsphere.eshop.config.OAuth2GithubProperties;
import com.shopsphere.eshop.dto.GithubUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class GithubOAuth2Client {

    static {
        // GitHub API 不支持 IPv6，强制使用 IPv4
        System.setProperty("java.net.preferIPv4Stack", "true");
    }

    private final OAuth2GithubProperties properties;
    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 生成跳转到 GitHub 授权页的 URL
     */
    public String getAuthorizeUrl() {
        return UriComponentsBuilder.fromHttpUrl("https://github.com/login/oauth/authorize")
                .queryParam("client_id", properties.getClientId())
                .queryParam("redirect_uri", properties.getRedirectUri())
                .queryParam("scope", "read:user")
                .queryParam("state", UUID.randomUUID())
                .toUriString();
    }

    /**
     * 用 code 换 access_token
     *
     * GitHub API 要求 form-encoded 格式，不是 JSON
     */
    public String getAccessToken(String code) {
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("client_id", properties.getClientId());
        body.add("client_secret", properties.getClientSecret());
        body.add("code", code);
        body.add("redirect_uri", properties.getRedirectUri());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);

        String response = restTemplate.postForObject(
                "https://github.com/login/oauth/access_token",
                request,
                String.class
        );

        Map<String, String> result = parseQueryString(response);
        return result.get("access_token");
    }

    /**
     * 用 access_token 获取 GitHub 用户信息
     */
    public GithubUser getUser(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        headers.set("User-Agent", "e-shop");
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<GithubUser> response = restTemplate.exchange(
                "https://api.github.com/user",
                HttpMethod.GET,
                entity,
                GithubUser.class
        );
        return response.getBody();
    }

    private Map<String, String> parseQueryString(String query) {
        return Arrays.stream(query.split("&"))
                .map(pair -> pair.split("=", 2))
                .collect(Collectors.toMap(
                        seg -> URLDecoder.decode(seg[0], StandardCharsets.UTF_8),
                        seg -> seg.length > 1 ? URLDecoder.decode(seg[1], StandardCharsets.UTF_8) : ""
                ));
    }
}