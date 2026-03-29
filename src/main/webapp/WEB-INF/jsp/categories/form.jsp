<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><c:out value="${mode == 'edit' ? 'Modifier' : 'Nouvelle'}"/> categorie</title>
  <meta name="description" content="Formulaire backoffice pour creer ou modifier une categorie Iran War News." />
  <meta name="keywords" content="formulaire categorie, administration, iran war news" />
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
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white px-6 py-7 xl:block">
    <a href="/admin" class="flex items-center gap-3">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">IW</div>
      <div><p class="text-sm text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div>
    </a>
    <nav class="mt-10 space-y-1">
      <a href="/admin" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Dashboard</a>
      <a href="/admin/articles" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Articles</a>
      <a href="/admin/articles/drafts" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Brouillons</a>
      <a href="/admin/articles/archives" class="rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 block">Archives</a>
      <a href="/categories" class="rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700 block">Categories</a>
      <a href="#" class="rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100 block">Utilisateurs</a>
      <a href="#" class="rounded-xl px-4 py-3 text-slate-400 transition hover:bg-slate-100 block">Parametres</a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <input type="search" placeholder="Rechercher..." class="h-11 w-full max-w-xl rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
        <a href="/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
      </div>
    </header>

    <main class="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="mb-6">
        <h1 class="text-3xl font-bold tracking-tight text-slate-900"><c:out value="${mode == 'edit' ? 'Modifier' : 'Creer'}"/> une categorie</h1>
        <p class="mt-2 text-sm text-slate-600">Definissez une categorie claire pour structurer la publication.</p>
      </div>

      <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
        <c:choose>
          <c:when test="${mode == 'edit'}">
            <form:form method="post" modelAttribute="categoryForm" action="/categories/${categoryId}" class="space-y-5">
              <jsp:include page="_fields.jsp" />
            </form:form>
          </c:when>
          <c:otherwise>
            <form:form method="post" modelAttribute="categoryForm" action="/categories" class="space-y-5">
              <jsp:include page="_fields.jsp" />
            </form:form>
          </c:otherwise>
        </c:choose>
      </section>
    </main>
  </div>
</div>
</body>
</html>
