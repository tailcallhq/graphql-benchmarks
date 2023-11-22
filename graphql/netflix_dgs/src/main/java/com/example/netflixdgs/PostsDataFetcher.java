package com.example.netflixdgs;

import org.springframework.web.client.RestTemplate;
import com.netflix.graphql.dgs.DgsComponent;
import com.netflix.graphql.dgs.DgsData;
import java.util.Arrays;
import java.util.List;

@DgsComponent
public class PostsDataFetcher {
  private final RestTemplate restTemplate;

  public PostsDataFetcher(RestTemplate restTemplate) {
    this.restTemplate = restTemplate;
  }

  @DgsData(parentType = "Query", field = "posts")
  public List<Post> posts() {
    String url = "https://jsonplaceholder.typicode.com/posts";
    Post[] posts = restTemplate.getForObject(url, Post[].class);
    return Arrays.asList(posts);
  }
}
