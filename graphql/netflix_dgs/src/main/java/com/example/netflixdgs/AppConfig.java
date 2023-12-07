package com.example.netflixdgs;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;

import java.util.concurrent.TimeUnit;

import org.apache.hc.client5.http.ConnectionKeepAliveStrategy;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.apache.hc.client5.http.impl.routing.DefaultProxyRoutePlanner;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.protocol.HttpContext;
import org.apache.hc.core5.util.TimeValue;

@Configuration
public class AppConfig {
    
    @Bean
    public RestTemplate restTemplate() {
        final PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        // the maximum number of connections. See https://github.com/tailcallhq/graphql-benchmarks/blob/main/wrk/bench.sh
        connectionManager.setMaxTotal(100); 
        connectionManager.setDefaultMaxPerRoute(100);
        
        final ConnectionKeepAliveStrategy keepAliveStrategy = new ConnectionKeepAliveStrategy() {
            public TimeValue getKeepAliveDuration(HttpResponse response, HttpContext context) {
            	// Keep alive for 60 seconds
                return TimeValue.of(60, TimeUnit.SECONDS);
            }
        };
        
        final HttpHost proxy = new HttpHost("127.0.0.1", 3000);        
        final DefaultProxyRoutePlanner routePlanner = new DefaultProxyRoutePlanner(proxy);
        final CloseableHttpClient httpClient = HttpClients.custom()
        		.setRoutePlanner(routePlanner)
                .setConnectionManager(connectionManager)
                .setConnectionManagerShared(true)
                .setKeepAliveStrategy(keepAliveStrategy)
                .build();
        final HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);
        return new RestTemplate(factory);
    }

}
