<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestion des articles - BackOffice</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin"><i class="bi bi-gear me-2"></i>BackOffice</a>
    <div class="navbar-nav ms-auto">
      <a class="nav-link" href="/">Voir le site</a>
    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h3 mb-0"><i class="bi bi-newspaper me-2"></i>Gestion des articles</h1>
    <a class="btn btn-primary" href="/admin/articles/new">
      <i class="bi bi-plus-lg me-1"></i>Nouvel article
    </a>
  </div>

  <c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="bi bi-check-circle me-2"></i>${successMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="bi bi-exclamation-circle me-2"></i>${errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Titre</th>
            <th>Categorie</th>
            <th>Statut</th>
            <th>A la une</th>
            <th>Vues</th>
            <th class="text-end">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${articles}" var="article">
            <tr>
              <td>${article.id}</td>
              <td>
                <strong><c:out value="${article.titre}" /></strong>
                <br><small class="text-muted">${article.slug}</small>
              </td>
              <td>
                <c:if test="${article.categorie != null}">
                  <span class="badge bg-secondary"><c:out value="${article.categorie.nom}" /></span>
                </c:if>
                <c:if test="${article.categorie == null}">
                  <span class="text-muted">-</span>
                </c:if>
              </td>
              <td>
                <c:choose>
                  <c:when test="${article.statut == 'publie'}">
                    <span class="badge bg-success">Publie</span>
                  </c:when>
                  <c:when test="${article.statut == 'brouillon'}">
                    <span class="badge bg-warning text-dark">Brouillon</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-secondary">Archive</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${article.ALaUne}">
                  <i class="bi bi-star-fill text-warning"></i>
                </c:if>
                <c:if test="${!article.ALaUne}">
                  <i class="bi bi-star text-muted"></i>
                </c:if>
              </td>
              <td>${article.vues}</td>
              <td class="text-end">
                <a class="btn btn-sm btn-outline-primary" href="/article/${article.slug}" target="_blank" title="Voir">
                  <i class="bi bi-eye"></i>
                </a>
                <a class="btn btn-sm btn-outline-secondary" href="/admin/articles/${article.id}/edit" title="Modifier">
                  <i class="bi bi-pencil"></i>
                </a>
                <form action="/admin/articles/${article.id}/delete" method="post" class="d-inline">
                  <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer"
                          onclick="return confirm('Supprimer cet article ?');">
                    <i class="bi bi-trash"></i>
                  </button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty articles}">
            <tr>
              <td colspan="7" class="text-center py-4 text-muted">Aucun article disponible.</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <div class="mt-4">
    <a href="/admin" class="btn btn-outline-secondary">
      <i class="bi bi-arrow-left me-1"></i>Retour au tableau de bord
    </a>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
