package com.miniprojets6.plain.web;

import com.miniprojets6.plain.front.PlainFrontDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/noframework/error")
public class PlainErrorServlet extends HttpServlet {
    private final PlainFrontDao frontDao = new PlainFrontDao();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer statusCode = (Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        String requestUri = (String) request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);

        int code = statusCode == null ? HttpServletResponse.SC_INTERNAL_SERVER_ERROR : statusCode;

        request.setAttribute("metaRobots", "noindex, nofollow");
        request.setAttribute("failedPath", requestUri == null ? "" : requestUri);

        try {
            request.setAttribute("navCategories", frontDao.findNavCategories());
        } catch (SQLException ignored) {
            // Keep error rendering resilient even if DB is unavailable.
        }

        switch (code) {
            case HttpServletResponse.SC_FORBIDDEN -> {
                request.setAttribute("pageTitle", "Acces refuse");
                request.setAttribute("metaDescription", "Erreur 403: acces refuse.");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/error/403.jsp").forward(request, response);
            }
            case HttpServletResponse.SC_NOT_FOUND -> {
                request.setAttribute("pageTitle", "Page non trouvee");
                request.setAttribute("metaDescription", "Erreur 404: page non trouvee.");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/error/404.jsp").forward(request, response);
            }
            default -> {
                request.setAttribute("pageTitle", "Erreur serveur");
                request.setAttribute("metaDescription", "Erreur 500: une erreur serveur inattendue s est produite.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/error/500.jsp").forward(request, response);
            }
        }
    }
}
