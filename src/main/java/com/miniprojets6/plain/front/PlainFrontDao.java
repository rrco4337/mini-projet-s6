package com.miniprojets6.plain.front;

import com.miniprojets6.plain.article.PlainDb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class PlainFrontDao {

    public List<PlainFrontCategory> findNavCategories() throws SQLException {
        String sql = "SELECT id, nom, slug FROM categories ORDER BY nom ASC";

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            List<PlainFrontCategory> rows = new ArrayList<>();
            while (rs.next()) {
                rows.add(new PlainFrontCategory(
                    rs.getInt("id"),
                    rs.getString("nom"),
                    rs.getString("slug")
                ));
            }
            return rows;
        }
    }

    public List<PlainFrontArticleRow> findLatestPublished(int limit, String[] categorySlugs, String publicationDate) throws SQLException {
        String baseSql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   a.sous_titre,
                   a.chapeau,
                   a.contenu,
                   a.vues,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                     COALESCE(MIN(c.slug), '') AS primary_category_slug,
                     COALESCE(MIN(c.nom), '') AS primary_category_name,
                     COALESCE(m.fichier, '') AS image_url,
                     COALESCE(m.alt, '') AS image_alt,
                   a.date_publication
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
                 LEFT JOIN medias m ON m.id = a.image_une
            WHERE a.statut = CAST('publie' AS article_statut)
            """;

        List<Object> params = new ArrayList<>();
        if (categorySlugs != null && categorySlugs.length > 0) {
            String placeholders = Arrays.stream(categorySlugs).map(s -> "?").collect(Collectors.joining(","));
            baseSql += """
                AND EXISTS (
                    SELECT 1
                    FROM article_categories acf
                    JOIN categories cf ON cf.id = acf.category_id
                    WHERE acf.article_id = a.id
                      AND cf.slug IN (%s)
                )
                """.formatted(placeholders);
            params.addAll(Arrays.asList(categorySlugs));
        }

        if (publicationDate != null && !publicationDate.isBlank()) {
            baseSql += " AND DATE(a.date_publication) = CAST(? AS DATE) ";
            params.add(publicationDate);
        }

        String sql = baseSql + " GROUP BY a.id, m.fichier, m.alt ORDER BY COALESCE(a.date_publication, a.updated_at) DESC LIMIT ?";

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            int index = 1;
            for (Object param : params) {
                statement.setObject(index++, param);
            }
            statement.setInt(index, limit);
            try (ResultSet rs = statement.executeQuery()) {
                List<PlainFrontArticleRow> rows = new ArrayList<>();
                while (rs.next()) {
                    rows.add(mapArticle(rs));
                }
                return rows;
            }
        }
    }

    public List<PlainFrontArticleRow> findFeaturedPublished(int limit) throws SQLException {
        String sql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   a.sous_titre,
                   a.chapeau,
                   a.contenu,
                   a.vues,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                     COALESCE(MIN(c.slug), '') AS primary_category_slug,
                     COALESCE(MIN(c.nom), '') AS primary_category_name,
                     COALESCE(m.fichier, '') AS image_url,
                     COALESCE(m.alt, '') AS image_alt,
                   a.date_publication
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
                 LEFT JOIN medias m ON m.id = a.image_une
            WHERE a.statut = CAST('publie' AS article_statut)
              AND a.a_la_une = TRUE
                 GROUP BY a.id, m.fichier, m.alt
            ORDER BY COALESCE(a.date_publication, a.updated_at) DESC
            LIMIT ?
            """;

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, limit);
            try (ResultSet rs = statement.executeQuery()) {
                List<PlainFrontArticleRow> rows = new ArrayList<>();
                while (rs.next()) {
                    rows.add(mapArticle(rs));
                }
                return rows;
            }
        }
    }

    public PlainFrontArticleRow findPublishedBySlug(String slug) throws SQLException {
        String sql = """
            SELECT a.id,
                   a.titre,
                   a.slug,
                   a.sous_titre,
                   a.chapeau,
                   a.contenu,
                   a.vues,
                   COALESCE(string_agg(c.nom, ', ' ORDER BY c.nom), '') AS category_names,
                     COALESCE(MIN(c.slug), '') AS primary_category_slug,
                     COALESCE(MIN(c.nom), '') AS primary_category_name,
                     COALESCE(m.fichier, '') AS image_url,
                     COALESCE(m.alt, '') AS image_alt,
                   a.date_publication
            FROM articles a
            LEFT JOIN article_categories ac ON ac.article_id = a.id
            LEFT JOIN categories c ON c.id = ac.category_id
                 LEFT JOIN medias m ON m.id = a.image_une
            WHERE a.slug = ?
              AND a.statut = CAST('publie' AS article_statut)
                 GROUP BY a.id, m.fichier, m.alt
            """;

        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, slug);
            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return mapArticle(rs);
            }
        }
    }

    private PlainFrontArticleRow mapArticle(ResultSet rs) throws SQLException {
        return new PlainFrontArticleRow(
            rs.getInt("id"),
            rs.getString("titre"),
            rs.getString("slug"),
            rs.getString("sous_titre"),
            rs.getString("chapeau"),
            rs.getString("contenu"),
            rs.getInt("vues"),
            rs.getString("category_names"),
            rs.getString("primary_category_slug"),
            rs.getString("primary_category_name"),
            rs.getString("image_url"),
            rs.getString("image_alt"),
            rs.getObject("date_publication", OffsetDateTime.class)
        );
    }
}
