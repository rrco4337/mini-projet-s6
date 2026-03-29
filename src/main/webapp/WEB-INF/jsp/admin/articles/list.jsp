<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestion des articles - BackOffice</title>
  <meta name="description" content="Page backoffice de gestion des articles Iran War News." />
  <meta name="keywords" content="gestion articles, administration, iran war news" />
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
  <style>
    body {
      background:
        radial-gradient(circle at 8% 12%, rgba(37, 99, 235, 0.08), transparent 30%),
        #f6f8fb;
    }
  </style>
</head>
<body class="min-h-screen font-sans text-slate-800">
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white/95 px-6 py-7 backdrop-blur xl:block">
    <a href="/admin" class="flex items-center gap-3">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 10-8.038 0l-2.387.477a2 2 0 00-1.021.547M6 19h12"/></svg>
      </div>
      <div><p class="text-sm font-medium text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div>
    </a>
    <nav class="mt-10 space-y-1">
      <a href="/admin" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">Dashboard</a>
      <a href="/admin/articles" class="flex items-center gap-3 rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700">Articles</a>
      <a href="/categories" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">Categories</a>
      <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">Utilisateurs</a>
      <a href="#" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100">Parametres</a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <div class="relative w-full max-w-xl">
          <input type="search" placeholder="Rechercher dans les articles..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
        </div>
        <div class="flex items-center gap-3">
          <a href="/" target="_blank" class="hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50 md:inline-flex">Voir le site</a>
          <a href="/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900">Gestion des articles</h1>
          <p class="mt-2 text-sm text-slate-600">Consultez, editez et supprimez les contenus publies ou en brouillon.</p>
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
                <th class="px-5 py-4">Statut</th>
                <th class="px-5 py-4">A la une</th>
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
                  <td class="px-5 py-4">
                    <c:choose>
                      <c:when test="${article.statut == 'publie'}">
                        <span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">Publie</span>
                      </c:when>
                      <c:when test="${article.statut == 'brouillon'}">
                        <span class="rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-800">Brouillon</span>
                      </c:when>
                      <c:otherwise>
                        <span class="rounded-full bg-slate-200 px-3 py-1 text-xs font-semibold text-slate-700">Archive</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="px-5 py-4 text-lg">
                    <c:if test="${article.ALaUne}">★</c:if>
                    <c:if test="${!article.ALaUne}"><span class="text-slate-300">☆</span></c:if>
                  </td>
                  <td class="px-5 py-4 font-semibold text-slate-700">${article.vues}</td>
                  <td class="px-5 py-4 text-right">
                    <div class="inline-flex items-center gap-2">
                      <a href="/article/${article.slug}" target="_blank" class="rounded-lg border border-slate-300 px-3 py-1.5 text-xs font-semibold text-slate-700 transition hover:bg-slate-100" title="Voir">Voir</a>
                      <a href="/admin/articles/${article.id}/edit" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100" title="Modifier">Modifier</a>
                      <form action="/admin/articles/${article.id}/delete" method="post" class="inline" onsubmit="return confirm('Supprimer cet article ?');">
                        <button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100" title="Supprimer">Supprimer</button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty articles}">
                <tr>
                  <td colspan="7" class="px-6 py-14 text-center text-sm text-slate-500">Aucun article disponible.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </section>

      <div class="mt-6">
        <a href="/admin" class="inline-flex items-center rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Retour au tableau de bord</a>
      </div>
    </main>
  </div>
</div>
</body>
</html>
