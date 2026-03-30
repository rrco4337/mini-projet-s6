<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.article.PlainArticleRow" %>
<%@ page import="com.miniprojets6.plain.auth.PlainAuthUser" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tableau de bord - Iran War News</title>
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="min-h-screen font-sans text-slate-800 bg-slate-50">
<%
  PlainAuthUser authUser = (PlainAuthUser) request.getAttribute("authUser");
  int totalArticles = (Integer) request.getAttribute("totalArticles");
  int publishedCount = (Integer) request.getAttribute("publishedCount");
  int draftCount = (Integer) request.getAttribute("draftCount");
  int archivedCount = (Integer) request.getAttribute("archivedCount");
  int featuredCount = (Integer) request.getAttribute("featuredCount");
  int totalViews = (Integer) request.getAttribute("totalViews");
  int totalCategories = (Integer) request.getAttribute("totalCategories");
  String statusData = (String) request.getAttribute("statusData");
  List<PlainArticleRow> recentArticles = (List<PlainArticleRow>) request.getAttribute("recentArticles");
  PlainArticleRow mostViewedArticle = (PlainArticleRow) request.getAttribute("mostViewedArticle");
%>
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white/95 px-6 py-7 backdrop-blur xl:block">
    <a href="/noframework/admin/dashboard" class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">IW</div><div><p class="text-sm font-medium tracking-wide text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div></a>
    <nav class="mt-10 space-y-1">
      <a href="/noframework/admin/dashboard" class="flex items-center gap-3 rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700">Dashboard</a>
      <a href="/noframework/admin/articles" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Articles</a>
      <a href="/noframework/admin/articles/drafts" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Brouillons</a>
      <a href="/noframework/admin/articles/archives" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Archives</a>
      <a href="/noframework/admin/categories" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Categories</a>
    </nav>
  </aside>

  <div class="flex min-h-screen w-full flex-col xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <div class="relative w-full max-w-xl"><input type="search" placeholder="Rechercher un article, une categorie..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 pl-4 pr-4 text-sm outline-none" /></div>
        <div class="flex items-center gap-3">
          <a href="/noframework/home" target="_blank" class="hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50 md:inline-flex">Voir le site</a>
          <div class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2"><div class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-bold text-white">AD</div><div class="hidden sm:block"><p class="text-sm font-semibold leading-none text-slate-800"><%= authUser == null ? "Admin" : authUser.getUsername() %></p><p class="text-xs text-slate-500">Editeur</p></div></div>
          <a href="/noframework/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
        </div>
      </div>
    </header>

    <main class="mx-auto w-full max-w-7xl flex-1 px-4 py-8 sm:px-6 lg:px-8">
      <section class="rounded-3xl border border-slate-200 bg-white p-6 shadow-soft"><p class="text-xs font-semibold uppercase tracking-[0.18em] text-blue-600">Tableau de bord editorial</p><div class="mt-3 flex flex-wrap items-center justify-between gap-4"><div><h1 class="text-3xl font-bold tracking-tight text-slate-900">Pilotez votre redaction</h1><p class="mt-2 text-sm text-slate-600">Vision claire sur la publication, les performances et les actions rapides.</p></div><a href="/noframework/admin/articles/new" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Ajouter un article</a></div></section>

      <section class="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft"><p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Articles total</p><p class="mt-3 text-3xl font-bold text-slate-900"><%= totalArticles %></p></article>
        <article class="rounded-2xl border border-blue-100 bg-blue-50 p-5 shadow-soft"><p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Publies</p><p class="mt-3 text-3xl font-bold text-blue-900"><%= publishedCount %></p></article>
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft"><p class="text-xs font-semibold uppercase tracking-wide text-slate-500">A la une</p><p class="mt-3 text-3xl font-bold text-slate-900"><%= featuredCount %></p></article>
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft"><p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Vues</p><p class="mt-3 text-3xl font-bold text-slate-900"><%= totalViews %></p></article>
      </section>

      <section class="mt-6 grid gap-6 xl:grid-cols-3">
        <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft xl:col-span-2">
          <div class="flex items-center justify-between"><h2 class="text-lg font-semibold text-slate-900">Repartition des statuts</h2><span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">Live</span></div>
          <div class="mt-6 h-72"><canvas id="statusChart"></canvas></div>
        </article>

        <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
          <h2 class="text-lg font-semibold text-slate-900">Activite recente</h2>
          <div class="mt-4 space-y-3">
            <% if (recentArticles != null && !recentArticles.isEmpty()) {
                 for (PlainArticleRow article : recentArticles) { %>
            <div class="rounded-xl border border-slate-200 bg-slate-50 p-3 transition hover:-translate-y-0.5 hover:border-blue-200 hover:bg-blue-50">
              <div class="flex items-start justify-between gap-3">
                <div>
                  <p class="line-clamp-2 text-sm font-semibold text-slate-800"><%= article.getTitre() %></p>
                  <p class="mt-1 text-xs text-slate-500"><%= article.getCreatedAt() == null ? "" : article.getCreatedAt().toLocalDate() %></p>
                </div>
                <span class="rounded-full px-2 py-1 text-[11px] font-semibold"><%= article.getStatut() %></span>
              </div>
            </div>
            <%   }
               } else { %>
            <p class="rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center text-sm text-slate-500">Aucun article recent.</p>
            <% } %>
          </div>
        </article>
      </section>

      <% if (mostViewedArticle != null && mostViewedArticle.getVues() > 0) { %>
      <section class="mt-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
        <div class="flex flex-wrap items-center justify-between gap-4"><div><p class="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Article le plus populaire</p><a href="/noframework/article?slug=<%= mostViewedArticle.getSlug() %>" target="_blank" class="mt-2 block text-xl font-semibold text-slate-900 transition hover:text-blue-700"><%= mostViewedArticle.getTitre() %></a><p class="mt-2 max-w-3xl text-sm text-slate-600"><%= mostViewedArticle.getChapeau() == null ? "" : mostViewedArticle.getChapeau() %></p></div><div class="rounded-2xl bg-blue-50 px-6 py-4 text-center"><p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Vues</p><p class="mt-1 text-3xl font-bold text-blue-900"><%= mostViewedArticle.getVues() %></p></div></div>
      </section>
      <% } %>
    </main>
  </div>
</div>

<script>
  const ctx = document.getElementById('statusChart').getContext('2d');
  const chartStatusData = JSON.parse('<%= statusData %>');
  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['Publies', 'Brouillons', 'Archives'],
      datasets: [{ data: chartStatusData, backgroundColor: ['#2563eb', '#64748b', '#cbd5e1'], borderColor: '#ffffff', borderWidth: 4 }]
    },
    options: { responsive: true, maintainAspectRatio: false, cutout: '68%' }
  });
</script>
</body>
</html>
