package com.miniprojets6.plain.category;

import com.miniprojets6.plain.article.PlainDb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

public class PlainCategoryDao {

    public List<PlainCategoryListRow> findAll() throws SQLException {
        String sql = "SELECT id, nom, slug, description, updated_at FROM categories ORDER BY nom ASC";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            List<PlainCategoryListRow> rows = new ArrayList<>();
            while (rs.next()) {
                rows.add(new PlainCategoryListRow(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("slug"),
                    rs.getString("description"),
                    rs.getObject("updated_at", OffsetDateTime.class)
                ));
            }
            return rows;
        }
    }

    public int create(PlainCategoryForm form) throws SQLException {
        String sql = """
            INSERT INTO categories(nom, slug, description, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?)
            RETURNING id
            """;

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            OffsetDateTime now = OffsetDateTime.now();
            statement.setString(1, form.getNom());
            statement.setString(2, form.getSlug());
            setNullableString(statement, 3, form.getDescription());
            statement.setObject(4, now);
            statement.setObject(5, now);

            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("Insertion categorie echouee");
                }
                return rs.getInt("id");
            }
        }
    }

    public PlainCategoryForm findForEdit(int id) throws SQLException {
        String sql = "SELECT nom, slug, description FROM categories WHERE id = ?";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                PlainCategoryForm form = new PlainCategoryForm();
                form.setNom(rs.getString("nom"));
                form.setSlug(rs.getString("slug"));
                form.setDescription(rs.getString("description"));
                return form;
            }
        }
    }

    public void update(int id, PlainCategoryForm form) throws SQLException {
        String sql = """
            UPDATE categories
            SET nom = ?, slug = ?, description = ?, updated_at = ?
            WHERE id = ?
            """;

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, form.getNom());
            statement.setString(2, form.getSlug());
            setNullableString(statement, 3, form.getDescription());
            statement.setObject(4, OffsetDateTime.now());
            statement.setInt(5, id);
            statement.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        }
    }

    private void setNullableString(PreparedStatement statement, int index, String value) throws SQLException {
        if (value == null || value.isBlank()) {
            statement.setNull(index, Types.VARCHAR);
        } else {
            statement.setString(index, value);
        }
    }
}
