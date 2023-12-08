package com.example.netflixdgs;

import java.util.List;

import com.netflix.graphql.dgs.DgsComponent;
import com.netflix.graphql.dgs.DgsQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestTemplate;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.ResponseEntity;

@DgsComponent
public class PostsDataFetcher {
  private final RestTemplate restTemplate;
  private static final ParameterizedTypeReference<List<Post>> typeReference = new ParameterizedTypeReference<List<Post>>() {};

 	@Autowired
  	public PostsDataFetcher(RestTemplate restTemplate) {
    	this.restTemplate = restTemplate;
  	}

	@DgsQuery
	public List<Post> posts() {
 		String apiUrl = "http://jsonplaceholder.typicode.com/posts"; 

		ResponseEntity<List<Post>> responseEntity = restTemplate.exchange(
            apiUrl,
            org.springframework.http.HttpMethod.GET,
            null,
            typeReference
        );

		return responseEntity.getBody();
				
	}
}


