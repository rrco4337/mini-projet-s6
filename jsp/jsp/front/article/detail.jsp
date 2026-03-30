<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
  <article class="bg-white rounded-2xl border border-stone shadow-editorial p-6 sm:p-10">
    <header class="mb-8 pb-6 border-b border-stone">
      <c:if test="${not empty article.categories}">
        <div class="mb-4 flex flex-wrap gap-2">
          <c:forEach items="${article.categories}" var="cat">
            <a href="/categorie/${cat.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
              <c:out value="${cat.nom}" />
            </a>
          </c:forEach>
        </div>
      </c:if>
      <c:if test="${empty article.categories and article.categorie != null}">
        <a href="/categorie/${article.categorie.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-4">
          <c:out value="${article.categorie.nom}" />
        </a>
      </c:if>

      <h1 class="font-serif text-4xl sm:text-5xl leading-tight font-bold tracking-tight"><c:out value="${article.titre}" /></h1>

      <c:if test="${not empty article.sousTitre}">
        <h2 class="mt-4 text-xl sm:text-2xl text-gray-600 leading-relaxed"><c:out value="${article.sousTitre}" /></h2>
      </c:if>

      <div class="mt-6 flex flex-wrap items-center gap-4 text-sm text-gray-500">
        <c:if test="${article.datePublication != null}">
          <span>
            <time datetime="${article.datePublication}">
              <fmt:parseDate value="${article.datePublication}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
              <fmt:formatDate value="${parsedDate}" pattern="dd MMMM yyyy a HH:mm" />
            </time>
          </span>
        </c:if>
        <span>${article.vues} vue(s)</span>
      </div>
    </header>

    <c:if test="${not empty article.chapeau}">
      <div class="text-xl leading-relaxed text-gray-700 border-l-2 border-gray-300 pl-5 mb-8">
        <c:out value="${article.chapeau}" />
      </div>
    </c:if>

    <c:if test="${not empty article.galleryImages}">
      <section class="mb-8">
        <h3 class="font-serif text-2xl font-semibold mb-4">Galerie</h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <c:forEach items="${article.galleryImages}" var="img">
            <div>
              <figure>
                <img src="${img.url}" alt="${fn:escapeXml(empty img.alt ? 'Illustration de l article' : img.alt)}" class="w-full h-64 object-cover rounded-xl border border-stone" />
              </figure>
            </div>
          </c:forEach>
        </div>
      </section>
    </c:if>
    <c:if test="${empty article.galleryImages and not empty article.imageUrl}">
      <figure class="mb-8">
        <img src="${article.imageUrl}" alt="${fn:escapeXml(empty article.imageAlt ? 'Illustration de l article' : article.imageAlt)}" class="w-full h-auto rounded-xl border border-stone" />
      </figure>
    </c:if>

    <section class="article-content text-[1.05rem] leading-8 text-gray-800">
      ${article.contenu}
    </section>
  </article>

  <div class="mt-8 flex flex-wrap gap-3">
    <a href="/" class="inline-flex items-center rounded-lg border border-stone px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Retour a l'accueil</a>
    <c:if test="${article.categorie != null}">
      <a href="/categorie/${article.categorie.slug}" class="inline-flex items-center rounded-lg bg-ink px-4 py-2 text-sm font-semibold text-white hover:bg-black transition-colors">Voir la categorie</a>
    </c:if>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
