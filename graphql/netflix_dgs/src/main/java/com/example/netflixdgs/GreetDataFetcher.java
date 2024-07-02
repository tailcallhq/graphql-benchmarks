package com.example.netflixdgs;

import com.netflix.graphql.dgs.DgsComponent;
import com.netflix.graphql.dgs.DgsQuery;
import org.springframework.stereotype.Component;

@DgsComponent
public class GreetDataFetcher {

    @DgsQuery
    public String greet() {
        return "Hello World!";
    }
}

