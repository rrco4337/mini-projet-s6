package com.miniprojets6.plain.front;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet(urlPatterns = {"/", "/noframework", "/noframework/home", "/noframework/article"})
public class PlainHomeServlet extends HttpServlet {
    private final PlainFrontDao frontDao = new PlainFrontDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/noframework/home");
            return;
        }

        try {
            if ("/noframework/article".equals(path)) {
                String slug = request.getParameter("slug");
                PlainFrontArticleRow article = frontDao.findPublishedBySlug(slug);
                if (article == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                request.setAttribute("pageTitle", article.getTitre());
                request.setAttribute("metaDescription", article.getChapeau());
                request.setAttribute("metaKeywords", article.getCategoryNames());
                request.setAttribute("metaRobots", "index, follow");
                request.setAttribute("navCategories", frontDao.findNavCategories());
                request.setAttribute("article", article);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/front/detail.jsp").forward(request, response);
                return;
            }

            String[] selectedCategorySlugs = request.getParameterValues("categorySlugs");
            String selectedPublicationDate = request.getParameter("publicationDate");
            List<PlainFrontCategory> navCategories = frontDao.findNavCategories();

            request.setAttribute("pageTitle", "Accueil");
            request.setAttribute("metaDescription", "Actualites, analyses geopolitique et decryptage quotidien sur le conflit en Iran.");
            request.setAttribute("metaKeywords", "iran, guerre, actualites, analyses, geopolitique");
            request.setAttribute("metaRobots", "index, follow");
            request.setAttribute("navCategories", navCategories);
            request.setAttribute("selectedCategorySlugs", selectedCategorySlugs == null ? List.of() : Arrays.asList(selectedCategorySlugs));
            request.setAttribute("selectedPublicationDate", selectedPublicationDate == null ? "" : selectedPublicationDate);
            request.setAttribute("featuredArticles", frontDao.findFeaturedPublished(3));
            request.setAttribute("articles", frontDao.findLatestPublished(20, selectedCategorySlugs, selectedPublicationDate));
            request.getRequestDispatcher("/WEB-INF/jsp/plain/front/home.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL front-office", ex);
        }
    }
}
