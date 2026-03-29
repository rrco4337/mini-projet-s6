<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<section class="hero-section text-white py-5">
  <div class="container">
    <h1 class="display-4 fw-bold">Iran War News</h1>
    <p class="lead">Actualites et analyses sur le conflit en Iran</p>
  </div>
</section>

<main class="container py-4">

  <c:if test="${not empty featuredArticles}">
    <section class="mb-5">
      <h2 class="h3 mb-4"><i class="bi bi-star me-2"></i>A la une</h2>
      <div class="row">
        <c:forEach items="${featuredArticles}" var="article" end="2">
          <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
              <c:if test="${not empty article.imageUrl}">
                <img src="${article.imageUrl}" alt="${fn:escapeXml(empty article.imageAlt ? 'Illustration de l article' : article.imageAlt)}" class="card-img-top" />
              </c:if>
              <div class="card-body">
                <c:if test="${article.categorie != null}">
                  <a href="/categorie/${article.categorie.slug}" class="badge bg-secondary text-decoration-none mb-2">
                    <c:out value="${article.categorie.nom}" />
                  </a>
                </c:if>
                <h3 class="h5 card-title">
                  <a href="/article/${article.slug}" class="text-decoration-none text-dark">
                    <c:out value="${article.titre}" />
                  </a>
                </h3>
                <c:if test="${not empty article.chapeau}">
                  <p class="card-text text-muted small">
                    <c:out value="${article.chapeau}" />
                  </p>
                </c:if>
              </div>
              <div class="card-footer bg-transparent text-muted small">
                <i class="bi bi-eye me-1"></i>${article.vues} vues
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </section>
  </c:if>

  <section>
    <h2 class="h3 mb-4"><i class="bi bi-newspaper me-2"></i>Derniers articles</h2>

    <c:if test="${empty articles}">
      <div class="alert alert-info">
        <i class="bi bi-info-circle me-2"></i>Aucun article disponible pour le moment.
      </div>
    </c:if>

    <div class="row">
      <c:forEach items="${articles}" var="article">
        <div class="col-12 mb-4">
          <article class="card shadow-sm">
            <div class="card-body">
              <div class="row">
                <c:if test="${not empty article.imageUrl}">
                  <div class="col-md-4 mb-3 mb-md-0">
                    <img src="${article.imageUrl}" alt="${fn:escapeXml(empty article.imageAlt ? 'Illustration de l article' : article.imageAlt)}" class="img-fluid rounded" />
                  </div>
                </c:if>
                <div class="col">
                  <c:if test="${article.categorie != null}">
                    <a href="/categorie/${article.categorie.slug}" class="badge bg-secondary text-decoration-none mb-2">
                      <c:out value="${article.categorie.nom}" />
                    </a>
                  </c:if>
                  <h3 class="h5 mb-2">
                    <a href="/article/${article.slug}" class="text-decoration-none text-dark">
                      <c:out value="${article.titre}" />
                    </a>
                  </h3>
                  <c:if test="${not empty article.sousTitre}">
                    <p class="text-muted mb-2"><c:out value="${article.sousTitre}" /></p>
                  </c:if>
                  <c:if test="${not empty article.chapeau}">
                    <p class="card-text"><c:out value="${article.chapeau}" /></p>
                  </c:if>
                  <div class="text-muted small">
                    <c:if test="${article.datePublication != null}">
                      <span class="me-3">
                        <i class="bi bi-calendar me-1"></i>
                        <fmt:parseDate value="${article.datePublication}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy" />
                      </span>
                    </c:if>
                    <span><i class="bi bi-eye me-1"></i>${article.vues} vues</span>
                  </div>
                </div>
              </div>
            </div>
          </article>
        </div>
      </c:forEach>
    </div>
  </section>

</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
