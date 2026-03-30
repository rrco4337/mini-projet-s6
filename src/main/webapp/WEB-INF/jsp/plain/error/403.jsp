<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/plain/includes/header.jsp" %>

<main class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
  <section class="rounded-2xl border border-stone bg-white shadow-editorial p-8 sm:p-10 text-center">
    <p class="text-xs uppercase tracking-[0.22em] text-gray-500 font-semibold">Erreur</p>
    <h1 class="mt-3 font-serif text-6xl sm:text-7xl font-bold tracking-tight">403</h1>
    <h2 class="mt-4 text-2xl font-semibold">Acces refuse</h2>
    <p class="mt-3 text-gray-600">Vous n avez pas les droits necessaires pour acceder a cette page.</p>

    <div class="mt-8 flex flex-wrap justify-center gap-3">
      <a href="/noframework/home" class="inline-flex items-center rounded-lg bg-ink px-4 py-2 text-sm font-semibold text-white hover:bg-black transition-colors">Retour a l accueil</a>
      <a href="/noframework/login" class="inline-flex items-center rounded-lg border border-stone px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Se connecter</a>
    </div>
  </section>
</main>

<%@ include file="/WEB-INF/jsp/plain/includes/footer.jsp" %>
