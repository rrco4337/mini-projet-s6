<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.front.PlainFrontArticleRow" %>
<%
  List<PlainFrontArticleRow> articles = (List<PlainFrontArticleRow>) request.getAttribute("articles");
  List<PlainFrontArticleRow> featuredArticles = (List<PlainFrontArticleRow>) request.getAttribute("featuredArticles");
  List<String> selectedCategorySlugs = (List<String>) request.getAttribute("selectedCategorySlugs");
  String selectedPublicationDate = (String) request.getAttribute("selectedPublicationDate");
%>
<%@ include file="/WEB-INF/jsp/plain/includes/header.jsp" %>

<main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10">

  <section class="mb-6">
    <div class="rounded-2xl border border-stone bg-white shadow-editorial">
      <div class="p-5 sm:p-6">
        <form method="get" action="/noframework/home">
          <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-end">
            <div class="md:col-span-8">
              <p class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Categories</p>
              <div class="flex flex-wrap gap-2">
                <%
                  List<com.miniprojets6.plain.front.PlainFrontCategory> homeNavCategories = (List<com.miniprojets6.plain.front.PlainFrontCategory>) request.getAttribute("navCategories");
                  if (homeNavCategories != null) {
                    for (com.miniprojets6.plain.front.PlainFrontCategory cat : homeNavCategories) {
                      boolean selected = selectedCategorySlugs != null && selectedCategorySlugs.contains(cat.getSlug());
                %>
                <label class="cursor-pointer">
                  <input type="checkbox" name="categorySlugs" value="<%= cat.getSlug() %>" class="peer sr-only" <%= selected ? "checked" : "" %> />
                  <span class="inline-flex items-center gap-2 rounded-full border border-stone px-3 py-1.5 text-xs uppercase tracking-wider text-gray-600 transition-colors hover:text-ink hover:border-gray-400 peer-checked:border-ink peer-checked:bg-ink peer-checked:text-white"><%= cat.getNom() %></span>
                </label>
                <%  }
                  }
                %>
              </div>
            </div>

            <div class="md:col-span-4">
              <label for="publicationDate" class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Date de publication</label>
              <input id="publicationDate" name="publicationDate" type="date" class="w-full rounded-lg border-stone focus:border-ink focus:ring-ink text-sm" value="<%= selectedPublicationDate == null ? "" : selectedPublicationDate %>" />
            </div>

            <div class="md:col-span-12 flex gap-2 justify-end">
              <button type="submit" class="px-5 py-2.5 rounded-lg bg-ink text-white text-sm font-semibold hover:bg-black transition-colors">Rechercher</button>
              <a href="/noframework/home" class="px-4 py-2.5 rounded-lg border border-stone text-sm text-gray-700 hover:bg-gray-50 transition-colors">Reset</a>
            </div>
          </div>
        </form>
      </div>
    </div>
  </section>

  <% if (featuredArticles != null && !featuredArticles.isEmpty()) { %>
    <section class="mb-10">
      <div class="flex items-center justify-between mb-5">
        <h2 class="font-serif text-3xl font-semibold tracking-tight">A la une</h2>
        <span class="h-px bg-stone flex-1 ml-5"></span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <% for (PlainFrontArticleRow article : featuredArticles) { %>
          <article class="group rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:-translate-y-1 transition-all duration-300">
            <div class="p-5">
              <% if (article.getCategoryNames() != null && !article.getCategoryNames().isBlank()) { %>
                <p class="mb-3 text-xs uppercase tracking-wider text-gray-600"><%= article.getCategoryNames() %></p>
              <% } %>
              <h3 class="font-serif text-2xl leading-snug font-semibold group-hover:text-accent transition-colors">
                <a href="/noframework/article?slug=<%= article.getSlug() %>"><%= article.getTitre() %></a>
              </h3>
              <% if (article.getChapeau() != null && !article.getChapeau().isBlank()) { %>
                <p class="mt-3 text-gray-600 leading-relaxed"><%= article.getChapeau() %></p>
              <% } %>
            </div>
            <div class="px-5 py-4 border-t border-stone text-sm text-gray-500"><%= article.getVues() %> vues</div>
          </article>
        <% } %>
      </div>
    </section>
  <% } %>

  <section>
    <div class="flex items-center justify-between mb-5">
      <h2 class="font-serif text-3xl font-semibold tracking-tight">Derniers articles</h2>
      <span class="h-px bg-stone flex-1 ml-5"></span>
    </div>

    <% if (articles == null || articles.isEmpty()) { %>
      <div class="rounded-xl border border-stone bg-white p-5 text-gray-600">Aucun article disponible pour le moment.</div>
    <% } %>

    <div class="grid grid-cols-1 gap-6">
      <% if (articles != null) {
           for (PlainFrontArticleRow article : articles) { %>
      <article class="rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:shadow-xl transition-shadow duration-300">
        <div class="p-5 sm:p-6">
          <% if (article.getCategoryNames() != null && !article.getCategoryNames().isBlank()) { %>
            <p class="mb-3 text-xs uppercase tracking-wider text-gray-600"><%= article.getCategoryNames() %></p>
          <% } %>
          <h3 class="font-serif text-3xl leading-tight font-semibold mb-2 hover:text-accent transition-colors">
            <a href="/noframework/article?slug=<%= article.getSlug() %>"><%= article.getTitre() %></a>
          </h3>
          <% if (article.getSousTitre() != null && !article.getSousTitre().isBlank()) { %>
            <p class="text-gray-500 text-lg mb-2"><%= article.getSousTitre() %></p>
          <% } %>
          <% if (article.getChapeau() != null && !article.getChapeau().isBlank()) { %>
            <p class="text-gray-700 leading-relaxed"><%= article.getChapeau() %></p>
          <% } %>
          <div class="mt-4 flex flex-wrap items-center gap-4 text-sm text-gray-500">
            <span><%= article.getDatePublication() == null ? "" : article.getDatePublication().toLocalDate() %></span>
            <span><%= article.getVues() %> vues</span>
          </div>
        </div>
      </article>
      <%   }
         } %>
    </div>
  </section>

</main>

<%@ include file="/WEB-INF/jsp/plain/includes/footer.jsp" %>
