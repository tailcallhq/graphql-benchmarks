package com.example.netflixdgs;

import com.netflix.graphql.dgs.DgsDataLoader;
import org.dataloader.BatchLoader;
import org.dataloader.DataLoader;
import org.dataloader.DataLoaderFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@DgsDataLoader(name = "users")
public class UserDataLoader implements BatchLoader<Integer, User> {
    private final RestTemplate restTemplate;

    @Autowired
    public UserDataLoader(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public CompletableFuture<List<User>> load(List<Integer> userIds) {
        return CompletableFuture.supplyAsync(() -> userIds.stream()
            .map(userId -> restTemplate.getForObject("http://jsonplaceholder.typicode.com/users/" + userId, User.class))
            .collect(Collectors.toList())
        );
    }
}

