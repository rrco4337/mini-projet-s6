<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Acces refuse" />

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<main class="error-page">
  <div class="container text-center animate-fadeIn">
    <div class="error-code">403</div>
    <h1 class="h2 mb-3">Acces refuse</h1>
    <p class="error-message">
      Vous n'avez pas les droits necessaires pour acceder a cette page.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="/" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="/login" class="btn btn-outline-secondary">
        <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
      </a>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
