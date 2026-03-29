<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
  <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
  <!DOCTYPE html>
  <html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tableau de bord - Iran War News</title>
    <meta name="description" content="Tableau de bord backoffice pour la gestion editoriale Iran War News." />
    <meta name="keywords" content="backoffice, dashboard admin, iran war news" />
    <meta name="robots" content="noindex, nofollow" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: {
              sans: ['Plus Jakarta Sans', 'sans-serif']
            },
            colors: {
              ink: '#111827',
              paper: '#f6f8fb',
              accent: '#2563eb'
            },
            boxShadow: {
              soft: '0 10px 30px rgba(15, 23, 42, 0.08)'
            }
          }
        }
      };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
      body {
        background:
          radial-gradient(circle at 15% 20%, rgba(37, 99, 235, 0.08), transparent 38%),
          radial-gradient(circle at 85% 0%, rgba(30, 64, 175, 0.08), transparent 30%),
          #f6f8fb;
      }

      .metric-fill {
        transition: width 1.2s ease;
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
        <div>
          <p class="text-sm font-medium tracking-wide text-slate-500">Backoffice</p>
          <p class="text-lg font-semibold text-slate-900">Iran War News</p>
        </div>
      </a>

      <nav class="mt-10 space-y-1">
        <a href="/admin" class="flex items-center gap-3 rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-10h8V3h-8v8z"/></svg>
          Dashboard
        </a>
        <a href="/admin/articles" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M19 21H7a2 2 0 01-2-2V5a2 2 0 012-2h12m0 18a2 2 0 002-2V5a2 2 0 00-2-2m0 18h-7m-3-8h6m-6-4h8m-8 8h8"/></svg>
          Articles
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

      <div class="mt-10 rounded-2xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-600">
        <p class="font-semibold text-slate-800">Espace editorial</p>
        <p class="mt-1">Publiez, structurez et suivez vos contenus depuis une interface unifiee.</p>
      </div>
    </aside>

    <div class="flex min-h-screen w-full flex-col xl:ml-72">
      <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
          <div class="relative w-full max-w-xl">
            <svg class="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M21 21l-4.35-4.35m1.85-5.15a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
            <input type="search" placeholder="Rechercher un article, une categorie..." class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 pl-12 pr-4 text-sm outline-none ring-0 transition placeholder:text-slate-400 focus:border-blue-300 focus:bg-white focus:shadow-soft" />
          </div>
          <div class="flex items-center gap-3">
            <a href="/" target="_blank" class="hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:border-slate-300 hover:bg-slate-50 md:inline-flex">Voir le site</a>
            <button type="button" class="relative inline-flex h-11 w-11 items-center justify-center rounded-xl border border-slate-200 bg-white text-slate-500 transition hover:bg-slate-50">
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.9" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
              <span class="absolute right-3 top-3 h-2 w-2 rounded-full bg-blue-600"></span>
            </button>
            <div class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-3 py-2">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-bold text-white">AD</div>
              <div class="hidden sm:block">
                <p class="text-sm font-semibold leading-none text-slate-800">Admin</p>
                <p class="text-xs text-slate-500">Editeur en chef</p>
              </div>
            </div>
            <a href="/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
          </div>
        </div>
      </header>

      <main class="mx-auto w-full max-w-7xl flex-1 px-4 py-8 sm:px-6 lg:px-8">
        <section class="rounded-3xl border border-slate-200 bg-white p-6 shadow-soft">
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-blue-600">Tableau de bord editorial</p>
          <div class="mt-3 flex flex-wrap items-center justify-between gap-4">
            <div>
              <h1 class="text-3xl font-bold tracking-tight text-slate-900">Pilotez votre redaction</h1>
              <p class="mt-2 text-sm text-slate-600">Vision claire sur la publication, les performances et les actions rapides.</p>
            </div>
            <a href="/admin/articles/new" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">
              <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
              Ajouter un article
            </a>
          </div>
        </section>

        <section class="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
          <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Articles total</p>
            <p class="mt-3 text-3xl font-bold text-slate-900">${totalArticles}</p>
          </article>
          <article class="rounded-2xl border border-blue-100 bg-blue-50 p-5 shadow-soft">
            <p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Publies</p>
            <p class="mt-3 text-3xl font-bold text-blue-900">${publishedCount}</p>
          </article>
          <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">A la une</p>
            <p class="mt-3 text-3xl font-bold text-slate-900">${featuredCount}</p>
          </article>
          <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Vues</p>
            <p class="mt-3 text-3xl font-bold text-slate-900">
              <c:choose>
                <c:when test="${totalViews >= 1000}">
                  <fmt:formatNumber value="${totalViews / 1000}" maxFractionDigits="1" />k
                </c:when>
                <c:otherwise>${totalViews}</c:otherwise>
              </c:choose>
            </p>
          </article>
        </section>

        <section class="mt-6 grid gap-6 xl:grid-cols-3">
          <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft xl:col-span-2">
            <div class="flex items-center justify-between">
              <h2 class="text-lg font-semibold text-slate-900">Repartition des statuts</h2>
              <span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">Live</span>
            </div>
            <div class="mt-6 h-72">
              <canvas id="statusChart"></canvas>
            </div>
            <div class="mt-6 space-y-4">
              <div>
                <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Publies</span><span>${publishedCount}/${totalArticles}</span></div>
                <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-blue-600" style="width: ${totalArticles > 0 ? (publishedCount * 100 / totalArticles) : 0}%"></div></div>
              </div>
              <div>
                <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Brouillons</span><span>${draftCount}/${totalArticles}</span></div>
                <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-slate-500" style="width: ${totalArticles > 0 ? (draftCount * 100 / totalArticles) : 0}%"></div></div>
              </div>
              <div>
                <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Archives</span><span>${archivedCount}/${totalArticles}</span></div>
                <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-slate-300" style="width: ${totalArticles > 0 ? (archivedCount * 100 / totalArticles) : 0}%"></div></div>
              </div>
            </div>
          </article>

          <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
            <h2 class="text-lg font-semibold text-slate-900">Activite recente</h2>
            <div class="mt-4 space-y-3">
              <c:if test="${not empty recentArticles}">
                <c:forEach items="${recentArticles}" var="article">
                  <div class="rounded-xl border border-slate-200 bg-slate-50 p-3 transition hover:-translate-y-0.5 hover:border-blue-200 hover:bg-blue-50">
                    <div class="flex items-start justify-between gap-3">
                      <div>
                        <p class="line-clamp-2 text-sm font-semibold text-slate-800"><c:out value="${article.titre}" /></p>
                        <p class="mt-1 text-xs text-slate-500"><c:out value="${article.createdAt}" /></p>
                      </div>
                      <span class="rounded-full px-2 py-1 text-[11px] font-semibold ${article.statut == 'publie' ? 'bg-emerald-100 text-emerald-700' : (article.statut == 'brouillon' ? 'bg-amber-100 text-amber-800' : 'bg-slate-200 text-slate-700')}">${article.statut}</span>
                    </div>
                  </div>
                </c:forEach>
              </c:if>
              <c:if test="${empty recentArticles}">
                <p class="rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center text-sm text-slate-500">Aucun article recent.</p>
              </c:if>
            </div>
          </article>
        </section>

        <c:if test="${not empty mostViewedArticle && mostViewedArticle.vues > 0}">
          <section class="mt-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
            <div class="flex flex-wrap items-center justify-between gap-4">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Article le plus populaire</p>
                <a href="/article/${mostViewedArticle.slug}" target="_blank" class="mt-2 block text-xl font-semibold text-slate-900 transition hover:text-blue-700">
                  <c:out value="${mostViewedArticle.titre}" />
                </a>
                <p class="mt-2 max-w-3xl text-sm text-slate-600"><c:out value="${mostViewedArticle.chapeau}" /></p>
              </div>
              <div class="rounded-2xl bg-blue-50 px-6 py-4 text-center">
                <p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Vues</p>
                <p class="mt-1 text-3xl font-bold text-blue-900">${mostViewedArticle.vues}</p>
              </div>
            </div>
          </section>
        </c:if>

        <section class="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          <a href="/admin/articles/new" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
            <p class="text-sm font-semibold text-slate-900">Nouvel article</p>
            <p class="mt-1 text-sm text-slate-600">Demarrer une publication</p>
          </a>
          <a href="/admin/articles" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
            <p class="text-sm font-semibold text-slate-900">Gerer les articles</p>
            <p class="mt-1 text-sm text-slate-600">Modifier ou supprimer</p>
          </a>
          <a href="/categories/new" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
            <p class="text-sm font-semibold text-slate-900">Nouvelle categorie</p>
            <p class="mt-1 text-sm text-slate-600">Structurer la ligne editoriale</p>
          </a>
          <a href="/categories" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
            <p class="text-sm font-semibold text-slate-900">Categories (${totalCategories})</p>
            <p class="mt-1 text-sm text-slate-600">Organiser les thematiques</p>
          </a>
        </section>
      </main>
    </div>
  </div>

  <script>
    const ctx = document.getElementById('statusChart').getContext('2d');
    const statusData = ${statusData};

    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Publies', 'Brouillons', 'Archives'],
        datasets: [{
          data: statusData,
          backgroundColor: ['#2563eb', '#64748b', '#cbd5e1'],
          borderColor: '#ffffff',
          borderWidth: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '68%',
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              usePointStyle: true,
              padding: 18,
              color: '#334155',
              font: {
                family: 'Plus Jakarta Sans',
                size: 12,
                weight: '600'
              }
            }
          }
        }
      }
    });

    setTimeout(() => {
      document.querySelectorAll('.metric-fill').forEach((item) => {
        const finalWidth = item.style.width;
        item.style.width = '0%';
        requestAnimationFrame(() => {
          item.style.width = finalWidth;
        });
      });
    }, 350);
  </script>
  </body>
  </html>