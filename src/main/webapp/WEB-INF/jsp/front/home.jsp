<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

<!-- <section class="relative overflow-hidden border-b border-stone bg-gradient-to-br from-neutral-50 via-white to-neutral-100">
  <div class="absolute inset-0 opacity-50" style="background-image: radial-gradient(circle at 10% 10%, rgba(17,17,17,0.06) 1px, transparent 1px); background-size: 20px 20px;"></div>
  <div class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-20">
    <p class="text-xs uppercase tracking-[0.22em] text-gray-500 font-semibold">Edition Continue</p>
    <h1 class="mt-3 font-serif text-4xl sm:text-5xl lg:text-6xl leading-tight font-bold max-w-4xl">Iran War News</h1>
    <p class="mt-4 text-lg sm:text-xl text-gray-700 max-w-3xl">Actualites, analyses geopolitique et decryptage quotidien sur le conflit en Iran.</p>
  </div>
</section> -->

<main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10">

  <section class="mb-6">
    <div class="rounded-2xl border border-stone bg-white shadow-editorial">
      <div class="p-5 sm:p-6">
        <form method="get" action="/">
          <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-end">
            <div class="md:col-span-8">
              <p class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Categories</p>
              <div class="flex flex-wrap gap-2">
                <c:forEach items="${navCategories}" var="cat">
                  <c:set var="isSelected" value="false" />
                  <c:forEach items="${selectedCategorySlugs}" var="selectedSlug">
                    <c:if test="${selectedSlug == cat.slug}">
                      <c:set var="isSelected" value="true" />
                    </c:if>
                  </c:forEach>
                  <label class="cursor-pointer">
                    <input type="checkbox" name="categorySlugs" value="${cat.slug}" class="peer sr-only" ${isSelected ? 'checked' : ''} />
                    <span class="inline-flex items-center gap-2 rounded-full border border-stone px-3 py-1.5 text-xs uppercase tracking-wider text-gray-600 transition-colors hover:text-ink hover:border-gray-400 peer-checked:border-ink peer-checked:bg-ink peer-checked:text-white">
                      <c:out value="${cat.nom}" />
                    </span>
                  </label>
                </c:forEach>
              </div>
            </div>

            <div class="md:col-span-4">
              <label for="publicationDate" class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Date de publication</label>
              <input id="publicationDate" name="publicationDate" type="date" class="w-full rounded-lg border-stone focus:border-ink focus:ring-ink text-sm"
                     value="${selectedPublicationDate}" />
            </div>

            <div class="md:col-span-12 flex gap-2 justify-end">
              <button type="submit" class="px-5 py-2.5 rounded-lg bg-ink text-white text-sm font-semibold hover:bg-black transition-colors">
                Rechercher
              </button>
              <a href="/" class="px-4 py-2.5 rounded-lg border border-stone text-sm text-gray-700 hover:bg-gray-50 transition-colors">Reset</a>
            </div>
          </div>
        </form>
      </div>
    </div>
  </section>

  <c:if test="${not empty featuredArticles}">
    <section class="mb-10">
      <div class="flex items-center justify-between mb-5">
        <h2 class="font-serif text-3xl font-semibold tracking-tight">A la une</h2>
        <span class="h-px bg-stone flex-1 ml-5"></span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <c:forEach items="${featuredArticles}" var="article" end="2">
          <article class="group rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:-translate-y-1 transition-all duration-300">
              <c:if test="${not empty article.imageUrl}">
                <img src="${article.imageUrl}" alt="${fn:escapeXml(empty article.imageAlt ? 'Illustration de l article' : article.imageAlt)}" class="h-48 w-full object-cover" />
              </c:if>
              <div class="p-5">
                <c:if test="${not empty article.categories}">
                  <div class="mb-3 flex flex-wrap gap-2">
                    <c:forEach items="${article.categories}" var="cat">
                      <a href="/?categorySlugs=${cat.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
                        <c:out value="${cat.nom}" />
                      </a>
                    </c:forEach>
                  </div>
                </c:if>
                <c:if test="${empty article.categories and article.categorie != null}">
                  <a href="/?categorySlugs=${article.categorie.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-3">
                    <c:out value="${article.categorie.nom}" />
                  </a>
                </c:if>
                <h3 class="font-serif text-2xl leading-snug font-semibold group-hover:text-accent transition-colors">
                  <a href="/article/${article.slug}">
                    <c:out value="${article.titre}" />
                  </a>
                </h3>
                <c:if test="${not empty article.chapeau}">
                  <p class="mt-3 text-gray-600 leading-relaxed">
                    <c:out value="${article.chapeau}" />
                  </p>
                </c:if>
              </div>
              <div class="px-5 py-4 border-t border-stone text-sm text-gray-500">
                ${article.vues} vues
              </div>
          </article>
        </c:forEach>
      </div>
    </section>
  </c:if>

  <section>
    <div class="flex items-center justify-between mb-5">
      <h2 class="font-serif text-3xl font-semibold tracking-tight">Derniers articles</h2>
      <span class="h-px bg-stone flex-1 ml-5"></span>
    </div>

    <c:if test="${empty articles}">
      <div class="rounded-xl border border-stone bg-white p-5 text-gray-600">
        Aucun article disponible pour le moment.
      </div>
    </c:if>

    <div class="grid grid-cols-1 gap-6">
      <c:forEach items="${articles}" var="article">
        <article class="rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:shadow-xl transition-shadow duration-300">
          <div class="p-5 sm:p-6">
            <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-start">
                <c:if test="${not empty article.imageUrl}">
                  <div class="md:col-span-4">
                    <img src="${article.imageUrl}" alt="${fn:escapeXml(empty article.imageAlt ? 'Illustration de l article' : article.imageAlt)}" class="w-full h-52 object-cover rounded-xl" />
                  </div>
                </c:if>

                <div class="${not empty article.imageUrl ? 'md:col-span-8' : 'md:col-span-12'}">
                  <c:if test="${not empty article.categories}">
                    <div class="mb-3 flex flex-wrap gap-2">
                      <c:forEach items="${article.categories}" var="cat">
                        <a href="/?categorySlugs=${cat.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
                          <c:out value="${cat.nom}" />
                        </a>
                      </c:forEach>
                    </div>
                  </c:if>
                  <c:if test="${empty article.categories and article.categorie != null}">
                    <a href="/?categorySlugs=${article.categorie.slug}" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-3">
                      <c:out value="${article.categorie.nom}" />
                    </a>
                  </c:if>
                  <h3 class="font-serif text-3xl leading-tight font-semibold mb-2 hover:text-accent transition-colors">
                    <a href="/article/${article.slug}">
                      <c:out value="${article.titre}" />
                    </a>
                  </h3>
                  <c:if test="${not empty article.sousTitre}">
                    <p class="text-gray-500 text-lg mb-2"><c:out value="${article.sousTitre}" /></p>
                  </c:if>
                  <c:if test="${not empty article.chapeau}">
                    <p class="text-gray-700 leading-relaxed"><c:out value="${article.chapeau}" /></p>
                  </c:if>
                  <div class="mt-4 flex flex-wrap items-center gap-4 text-sm text-gray-500">
                    <c:if test="${article.datePublication != null}">
                      <span>
                        <fmt:parseDate value="${article.datePublication}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy" />
                      </span>
                    </c:if>
                    <span>${article.vues} vues</span>
                  </div>
                </div>
              </div>
            </div>
          </article>
      </c:forEach>
    </div>
  </section>

</main>

<%@ include file="/WEB-INF/jsp/includes/footer.jsp" %>
