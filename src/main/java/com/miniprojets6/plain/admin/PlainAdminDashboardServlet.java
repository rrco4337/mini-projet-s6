package com.miniprojets6.plain.admin;

import com.miniprojets6.plain.auth.PlainAuthSupport;
import com.miniprojets6.plain.auth.PlainAuthUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/noframework/admin/dashboard")
public class PlainAdminDashboardServlet extends HttpServlet {
    private final PlainAdminDao adminDao = new PlainAdminDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!PlainAuthSupport.requireAuth(request, response)) {
            return;
        }

        PlainAuthUser user = PlainAuthSupport.getCurrentUser(request);
        request.setAttribute("authUser", user);

        try {
            int totalArticles = adminDao.countArticles();
            int publishedCount = adminDao.countPublished();
            int draftCount = adminDao.countDrafts();
            int archivedCount = adminDao.countArchived();

            request.setAttribute("totalArticles", totalArticles);
            request.setAttribute("publishedCount", publishedCount);
            request.setAttribute("draftCount", draftCount);
            request.setAttribute("archivedCount", archivedCount);
            request.setAttribute("featuredCount", adminDao.countFeatured());
            request.setAttribute("totalViews", adminDao.totalViews());
            request.setAttribute("totalCategories", adminDao.countCategories());
            request.setAttribute("recentArticles", adminDao.recentArticles());
            request.setAttribute("mostViewedArticle", adminDao.mostViewedPublished());
            request.setAttribute("statusData", "[" + publishedCount + "," + draftCount + "," + archivedCount + "]");
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL dashboard", ex);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/plain/admin/dashboard.jsp").forward(request, response);
    }
}
