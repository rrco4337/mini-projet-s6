package com.miniprojets6.plain.article;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class PlainDb {
    private PlainDb() {
    }

    public static Connection openConnection() throws SQLException {
        String url = getenvOrDefault("DB_URL", "jdbc:postgresql://localhost:5433/mini_projet_s6");
        String username = getenvOrDefault("DB_USERNAME", "postgres");
        String password = getenvOrDefault("DB_PASSWORD", "postgres");
        return DriverManager.getConnection(url, username, password);
    }

    private static String getenvOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? fallback : value;
    }
}
