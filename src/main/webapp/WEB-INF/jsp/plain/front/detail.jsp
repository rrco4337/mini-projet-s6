<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.miniprojets6.plain.front.PlainFrontArticleRow" %>
<%
  PlainFrontArticleRow article = (PlainFrontArticleRow) request.getAttribute("article");
%>
<%@ include file="/WEB-INF/jsp/plain/includes/header.jsp" %>

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
  <article class="bg-white rounded-2xl border border-stone shadow-editorial p-6 sm:p-10">
    <header class="mb-8 pb-6 border-b border-stone">
      <% if (article.getPrimaryCategoryName() != null && !article.getPrimaryCategoryName().isBlank()) { %>
        <div class="mb-4">
          <% if (article.getPrimaryCategorySlug() != null && !article.getPrimaryCategorySlug().isBlank()) { %>
            <a href="/noframework/home?categorySlugs=<%= article.getPrimaryCategorySlug() %>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors"><%= article.getPrimaryCategoryName() %></a>
          <% } else { %>
            <span class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600"><%= article.getPrimaryCategoryName() %></span>
          <% } %>
        </div>
      <% } %>

      <h1 class="font-serif text-4xl sm:text-5xl leading-tight font-bold tracking-tight"><%= article.getTitre() %></h1>

      <% if (article.getSousTitre() != null && !article.getSousTitre().isBlank()) { %>
        <h2 class="mt-4 text-xl sm:text-2xl text-gray-600 leading-relaxed"><%= article.getSousTitre() %></h2>
      <% } %>

      <div class="mt-6 flex flex-wrap items-center gap-4 text-sm text-gray-500">
        <span><%= article.getDatePublication() == null ? "" : article.getDatePublication().toLocalDate() %></span>
        <span><%= article.getVues() %> vue(s)</span>
      </div>
    </header>

    <% if (article.getChapeau() != null && !article.getChapeau().isBlank()) { %>
      <div class="text-xl leading-relaxed text-gray-700 border-l-2 border-gray-300 pl-5 mb-8"><%= article.getChapeau() %></div>
    <% } %>

    <% if (article.getImageUrl() != null && !article.getImageUrl().isBlank()) { %>
      <figure class="mb-8">
        <img src="<%= article.getImageUrl() %>" alt="<%= article.getImageAlt() == null || article.getImageAlt().isBlank() ? "Illustration de l article" : article.getImageAlt() %>" class="w-full h-auto rounded-xl border border-stone" />
      </figure>
    <% } %>

    <section class="article-content text-[1.05rem] leading-8 text-gray-800"><%= article.getContenu() %></section>
  </article>

  <div class="mt-8 flex flex-wrap gap-3">
    <a href="/noframework/home" class="inline-flex items-center rounded-lg border border-stone px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Retour a l'accueil</a>
    <% if (article.getPrimaryCategorySlug() != null && !article.getPrimaryCategorySlug().isBlank() && article.getPrimaryCategoryName() != null && !article.getPrimaryCategoryName().isBlank()) { %>
      <a href="/noframework/home?categorySlugs=<%= article.getPrimaryCategorySlug() %>" class="inline-flex items-center rounded-lg bg-ink px-4 py-2 text-sm font-semibold text-white hover:bg-black transition-colors">Voir la categorie</a>
    <% } %>
  </div>
</main>

<%@ include file="/WEB-INF/jsp/plain/includes/footer.jsp" %>
