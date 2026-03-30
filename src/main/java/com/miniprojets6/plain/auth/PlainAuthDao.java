package com.miniprojets6.plain.auth;

import com.miniprojets6.plain.article.PlainDb;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PlainAuthDao {

    public PlainAuthUser authenticate(String username, String password) throws SQLException {
        String sql = "SELECT id, username, password_hash, role FROM users WHERE username = ? AND actif = true";

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                String hash = rs.getString("password_hash");
                if (!isValidPassword(password, hash)) {
                    return null;
                }

                return new PlainAuthUser(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("role")
                );
            }
        }
    }

    private boolean isValidPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null || storedHash.isBlank()) {
            return false;
        }

        if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            try {
                return BCrypt.checkpw(rawPassword, storedHash);
            } catch (Exception ex) {
                return false;
            }
        }

        // Fallback in case old rows are stored in plain text.
        return storedHash.equals(rawPassword);
    }
}
