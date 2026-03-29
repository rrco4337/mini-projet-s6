<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Page non trouvee" />

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<main class="error-page">
  <div class="container text-center animate-fadeIn">
    <div class="error-code">404</div>
    <h1 class="h2 mb-3">Page non trouvee</h1>
    <p class="error-message">
      La page que vous recherchez n'existe pas ou a ete deplacee.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="/" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="javascript:history.back()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-2"></i>Page precedente
      </a>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
