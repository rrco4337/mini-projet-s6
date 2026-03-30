<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.article.PlainArticleRow" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Archives - BackOffice</title>
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-50 font-sans text-slate-800">
<%
  List<PlainArticleRow> articles = (List<PlainArticleRow>) request.getAttribute("articles");
  String successMessage = (String) request.getAttribute("successMessage");
  String errorMessage = (String) request.getAttribute("errorMessage");
%>
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white/95 px-6 py-7 backdrop-blur xl:block">
    <a href="/noframework/admin/dashboard" class="flex items-center gap-3"><div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">IW</div><div><p class="text-sm text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div></a>
    <nav class="mt-10 space-y-1">
      <a href="/noframework/admin/dashboard" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Dashboard</a>
      <a href="/noframework/admin/articles" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Articles</a>
      <a href="/noframework/admin/articles/drafts" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Brouillons</a>
      <a href="/noframework/admin/articles/archives" class="rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700 block">Archives</a>
      <a href="/noframework/admin/categories" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Categories</a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <div class="relative w-full max-w-xl"><input type="search" placeholder="Rechercher dans les archives..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" /></div>
        <div class="flex items-center gap-3">
          <a href="/noframework/admin/articles/drafts" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Brouillons</a>
          <a href="/noframework/admin/articles" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Tous les articles</a>
          <a href="/noframework/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4"><div><h1 class="text-3xl font-bold tracking-tight text-slate-900">Articles archives</h1><p class="mt-2 text-sm text-slate-600">Consultez les articles masques et restaurez-les si necessaire.</p></div></section>

      <% if (successMessage != null && !successMessage.isBlank()) { %>
      <div class="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800"><%= successMessage %></div>
      <% } %>
      <% if (errorMessage != null && !errorMessage.isBlank()) { %>
      <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800"><%= errorMessage %></div>
      <% } %>

      <section class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-soft">
        <div class="overflow-x-auto">
          <table class="min-w-full text-sm">
            <thead class="bg-slate-100/90 text-left text-xs font-semibold uppercase tracking-wide text-slate-600"><tr><th class="px-5 py-4">ID</th><th class="px-5 py-4">Titre</th><th class="px-5 py-4">Categorie</th><th class="px-5 py-4">Vues</th><th class="px-5 py-4 text-right">Actions</th></tr></thead>
            <tbody class="divide-y divide-slate-200">
            <% if (articles == null || articles.isEmpty()) { %>
              <tr><td colspan="5" class="px-6 py-14 text-center text-sm text-slate-500">Aucun article archive.</td></tr>
            <% } else {
                 for (int i = 0; i < articles.size(); i++) {
                   PlainArticleRow article = articles.get(i); %>
              <tr class="<%= i % 2 == 0 ? "bg-white" : "bg-slate-50" %> transition hover:bg-blue-50/60">
                <td class="px-5 py-4 font-semibold text-slate-700"><%= article.getId() %></td>
                <td class="px-5 py-4"><p class="font-semibold text-slate-900"><%= article.getTitre() %></p><p class="mt-1 text-xs text-slate-500">/<%= article.getSlug() %></p></td>
                <td class="px-5 py-4"><span class="rounded-full border border-slate-200 bg-white px-2 py-1 text-xs font-medium text-slate-600"><%= article.getCategoryNames() == null || article.getCategoryNames().isBlank() ? "-" : article.getCategoryNames() %></span></td>
                <td class="px-5 py-4 font-semibold text-slate-700"><%= article.getVues() %></td>
                <td class="px-5 py-4 text-right">
                  <div class="inline-flex items-center gap-2">
                    <form action="/noframework/admin/articles/restore" method="post" class="inline" onsubmit="return confirm('Restaurer cet article en brouillon ?');"><input type="hidden" name="id" value="<%= article.getId() %>" /><button type="submit" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100">Restaurer</button></form>
                    <form action="/noframework/admin/articles/delete" method="post" class="inline" onsubmit="return confirm('Supprimer definitivement cet article ?');"><input type="hidden" name="id" value="<%= article.getId() %>" /><button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">Supprimer</button></form>
                  </div>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>
