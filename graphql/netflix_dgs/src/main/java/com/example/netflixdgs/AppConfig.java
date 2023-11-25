package com.example.netflixdgs;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.apache.hc.core5.http.HttpHost;

@Configuration
public class AppConfig {
    
    @Bean
    public RestTemplate restTemplate() {
        final PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        // the maximum number of connections. See https://github.com/tailcallhq/graphql-benchmarks/blob/main/wrk/bench.sh
        connectionManager.setMaxTotal(100); 

        final HttpHost proxy = new HttpHost("localhost", 3000);        
        final CloseableHttpClient httpClient = HttpClients.custom()
                .setConnectionManager(connectionManager)
                .setConnectionManagerShared(true)
                .setProxy(proxy)
                .build();
        final HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);
            	
        return new RestTemplate(factory);
    }

}
