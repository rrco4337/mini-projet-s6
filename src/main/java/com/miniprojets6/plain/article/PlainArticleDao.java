package com.miniprojets6.plain.article;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

public class PlainArticleDao {

    public List<PlainArticleRow> findAll() throws SQLException {
        String sql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                   a.statut::text,
                   a.a_la_une,
                   a.chapeau,
                   a.vues,
                   a.created_at,
                   a.updated_at
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
            GROUP BY a.id
            ORDER BY a.updated_at DESC
            """;

        return queryRows(sql, null);
    }

    public List<PlainArticleRow> findByStatus(String status) throws SQLException {
        String sql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                   a.statut::text,
                   a.a_la_une,
                   a.chapeau,
                   a.vues,
                   a.created_at,
                   a.updated_at
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
            WHERE a.statut = CAST(? AS article_statut)
            GROUP BY a.id
            ORDER BY a.updated_at DESC
            """;

        return queryRows(sql, status);
    }

    public PlainArticleRow findMostViewedPublished() throws SQLException {
        String sql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                   a.statut::text,
                   a.a_la_une,
                   a.chapeau,
                   a.vues,
                   a.created_at,
                   a.updated_at
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
            WHERE a.statut = CAST('publie' AS article_statut)
            GROUP BY a.id
            ORDER BY a.vues DESC, a.updated_at DESC
            LIMIT 1
            """;

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (!rs.next()) {
                return null;
            }
            return mapRow(rs);
        }
    }

    private List<PlainArticleRow> queryRows(String sql, String status) throws SQLException {

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            if (status != null) {
                statement.setString(1, status);
            }
            try (ResultSet rs = statement.executeQuery()) {
                List<PlainArticleRow> rows = new ArrayList<>();
                while (rs.next()) {
                    rows.add(mapRow(rs));
                }
                return rows;
            }
        }
    }

    private PlainArticleRow mapRow(ResultSet rs) throws SQLException {
        return new PlainArticleRow(
            rs.getInt("id"),
            rs.getString("titre"),
            rs.getString("slug"),
            rs.getString("category_names"),
            rs.getString("statut"),
            rs.getBoolean("a_la_une"),
            rs.getString("chapeau"),
            rs.getInt("vues"),
            rs.getObject("created_at", OffsetDateTime.class),
            rs.getObject("updated_at", OffsetDateTime.class)
        );
    }

    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM articles WHERE statut = CAST(? AS article_statut)";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            try (ResultSet rs = statement.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public int countFeatured() throws SQLException {
        String sql = "SELECT COUNT(*) FROM articles WHERE a_la_une = TRUE";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public int totalViews() throws SQLException {
        String sql = "SELECT COALESCE(SUM(vues), 0) FROM articles";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public List<PlainCategoryRow> findAllCategories() throws SQLException {
        String sql = "SELECT id, nom FROM categories ORDER BY nom ASC";

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            List<PlainCategoryRow> rows = new ArrayList<>();
            while (rs.next()) {
                rows.add(new PlainCategoryRow(rs.getInt("id"), rs.getString("nom")));
            }
            return rows;
        }
    }

    public int create(PlainArticleCreateRequest request) throws SQLException {
        String insertArticleSql = """
            INSERT INTO articles (titre, slug, sous_titre, chapeau, contenu, statut, meta_title, meta_description, meta_keywords, vues, a_la_une, date_publication, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, CAST(? AS article_statut), ?, ?, ?, 0, ?, ?, ?, ?)
            RETURNING id
            """;
        String insertCategorySql = "INSERT INTO article_categories(article_id, category_id) VALUES (?, ?) ON CONFLICT DO NOTHING";

        try (Connection connection = PlainDb.openConnection()) {
            connection.setAutoCommit(false);
            try {
                int articleId;
                OffsetDateTime now = OffsetDateTime.now();

                try (PreparedStatement statement = connection.prepareStatement(insertArticleSql)) {
                    statement.setString(1, request.getTitre());
                    statement.setString(2, request.getSlug());
                    setNullableString(statement, 3, request.getSousTitre());
                    setNullableString(statement, 4, request.getChapeau());
                    statement.setString(5, request.getContenu());
                    statement.setString(6, request.getStatut());
                    setNullableString(statement, 7, request.getMetaTitle());
                    setNullableString(statement, 8, request.getMetaDescription());
                    setNullableString(statement, 9, request.getMetaKeywords());
                    statement.setBoolean(10, request.isaLaUne());
                    if ("publie".equals(request.getStatut())) {
                        statement.setObject(11, now);
                    } else {
                        statement.setNull(11, Types.TIMESTAMP_WITH_TIMEZONE);
                    }
                    statement.setObject(12, now);
                    statement.setObject(13, now);

                    try (ResultSet rs = statement.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Insertion article echouee");
                        }
                        articleId = rs.getInt("id");
                    }
                }

                if (!request.getCategoryIds().isEmpty()) {
                    try (PreparedStatement statement = connection.prepareStatement(insertCategorySql)) {
                        for (Integer categoryId : request.getCategoryIds()) {
                            statement.setInt(1, articleId);
                            statement.setInt(2, categoryId);
                            statement.addBatch();
                        }
                        statement.executeBatch();
                    }
                }

                connection.commit();
                return articleId;
            } catch (SQLException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public PlainArticleCreateRequest findForEdit(int articleId) throws SQLException {
        String articleSql = """
            SELECT titre, slug, sous_titre, chapeau, contenu, statut::text, a_la_une, meta_title, meta_description, meta_keywords
            FROM articles
            WHERE id = ?
            """;
        String categorySql = "SELECT category_id FROM article_categories WHERE article_id = ?";

        try (Connection connection = PlainDb.openConnection()) {
            PlainArticleCreateRequest request = null;

            try (PreparedStatement statement = connection.prepareStatement(articleSql)) {
                statement.setInt(1, articleId);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        request = new PlainArticleCreateRequest();
                        request.setTitre(rs.getString("titre"));
                        request.setSlug(rs.getString("slug"));
                        request.setSousTitre(rs.getString("sous_titre"));
                        request.setChapeau(rs.getString("chapeau"));
                        request.setContenu(rs.getString("contenu"));
                        request.setStatut(rs.getString("statut"));
                        request.setaLaUne(rs.getBoolean("a_la_une"));
                        request.setMetaTitle(rs.getString("meta_title"));
                        request.setMetaDescription(rs.getString("meta_description"));
                        request.setMetaKeywords(rs.getString("meta_keywords"));
                    }
                }
            }

            if (request == null) {
                return null;
            }

            try (PreparedStatement statement = connection.prepareStatement(categorySql)) {
                statement.setInt(1, articleId);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        request.getCategoryIds().add(rs.getInt("category_id"));
                    }
                }
            }

            return request;
        }
    }

    public void update(int articleId, PlainArticleCreateRequest request) throws SQLException {
        String updateArticleSql = """
            UPDATE articles
            SET titre = ?,
                slug = ?,
                sous_titre = ?,
                chapeau = ?,
                contenu = ?,
                statut = CAST(? AS article_statut),
                a_la_une = ?,
                meta_title = ?,
                meta_description = ?,
                meta_keywords = ?,
                date_publication = CASE
                    WHEN CAST(? AS article_statut) = CAST('publie' AS article_statut)
                        THEN COALESCE(date_publication, ?)
                    ELSE NULL
                END,
                updated_at = ?
            WHERE id = ?
            """;
        String deleteCategoriesSql = "DELETE FROM article_categories WHERE article_id = ?";
        String insertCategorySql = "INSERT INTO article_categories(article_id, category_id) VALUES (?, ?) ON CONFLICT DO NOTHING";

        try (Connection connection = PlainDb.openConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement statement = connection.prepareStatement(updateArticleSql)) {
                    statement.setString(1, request.getTitre());
                    statement.setString(2, request.getSlug());
                    setNullableString(statement, 3, request.getSousTitre());
                    setNullableString(statement, 4, request.getChapeau());
                    statement.setString(5, request.getContenu());
                    statement.setString(6, request.getStatut());
                    statement.setBoolean(7, request.isaLaUne());
                    setNullableString(statement, 8, request.getMetaTitle());
                    setNullableString(statement, 9, request.getMetaDescription());
                    setNullableString(statement, 10, request.getMetaKeywords());
                    statement.setString(11, request.getStatut());
                    OffsetDateTime now = OffsetDateTime.now();
                    statement.setObject(12, now);
                    statement.setObject(13, now);
                    statement.setInt(14, articleId);
                    statement.executeUpdate();
                }

                try (PreparedStatement statement = connection.prepareStatement(deleteCategoriesSql)) {
                    statement.setInt(1, articleId);
                    statement.executeUpdate();
                }

                if (!request.getCategoryIds().isEmpty()) {
                    try (PreparedStatement statement = connection.prepareStatement(insertCategorySql)) {
                        for (Integer categoryId : request.getCategoryIds()) {
                            statement.setInt(1, articleId);
                            statement.setInt(2, categoryId);
                            statement.addBatch();
                        }
                        statement.executeBatch();
                    }
                }

                connection.commit();
            } catch (SQLException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public void delete(int articleId) throws SQLException {
        String sql = "DELETE FROM articles WHERE id = ?";
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, articleId);
            statement.executeUpdate();
        }
    }

    public void archive(int articleId) throws SQLException {
        updateStatus(articleId, "archive", false);
    }

    public void restoreToDraft(int articleId) throws SQLException {
        updateStatus(articleId, "brouillon", true);
    }

    private void updateStatus(int articleId, String status, boolean clearPublicationDate) throws SQLException {
        String sql;
        if (clearPublicationDate) {
            sql = "UPDATE articles SET statut = CAST(? AS article_statut), date_publication = NULL, updated_at = ? WHERE id = ?";
        } else {
            sql = "UPDATE articles SET statut = CAST(? AS article_statut), updated_at = ? WHERE id = ?";
        }

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setObject(2, OffsetDateTime.now());
            statement.setInt(3, articleId);
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
