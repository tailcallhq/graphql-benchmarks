package com.example.netflixdgs;

//import java.net.URI;
//import java.util.stream.Collectors;
//import org.springframework.stereotype.Service;
//import org.springframework.web.reactive.function.client.WebClient;
//import reactor.core.publisher.Mono;
//import reactor.netty.http.client.HttpClient;
//import reactor.netty.transport.ProxyProvider;
//import org.springframework.http.client.reactive.ReactorClientHttpConnector;

import java.util.List;

import com.netflix.graphql.dgs.DgsComponent;
import com.netflix.graphql.dgs.DgsQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestTemplate;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.ResponseEntity;

@DgsComponent
public class PostsDataFetcher {
	// private final WebClient webClient;
  private final RestTemplate restTemplate;

 	@Autowired
  public PostsDataFetcher(RestTemplate restTemplate) {
    this.restTemplate = restTemplate;
  }


	// @Autowired
	// public PostsDataFetcher(WebClient.Builder webClientBuilder) {
	// 	this.webClient = webClientBuilder
	// 	.clientConnector(new ReactorClientHttpConnector(build()))
	// 	.build();
	// }

// 	private HttpClient build() {
//         HttpClient httpClient = HttpClient.create()
// 						.proxy(proxy -> proxy.type(ProxyProvider.Proxy.HTTP)
//                                    .host("localhost")
//                                    .port(8080));
//         return httpClient;
// }

	// private final User u = new User(1, "ABC", "abc", "a@b.com", "xyz", "www.something.com");

	// private final List<Post> posts = List.of(
	// 	new Post(1,1,"post 1", "abc", u),
	// 	new Post(2,1,"post 2", "def", u),
	// 	new Post(3,1,"post 3", "ghi", u)
	// );

	@DgsQuery
	public List<Post> posts() {
 		String apiUrl = "http://jsonplaceholder.typicode.com/posts"; 

		ResponseEntity<List<Post>> responseEntity = restTemplate.exchange(
            apiUrl,
            org.springframework.http.HttpMethod.GET,
            null,
            new ParameterizedTypeReference<List<Post>>() {}
        );

		return responseEntity.getBody();
				
		// try {
		// 	Mono<List<Post>> responseBody = webClient
		// 		.get()
		// 		.uri(new URI("http://jsonplaceholder.typicode.com/posts"))
		// 		.retrieve()
		// 		.bodyToMono(new ParameterizedTypeReference<List<Post>>() {});
		// 	return responseBody.block();
		// } catch (Exception e) {
		// 	System.out.println(e.toString());
		// 	return List.of();
		// }
	}
}


