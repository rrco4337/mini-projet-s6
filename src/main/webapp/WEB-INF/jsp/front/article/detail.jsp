<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<main class="container py-4">
  <article>
    <header class="mb-4">
      <c:if test="${article.categorie != null}">
        <a href="/categorie/${article.categorie.slug}" class="badge bg-secondary text-decoration-none mb-2">
          <c:out value="${article.categorie.nom}" />
        </a>
      </c:if>

      <h1 class="display-5 fw-bold"><c:out value="${article.titre}" /></h1>

      <c:if test="${not empty article.sousTitre}">
        <h2 class="h4 text-muted"><c:out value="${article.sousTitre}" /></h2>
      </c:if>

      <div class="article-meta mt-3">
        <c:if test="${article.datePublication != null}">
          <span>
            <i class="bi bi-calendar me-1"></i>
            <time datetime="${article.datePublication}">
              <fmt:parseDate value="${article.datePublication}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
              <fmt:formatDate value="${parsedDate}" pattern="dd MMMM yyyy a HH:mm" />
            </time>
          </span>
        </c:if>
        <span class="ms-3"><i class="bi bi-eye me-1"></i>${article.vues} vue(s)</span>
      </div>
    </header>

    <c:if test="${not empty article.chapeau}">
      <div class="lead border-start border-4 border-primary ps-3 mb-4">
        <c:out value="${article.chapeau}" />
      </div>
    </c:if>

    <section class="article-content">
      ${article.contenu}
    </section>
  </article>

  <hr class="my-5" />

  <div class="mb-4">
    <a href="/" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Retour a l'accueil</a>
    <c:if test="${article.categorie != null}">
      <a href="/categorie/${article.categorie.slug}" class="btn btn-outline-primary">
        <i class="bi bi-folder me-1"></i>Voir la categorie
      </a>
    </c:if>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
