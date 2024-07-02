package com.example.netflixdgs;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import com.netflix.graphql.dgs.DgsComponent;
import com.netflix.graphql.dgs.DgsQuery;
import org.dataloader.DataLoader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestTemplate;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.ResponseEntity;
import com.netflix.graphql.dgs.context.DgsContext;
import graphql.schema.DataFetchingEnvironment;

@DgsComponent
public class PostsDataFetcher {
  private final RestTemplate restTemplate;
  private static final ParameterizedTypeReference<List<Post>> typeReference = new ParameterizedTypeReference<List<Post>>() {};

  @Autowired
  public PostsDataFetcher(RestTemplate restTemplate) {
    this.restTemplate = restTemplate;
  }

  @DgsQuery
  public CompletableFuture<List<Post>> posts(DataFetchingEnvironment dfe) {
    String apiUrl = "http://jsonplaceholder.typicode.com/posts";

    ResponseEntity<List<Post>> responseEntity = restTemplate.exchange(
        apiUrl,
        org.springframework.http.HttpMethod.GET,
        null,
        typeReference
    );

    List<Post> posts = responseEntity.getBody();

    if (!dfe.getSelectionSet().contains("user")) {
      return CompletableFuture.completedFuture(posts);
    }

    DataLoader<Integer, User> userDataLoader = dfe.getDataLoader("users");

    List<CompletableFuture<Void>> futures = posts.stream()
        .map(post -> {
        return userDataLoader.load(post.getUserId()).thenAccept(user -> post.setUser(user));
        })
        .collect(Collectors.toList());

    return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]))
        .thenApply(v -> posts);
  }
}


