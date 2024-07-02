package com.example.netflixdgs;

public class Post {
	private Integer id;
	private Integer userId;
	private String title;
	private String body;
	private User user;

	public Integer getUserId() {
		return userId;
	}
	
	public String getBody() {
		return body;
	}
	
	public User getUser() {
		return user;
	}
	
	public Integer getId() {
		return id;
	}
	public String getTitle() {
		return title;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Post() {
		super();
	}
	
	public Post(Integer id, Integer userId, String title, String body, User user) {
		this.id = id;
		this.userId = userId;
		this.title = title;
		this.body = body;
		this.user = user;
	}
	
}
