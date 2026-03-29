<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Erreur serveur" />

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<main class="error-page">
  <div class="container text-center animate-fadeIn">
    <div class="error-code">500</div>
    <h1 class="h2 mb-3">Erreur serveur</h1>
    <p class="error-message">
      Une erreur inattendue s'est produite. Veuillez reessayer plus tard.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="/" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="javascript:location.reload()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-clockwise me-2"></i>Reessayer
      </a>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
