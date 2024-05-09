package graph

import (
    "bufio"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"example.com/gqlgen-users/graph/model"
	"time"
	"os"
)

var proxyURL = &url.URL{
	Scheme: "http", // or "https" if your proxy is using HTTPS
	Host: os.Getenv("NGINX_HOST") + ":" + os.Getenv("NGINX_PORT"),
}

// Global HTTP client for reuse
var client = &http.Client{
	Transport: &http.Transport{
		Proxy: http.ProxyURL(proxyURL),
		MaxIdleConns:        1000,                // Set the total max idle connections
        MaxIdleConnsPerHost: 200,                 // Set the max idle connections per host
        IdleConnTimeout:     30 * time.Second,
	},
}

// Centralized function to make HTTP requests
func fetchFromJSONPlaceholder(endpoint string) (*http.Response, error) {
	req, err := http.NewRequest("GET", "http://jsonplaceholder.typicode.com"+endpoint, nil)
	if err != nil {
		return nil, err
	}
	return client.Do(req)
}

func decodeResponse(resp *http.Response, v interface{}) error {
	// Use a buffered reader to optimize JSON decoding
	reader := bufio.NewReader(resp.Body)
	return json.NewDecoder(reader).Decode(v)
}

func (r *queryResolver) Users(ctx context.Context) ([]*model.User, error) {
	resp, err := fetchFromJSONPlaceholder("/users")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var users []*model.User
	if err := decodeResponse(resp, &users); err != nil {
		return nil, err
	}

	return users, nil
}

func (r *queryResolver) Posts(ctx context.Context) ([]*model.Post, error) {
	resp, err := fetchFromJSONPlaceholder("/posts")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var posts []*model.Post
	if err := decodeResponse(resp, &posts); err != nil {
    		return nil, err
    	}

    	return posts, nil
}

func (r *userResolver) Posts(ctx context.Context, obj *model.User) ([]*model.Post, error) {
	resp, err := fetchFromJSONPlaceholder(fmt.Sprintf("/users/%d/posts", obj.ID))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var posts []*model.Post
	if err := decodeResponse(resp, &posts); err != nil {
        		return nil, err
        	}

        	return posts, nil
}

// Query returns QueryResolver implementation.
func (r *Resolver) Query() QueryResolver { return &queryResolver{r} }

// User returns UserResolver implementation.
func (r *Resolver) User() UserResolver { return &userResolver{r} }

type queryResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
