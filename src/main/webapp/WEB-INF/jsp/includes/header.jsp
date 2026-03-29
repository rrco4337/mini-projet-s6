<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><c:out value="${pageTitle}" default="Iran War News" /> - Iran War News</title>
  <c:if test="${not empty metaDescription}">
    <meta name="description" content="<c:out value="${metaDescription}" />" />
  </c:if>
  <c:if test="${not empty metaKeywords}">
    <meta name="keywords" content="<c:out value="${metaKeywords}" />" />
  </c:if>
  <meta name="robots" content="<c:out value="${metaRobots}" default="index, follow" />" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <link rel="stylesheet" href="/css/style.css" />
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
  <div class="container">
    <a class="navbar-brand" href="/">
      <i class="bi bi-newspaper me-2"></i>Iran War News
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="/"><i class="bi bi-house me-1"></i>Accueil</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            <i class="bi bi-folder me-1"></i>Categories
          </a>
          <ul class="dropdown-menu">
            <c:forEach items="${navCategories}" var="cat">
              <li><a class="dropdown-item" href="/categorie/${cat.slug}"><c:out value="${cat.nom}" /></a></li>
            </c:forEach>
            <c:if test="${empty navCategories}">
              <li><span class="dropdown-item text-muted">Aucune categorie</span></li>
            </c:if>
          </ul>
        </li>
      </ul>
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="/admin"><i class="bi bi-gear me-1"></i>Admin</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
