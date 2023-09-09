package com.example.netflixdgs;

public class User {
	private Integer id;
	private String name;
	private String username;
	private String email;
	private String phone;
	private String website;
	
	public User(Integer id, String name, String username, String email, String phone, String website) {
		this.id = id;
		this.name = name;
		this.username = username;
		this.email = email;
		this.phone = phone;
		this.website = website;
	}
	public Integer getId() {
		return id;
	}
	public String getName() {
		return name;
	}
	public String getUsername() {
		return username;
	}
	public String getEmail() {
		return email;
	}
	public String getPhone() {
		return phone;
	}
	public String getWebsite() {
		return website;
	}
	
}
