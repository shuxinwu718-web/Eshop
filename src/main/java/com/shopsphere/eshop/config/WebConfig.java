package com.shopsphere.eshop.config;

import com.shopsphere.eshop.interceptor.VisitLogInterceptor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    private final VisitLogInterceptor visitLogInterceptor;
    private final CurrentUserIdArgumentResolver currentUserIdArgumentResolver;

    @Value("${spring.file.upload-dir:./uploads}")
    private String uploadDir;

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(currentUserIdArgumentResolver);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path basePath = Paths.get(uploadDir).toAbsolutePath().normalize();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + basePath.toString() + "/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(visitLogInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/uploads/**", "/swagger-ui/**", "/v3/api-docs/**");
    }
}