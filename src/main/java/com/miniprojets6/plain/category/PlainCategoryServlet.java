package com.miniprojets6.plain.category;

import com.miniprojets6.plain.auth.PlainAuthSupport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet(urlPatterns = {
    "/noframework/admin/categories",
    "/noframework/admin/categories/new",
    "/noframework/admin/categories/edit",
    "/noframework/admin/categories/delete"
})
public class PlainCategoryServlet extends HttpServlet {
    private final PlainCategoryDao categoryDao = new PlainCategoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!PlainAuthSupport.requireAuth(request, response)) {
            return;
        }

        String path = request.getServletPath();
        try {
            if ("/noframework/admin/categories/new".equals(path)) {
                request.setAttribute("submitLabel", "Creer");
                request.setAttribute("formAction", "/noframework/admin/categories/new");
                request.getRequestDispatcher("/WEB-INF/jsp/plain/categories/form.jsp").forward(request, response);
                return;
            }

            if ("/noframework/admin/categories/edit".equals(path)) {
                int id = parseId(request.getParameter("id"));
                PlainCategoryForm form = categoryDao.findForEdit(id);
                if (form == null) {
                    response.sendRedirect(request.getContextPath() + "/noframework/admin/categories?missing=1");
                    return;
                }
                request.setAttribute("form", form);
                request.setAttribute("submitLabel", "Mettre a jour");
                request.setAttribute("formAction", "/noframework/admin/categories/edit?id=" + id);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/categories/form.jsp").forward(request, response);
                return;
            }

            request.setAttribute("categories", categoryDao.findAll());
            applyFlashMessages(request);
            request.getRequestDispatcher("/WEB-INF/jsp/plain/categories/list.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL categories sans framework", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!PlainAuthSupport.requireAuth(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/noframework/admin/categories/delete".equals(path)) {
            handleDelete(request, response);
            return;
        }

        PlainCategoryForm form = new PlainCategoryForm();
        form.setNom(trim(request.getParameter("nom")));
        form.setSlug(toSlug(trim(request.getParameter("slug"))));
        form.setDescription(trim(request.getParameter("description")));

        List<String> errors = validate(form);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("form", form);
            if ("/noframework/admin/categories/edit".equals(path)) {
                request.setAttribute("submitLabel", "Mettre a jour");
                request.setAttribute("formAction", "/noframework/admin/categories/edit?id=" + parseId(request.getParameter("id")));
            } else {
                request.setAttribute("submitLabel", "Creer");
                request.setAttribute("formAction", "/noframework/admin/categories/new");
            }
            request.getRequestDispatcher("/WEB-INF/jsp/plain/categories/form.jsp").forward(request, response);
            return;
        }

        try {
            if ("/noframework/admin/categories/edit".equals(path)) {
                categoryDao.update(parseId(request.getParameter("id")), form);
                response.sendRedirect(request.getContextPath() + "/noframework/admin/categories?updated=1");
            } else {
                categoryDao.create(form);
                response.sendRedirect(request.getContextPath() + "/noframework/admin/categories?created=1");
            }
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL categories sans framework", ex);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            categoryDao.delete(parseId(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/noframework/admin/categories?deleted=1");
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL suppression categorie sans framework", ex);
        }
    }

    private void applyFlashMessages(HttpServletRequest request) {
        if ("1".equals(request.getParameter("created"))) {
            request.setAttribute("successMessage", "Categorie creee avec succes.");
        } else if ("1".equals(request.getParameter("updated"))) {
            request.setAttribute("successMessage", "Categorie mise a jour avec succes.");
        } else if ("1".equals(request.getParameter("deleted"))) {
            request.setAttribute("successMessage", "Categorie supprimee avec succes.");
        }
    }

    private List<String> validate(PlainCategoryForm form) {
        List<String> errors = new ArrayList<>();
        if (form.getNom() == null || form.getNom().isBlank()) {
            errors.add("Le nom est obligatoire.");
        }
        if (form.getSlug() == null || form.getSlug().isBlank()) {
            errors.add("Le slug est obligatoire.");
        }
        return errors;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private int parseId(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception ex) {
            return 0;
        }
    }

    private String toSlug(String input) {
        if (input == null || input.isBlank()) {
            return "";
        }
        String lower = input.toLowerCase(Locale.ROOT);
        String normalized = lower
            .replace('à', 'a').replace('â', 'a').replace('ä', 'a')
            .replace('é', 'e').replace('è', 'e').replace('ê', 'e').replace('ë', 'e')
            .replace('î', 'i').replace('ï', 'i')
            .replace('ô', 'o').replace('ö', 'o')
            .replace('ù', 'u').replace('û', 'u').replace('ü', 'u')
            .replace('ç', 'c');

        return normalized
            .replaceAll("[^a-z0-9]+", "-")
            .replaceAll("^-+|-+$", "");
    }
}
