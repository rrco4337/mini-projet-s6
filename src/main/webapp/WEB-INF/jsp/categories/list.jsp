<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Categories - BackOffice</title>
  <meta name="description" content="Page backoffice de gestion des categories Iran War News." />
  <meta name="keywords" content="categories, administration, iran war news" />
  <meta name="robots" content="noindex, nofollow" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h3 mb-0">Gestion des categories</h1>
    <a class="btn btn-primary" href="/categories/new">Nouvelle categorie</a>
  </div>

  <c:if test="${not empty successMessage}">
    <div class="alert alert-success" role="alert">${successMessage}</div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">${errorMessage}</div>
  </c:if>

  <div class="card shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Slug</th>
            <th>Description</th>
            <th class="text-end">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${categories}" var="cat">
            <tr>
              <td>${cat.id}</td>
              <td>${cat.nom}</td>
              <td>${cat.slug}</td>
              <td>${cat.description}</td>
              <td class="text-end">
                <a class="btn btn-sm btn-outline-secondary" href="/categories/${cat.id}/edit">Modifier</a>
                <form action="/categories/${cat.id}/delete" method="post" class="d-inline">
                  <button type="submit" class="btn btn-sm btn-outline-danger"
                          onclick="return confirm('Supprimer cette categorie ?');">
                    Supprimer
                  </button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty categories}">
            <tr>
              <td colspan="5" class="text-center py-4 text-muted">Aucune categorie disponible.</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
