package com.miniprojets6.plain.auth;

import java.io.Serializable;

public class PlainAuthUser implements Serializable {
    private final int id;
    private final String username;
    private final String role;

    public PlainAuthUser(int id, String username, String role) {
        this.id = id;
        this.username = username;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }
}
