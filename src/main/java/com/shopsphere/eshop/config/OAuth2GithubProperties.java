package com.shopsphere.eshop.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "oauth2.github")
public class OAuth2GithubProperties {
    private String clientId;
    private String clientSecret;
    private String redirectUri;
}