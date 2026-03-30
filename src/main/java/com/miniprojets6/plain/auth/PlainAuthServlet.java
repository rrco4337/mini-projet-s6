package com.miniprojets6.plain.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/noframework/login", "/noframework/logout"})
public class PlainAuthServlet extends HttpServlet {
    private final PlainAuthDao authDao = new PlainAuthDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/noframework/logout".equals(path)) {
            if (request.getSession(false) != null) {
                request.getSession(false).invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/noframework/login?logout=1");
            return;
        }

        if (PlainAuthSupport.getCurrentUser(request) != null) {
            response.sendRedirect(request.getContextPath() + "/noframework/admin/dashboard");
            return;
        }

        request.setAttribute("next", request.getParameter("next"));
        request.getRequestDispatcher("/WEB-INF/jsp/plain/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");
        String next = PlainAuthSupport.normalizeNext(request.getParameter("next"));

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Identifiants obligatoires.");
            request.setAttribute("next", next);
            request.getRequestDispatcher("/WEB-INF/jsp/plain/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            PlainAuthUser user = authDao.authenticate(username, password);
            if (user == null) {
                request.setAttribute("error", "Nom d'utilisateur ou mot de passe invalide.");
                request.setAttribute("next", next);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/auth/login.jsp").forward(request, response);
                return;
            }

            request.getSession(true).setAttribute(PlainAuthSupport.SESSION_USER_KEY, user);
            response.sendRedirect(request.getContextPath() + next);
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL pendant authentification", ex);
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
