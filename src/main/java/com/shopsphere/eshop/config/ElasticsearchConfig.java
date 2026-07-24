package com.shopsphere.eshop.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {

    @Bean
    public ElasticsearchClient elasticsearchClient() {
        // 1. 创建低级 RestClient
        RestClient restClient = RestClient.builder(
                HttpHost.create("http://localhost:9200")
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