package com.shopsphere.eshop.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnProperty(name = "elasticsearch.enabled", havingValue = "true")
public class ElasticsearchConfig {

    @Value("${spring.elasticsearch.uris:http://localhost:9200}")
    private String elasticsearchUris;

    @Bean
    public ElasticsearchClient elasticsearchClient() {
        // 1. 创建低级 RestClient（从配置文件读取 ES 地址，支持 Docker 环境）
        RestClient restClient = RestClient.builder(
                HttpHost.create(elasticsearchUris)
        ).build();

        // 2. 创建 Transport（使用 Jackson 映射）
        ElasticsearchTransport transport = new RestClientTransport(
                restClient,
                new JacksonJsonpMapper()
        );

        // 3. 创建 ElasticsearchClient
        return new ElasticsearchClient(transport);
    }
}