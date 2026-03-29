<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><c:out value="${mode == 'edit' ? 'Modifier' : 'Nouvelle'}"/> categorie</title>
  <meta name="description" content="Formulaire backoffice pour creer ou modifier une categorie Iran War News." />
  <meta name="keywords" content="formulaire categorie, administration, iran war news" />
  <meta name="robots" content="noindex, nofollow" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container py-4" style="max-width: 760px;">
  <h1 class="h3 mb-3">
    <c:out value="${mode == 'edit' ? 'Modifier' : 'Creer'}"/> une categorie
  </h1>

  <div class="card shadow-sm">
    <div class="card-body">
      <c:choose>
        <c:when test="${mode == 'edit'}">
          <form:form method="post" modelAttribute="categoryForm" action="/categories/${categoryId}">
            <jsp:include page="_fields.jsp" />
          </form:form>
        </c:when>
        <c:otherwise>
          <form:form method="post" modelAttribute="categoryForm" action="/categories">
            <jsp:include page="_fields.jsp" />
          </form:form>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
</body>
</html>
