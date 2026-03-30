<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Brouillons - BackOffice</title>
  <meta name="description" content="Page backoffice de gestion des brouillons Iran War News." />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] },
          boxShadow: { soft: '0 10px 30px rgba(15, 23, 42, 0.08)' }
        }
      }
    };
  </script>
</head>
<body class="min-h-screen bg-slate-50 font-sans text-slate-800">
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white/95 px-6 py-7 backdrop-blur xl:block">
    <a href="/admin" class="flex items-center gap-3">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 10-8.038 0l-2.387.477a2 2 0 00-1.021.547M6 19h12"/></svg>
      </div>
      <div><p class="text-sm text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div>
    </a>
    <nav class="mt-10 space-y-1">
      <a href="/admin" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-10h8V3h-8v8z"/></svg>
        Dashboard
      </a>
      <a href="/admin/articles" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19 21H7a2 2 0 01-2-2V5a2 2 0 012-2h12m0 18a2 2 0 002-2V5a2 2 0 00-2-2m0 18h-7m-3-8h6m-6-4h8m-8 8h8"/></svg>
        Articles
      </a>
      <a href="/admin/articles/drafts" class="flex items-center gap-3 rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M12 20h9"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M16.5 3.5a2.1 2.1 0 013 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
        Brouillons
      </a>
      <a href="/admin/articles/archives" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M20.54 5.23l-1.39-1.68A2 2 0 0017.61 3H6.39a2 2 0 00-1.54.55L3.46 5.23A2 2 0 003 6.52V8a1 1 0 001 1h16a1 1 0 001-1V6.52a2 2 0 00-.46-1.29z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M5 9v9a2 2 0 002 2h10a2 2 0 002-2V9"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M10 13h4"/></svg>
        Archives
      </a>
      <a href="/categories" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M3 7a2 2 0 012-2h4l2 2h8a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V7z"/></svg>
        Categories
      </a>
      <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M17 20h5V4H2v16h5m10 0v-2a4 4 0 00-4-4H11a4 4 0 00-4 4v2m10 0H7m10-10a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
        Utilisateurs
      </a>
      <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M10.325 4.317a1 1 0 011.35-.936l1.612.658a1 1 0 00.948-.086l1.427-.96a1 1 0 011.48.617l.36 1.675a1 1 0 00.688.75l1.636.498a1 1 0 01.63 1.472l-.83 1.495a1 1 0 000 .972l.83 1.495a1 1 0 01-.63 1.472l-1.636.498a1 1 0 00-.688.75l-.36 1.675a1 1 0 01-1.48.617l-1.427-.96a1 1 0 00-.948-.086l-1.612.658a1 1 0 01-1.35-.936l-.11-1.71a1 1 0 00-.552-.812l-1.53-.765a1 1 0 010-1.788l1.53-.765a1 1 0 00.553-.812l.109-1.71z"/></svg>
        Parametres
      </a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <div class="relative w-full max-w-xl">
          <input type="search" placeholder="Rechercher dans les brouillons..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
        </div>
        <div class="flex items-center gap-3">
          <a href="/admin/articles/archives" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Archives</a>
          <a href="/admin/articles" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Tous les articles</a>
          <a href="/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900">Tous les brouillons</h1>
          <p class="mt-2 text-sm text-slate-600">Retrouvez uniquement les articles en cours de redaction.</p>
        </div>
        <a href="/admin/articles/new" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Ajouter un article</a>
      </section>

      <c:if test="${not empty successMessage}">
        <div class="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800">${successMessage}</div>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800">${errorMessage}</div>
      </c:if>

      <section class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-soft">
        <div class="overflow-x-auto">
          <table class="min-w-full text-sm">
            <thead class="bg-slate-100/90 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
              <tr>
                <th class="px-5 py-4">ID</th>
                <th class="px-5 py-4">Titre</th>
                <th class="px-5 py-4">Categorie</th>
                <th class="px-5 py-4">Vues</th>
                <th class="px-5 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <c:forEach items="${articles}" var="article" varStatus="row">
                <tr class="${row.index % 2 == 0 ? 'bg-white' : 'bg-slate-50'} transition hover:bg-blue-50/60">
                  <td class="px-5 py-4 font-semibold text-slate-700">${article.id}</td>
                  <td class="px-5 py-4">
                    <p class="font-semibold text-slate-900"><c:out value="${article.titre}" /></p>
                    <p class="mt-1 text-xs text-slate-500">/<c:out value="${article.slug}" /></p>
                  </td>
                  <td class="px-5 py-4">
                    <div class="flex flex-wrap gap-1.5">
                      <c:if test="${not empty article.categories}">
                        <c:forEach items="${article.categories}" var="cat">
                          <span class="rounded-full border border-slate-200 bg-white px-2 py-1 text-xs font-medium text-slate-600"><c:out value="${cat.nom}" /></span>
                        </c:forEach>
                      </c:if>
                      <c:if test="${empty article.categories and article.categorie != null}">
                        <span class="rounded-full border border-slate-200 bg-white px-2 py-1 text-xs font-medium text-slate-600"><c:out value="${article.categorie.nom}" /></span>
                      </c:if>
                      <c:if test="${empty article.categories and article.categorie == null}">
                        <span class="text-slate-400">-</span>
                      </c:if>
                    </div>
                  </td>
                  <td class="px-5 py-4 font-semibold text-slate-700">${article.vues}</td>
                  <td class="px-5 py-4 text-right">
                    <div class="inline-flex items-center gap-2">
                      <a href="/admin/articles/${article.id}/edit" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100">Modifier</a>
                      <form action="/admin/articles/${article.id}/archive" method="post" class="inline" onsubmit="return confirm('Archiver ce brouillon ?');">
                        <button type="submit" class="rounded-lg border border-amber-200 bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-700 transition hover:bg-amber-100">Archiver</button>
                      </form>
                      <form action="/admin/articles/${article.id}/delete" method="post" class="inline" onsubmit="return confirm('Supprimer ce brouillon ?');">
                        <button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">Supprimer</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty articles}">
                <tr>
                  <td colspan="5" class="px-6 py-14 text-center text-sm text-slate-500">Aucun brouillon disponible.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>
