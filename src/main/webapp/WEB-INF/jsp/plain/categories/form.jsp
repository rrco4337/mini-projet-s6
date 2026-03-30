<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.category.PlainCategoryForm" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Categorie - BackOffice</title>
  <meta name="description" content="Formulaire backoffice pour creer ou modifier une categorie Iran War News." />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-50 font-sans text-slate-800">
<%
  List<String> errors = (List<String>) request.getAttribute("errors");
  PlainCategoryForm form = (PlainCategoryForm) request.getAttribute("form");
  String submitLabel = (String) request.getAttribute("submitLabel");
  String formAction = (String) request.getAttribute("formAction");

  String nom = form == null || form.getNom() == null ? "" : form.getNom();
  String slug = form == null || form.getSlug() == null ? "" : form.getSlug();
  String description = form == null || form.getDescription() == null ? "" : form.getDescription();
  String effectiveSubmitLabel = submitLabel == null ? "Creer" : submitLabel;
  String effectiveFormAction = formAction == null ? "/noframework/admin/categories/new" : formAction;
%>
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white px-6 py-7 xl:block">
    <a href="/noframework/admin/dashboard" class="flex items-center gap-3">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">IW</div>
      <div><p class="text-sm text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div>
    </a>
    <nav class="mt-10 space-y-1">
      <a href="/noframework/admin/dashboard" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Dashboard</a>
      <a href="/noframework/admin/articles" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Articles</a>
      <a href="/noframework/admin/categories" class="rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700 block">Categories</a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <input type="search" placeholder="Rechercher..." class="h-11 w-full max-w-xl rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
        <a href="/noframework/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
      </div>
    </header>

    <main class="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="mb-6">
        <h1 class="text-3xl font-bold tracking-tight text-slate-900"><%= "Mettre a jour".equals(effectiveSubmitLabel) ? "Modifier" : "Creer" %> une categorie</h1>
        <p class="mt-2 text-sm text-slate-600">Definissez une categorie claire pour structurer la publication.</p>
      </div>

      <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
        <% if (errors != null && !errors.isEmpty()) { %>
          <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800">
            <% for (String err : errors) { %><div><%= err %></div><% } %>
          </div>
        <% } %>

        <form method="post" action="<%= effectiveFormAction %>" class="space-y-5">
          <div>
            <label class="mb-2 block text-sm font-semibold text-slate-700" for="nom">Nom</label>
            <input id="nom" name="nom" value="<%= nom %>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
          </div>

          <div>
            <label class="mb-2 block text-sm font-semibold text-slate-700" for="slug">Slug</label>
            <input id="slug" name="slug" value="<%= slug %>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
            <p class="mt-1 text-xs text-slate-500">Exemple: diplomatie</p>
          </div>

          <div>
            <label class="mb-2 block text-sm font-semibold text-slate-700" for="description">Description</label>
            <textarea id="description" name="description" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white" rows="4"><%= description %></textarea>
          </div>

          <div class="flex flex-wrap gap-3 pt-2">
            <button type="submit" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Enregistrer</button>
            <a href="/noframework/admin/categories" class="rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Annuler</a>
          </div>
        </form>
      </section>
    </main>
  </div>
</div>
</body>
</html>
