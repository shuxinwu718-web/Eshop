package com.shopsphere.eshop.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;

/**
 * 条件化启用 Elasticsearch Repository。
 *
 * <p>默认场景（application.yml 中 spring.data.elasticsearch.repositories.enabled=false）禁用了
 * Spring Data ES 的自动 repository 扫描，避免启动时因 @Document(createIndex=true) 连接 ES 建索引导致启动失败。</p>
 *
 * <p>本配置在 elasticsearch.enabled=true 时手动启用 repository 扫描，
 * 使「无 ES」与「有 ES」两种环境都能正常启动。</p>
 */
@Configuration
@ConditionalOnProperty(name = "elasticsearch.enabled", havingValue = "true")
@EnableElasticsearchRepositories(basePackages = "com.shopsphere.eshop.repository")
public class ElasticsearchRepositoryConfig {
}
