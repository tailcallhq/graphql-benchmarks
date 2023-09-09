package com.example.netflixdgs;

import java.net.InetSocketAddress;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import java.net.Proxy;
import java.net.Proxy.Type;

@Configuration
public class AppConfig {
    @Bean
    public RestTemplate restTemplate() {
			  SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
				Proxy proxy = new Proxy(Type.HTTP, new InetSocketAddress("localhost", 8080));
        factory.setProxy(proxy);
        return new RestTemplate(factory);
    }
}
