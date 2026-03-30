package com.miniprojets6.plain.admin;

import com.miniprojets6.plain.article.PlainArticleDao;
import com.miniprojets6.plain.article.PlainArticleRow;
import com.miniprojets6.plain.article.PlainDb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PlainAdminDao {
    private final PlainArticleDao articleDao = new PlainArticleDao();

    public int countArticles() throws SQLException {
        return count("SELECT COUNT(*) FROM articles");
    }

    public int countCategories() throws SQLException {
        return count("SELECT COUNT(*) FROM categories");
    }

    public int countUsers() throws SQLException {
        return count("SELECT COUNT(*) FROM users");
    }

    public int countPublished() throws SQLException {
        return articleDao.countByStatus("publie");
    }

    public int countDrafts() throws SQLException {
        return articleDao.countByStatus("brouillon");
    }

    public int countArchived() throws SQLException {
        return articleDao.countByStatus("archive");
    }

    public int countFeatured() throws SQLException {
        return articleDao.countFeatured();
    }

    public int totalViews() throws SQLException {
        return articleDao.totalViews();
    }

    public PlainArticleRow mostViewedPublished() throws SQLException {
        return articleDao.findMostViewedPublished();
    }

    public List<PlainArticleRow> recentArticles() throws SQLException {
        return articleDao.findAll().stream().limit(6).toList();
    }

    private int count(String sql) throws SQLException {
        try (Connection connection = PlainDb.openConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }
}
