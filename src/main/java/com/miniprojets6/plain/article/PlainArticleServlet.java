package com.miniprojets6.plain.article;

import com.miniprojets6.plain.auth.PlainAuthSupport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;

@WebServlet(urlPatterns = {
    "/noframework/admin/articles",
    "/noframework/admin/articles/drafts",
    "/noframework/admin/articles/archives",
    "/noframework/admin/articles/new",
    "/noframework/admin/articles/edit",
    "/noframework/admin/articles/delete",
    "/noframework/admin/articles/archive",
    "/noframework/admin/articles/restore"
})
public class PlainArticleServlet extends HttpServlet {
    private final PlainArticleDao articleDao = new PlainArticleDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!PlainAuthSupport.requireAuth(request, response)) {
            return;
        }

        String path = request.getServletPath();
        try {
            if ("/noframework/admin/articles/new".equals(path)) {
                request.setAttribute("categories", articleDao.findAllCategories());
                request.setAttribute("statuts", List.of("brouillon", "publie", "archive"));
                request.setAttribute("submitLabel", "Creer");
                request.setAttribute("formAction", "/noframework/admin/articles/new");
                request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/form.jsp").forward(request, response);
                return;
            }

            if ("/noframework/admin/articles/edit".equals(path)) {
                int id = parseId(request.getParameter("id"));
                PlainArticleCreateRequest existing = articleDao.findForEdit(id);
                if (existing == null) {
                    response.sendRedirect(request.getContextPath() + "/noframework/admin/articles?missing=1");
                    return;
                }
                request.setAttribute("form", existing);
                request.setAttribute("selectedCategoryIds", new HashSet<>(existing.getCategoryIds()));
                request.setAttribute("categories", articleDao.findAllCategories());
                request.setAttribute("statuts", List.of("brouillon", "publie", "archive"));
                request.setAttribute("submitLabel", "Mettre a jour");
                request.setAttribute("formAction", "/noframework/admin/articles/edit?id=" + id);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/form.jsp").forward(request, response);
                return;
            }

            if ("/noframework/admin/articles/drafts".equals(path)) {
                request.setAttribute("articles", articleDao.findByStatus("brouillon"));
                applyFlashMessages(request);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/drafts.jsp").forward(request, response);
                return;
            }

            if ("/noframework/admin/articles/archives".equals(path)) {
                request.setAttribute("articles", articleDao.findByStatus("archive"));
                applyFlashMessages(request);
                request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/archives.jsp").forward(request, response);
                return;
            }

            request.setAttribute("articles", articleDao.findAll());
            applyFlashMessages(request);
            request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/list.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL dans module sans framework", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!PlainAuthSupport.requireAuth(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/noframework/admin/articles/delete".equals(path)) {
            handleDelete(request, response);
            return;
        }

        if ("/noframework/admin/articles/archive".equals(path)) {
            handleArchive(request, response);
            return;
        }

        if ("/noframework/admin/articles/restore".equals(path)) {
            handleRestore(request, response);
            return;
        }

        PlainArticleCreateRequest createRequest = new PlainArticleCreateRequest();
        createRequest.setTitre(trim(request.getParameter("titre")));
        createRequest.setSlug(toSlug(trim(request.getParameter("slug"))));
        createRequest.setSousTitre(trim(request.getParameter("sousTitre")));
        createRequest.setChapeau(trim(request.getParameter("chapeau")));
        createRequest.setContenu(trim(request.getParameter("contenu")));
        createRequest.setStatut(normalizeStatut(trim(request.getParameter("statut"))));
        createRequest.setaLaUne("on".equals(request.getParameter("aLaUne")));
        createRequest.setMetaTitle(trim(request.getParameter("metaTitle")));
        createRequest.setMetaDescription(trim(request.getParameter("metaDescription")));
        createRequest.setMetaKeywords(trim(request.getParameter("metaKeywords")));

        String[] categoryIds = request.getParameterValues("categoryIds");
        if (categoryIds != null) {
            for (String rawId : categoryIds) {
                try {
                    createRequest.getCategoryIds().add(Integer.parseInt(rawId));
                } catch (NumberFormatException ignored) {
                    // Ignore invalid category id values from client.
                }
            }
        }

        List<String> errors = validate(createRequest);
        if (!errors.isEmpty()) {
            try {
                int editId = parseId(request.getParameter("id"));
                request.setAttribute("errors", errors);
                request.setAttribute("form", createRequest);
                request.setAttribute("selectedCategoryIds", new HashSet<>(createRequest.getCategoryIds()));
                request.setAttribute("categories", articleDao.findAllCategories());
                request.setAttribute("statuts", List.of("brouillon", "publie", "archive"));
                if ("/noframework/admin/articles/edit".equals(path)) {
                    request.setAttribute("submitLabel", "Mettre a jour");
                    request.setAttribute("formAction", "/noframework/admin/articles/edit?id=" + editId);
                } else {
                    request.setAttribute("submitLabel", "Creer");
                    request.setAttribute("formAction", "/noframework/admin/articles/new");
                }
                request.getRequestDispatcher("/WEB-INF/jsp/plain/articles/form.jsp").forward(request, response);
            } catch (SQLException ex) {
                throw new ServletException("Erreur SQL lors de la validation sans framework", ex);
            }
            return;
        }

        try {
            if ("/noframework/admin/articles/edit".equals(path)) {
                int id = parseId(request.getParameter("id"));
                articleDao.update(id, createRequest);
                response.sendRedirect(request.getContextPath() + "/noframework/admin/articles?updated=1");
            } else {
                articleDao.create(createRequest);
                response.sendRedirect(request.getContextPath() + "/noframework/admin/articles?created=1");
            }
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL lors de la creation article sans framework", ex);
        }
    }

    private void handleArchive(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = parseId(request.getParameter("id"));
            articleDao.archive(id);
            response.sendRedirect(request.getContextPath() + "/noframework/admin/articles?archived=1");
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL lors de l'archivage article", ex);
        }
    }

    private void handleRestore(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = parseId(request.getParameter("id"));
            articleDao.restoreToDraft(id);
            response.sendRedirect(request.getContextPath() + "/noframework/admin/articles/archives?restored=1");
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL lors de la restauration article", ex);
        }
    }

    private void applyFlashMessages(HttpServletRequest request) {
        if ("1".equals(request.getParameter("created"))) {
            request.setAttribute("successMessage", "Article cree avec succes.");
        } else if ("1".equals(request.getParameter("updated"))) {
            request.setAttribute("successMessage", "Article mis a jour avec succes.");
        } else if ("1".equals(request.getParameter("deleted"))) {
            request.setAttribute("successMessage", "Article supprime avec succes.");
        } else if ("1".equals(request.getParameter("archived"))) {
            request.setAttribute("successMessage", "Article archive avec succes.");
        } else if ("1".equals(request.getParameter("restored"))) {
            request.setAttribute("successMessage", "Article restaure en brouillon.");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = parseId(request.getParameter("id"));
            articleDao.delete(id);
            response.sendRedirect(request.getContextPath() + "/noframework/admin/articles?deleted=1");
        } catch (SQLException ex) {
            throw new ServletException("Erreur SQL lors de la suppression article sans framework", ex);
        }
    }

    private List<String> validate(PlainArticleCreateRequest request) {
        List<String> errors = new ArrayList<>();
        if (request.getTitre() == null || request.getTitre().isBlank()) {
            errors.add("Le titre est obligatoire.");
        }
        if (request.getSlug() == null || request.getSlug().isBlank()) {
            errors.add("Le slug est obligatoire.");
        }
        if (request.getContenu() == null || request.getContenu().isBlank()) {
            errors.add("Le contenu est obligatoire.");
        }
        return errors;
    }

    private String normalizeStatut(String statut) {
        if ("publie".equals(statut) || "archive".equals(statut)) {
            return statut;
        }
        return "brouillon";
    }

    private int parseId(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception ex) {
            return 0;
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
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
