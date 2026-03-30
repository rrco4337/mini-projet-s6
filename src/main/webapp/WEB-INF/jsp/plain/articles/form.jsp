<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.miniprojets6.plain.article.PlainCategoryRow" %>
<%@ page import="com.miniprojets6.plain.article.PlainArticleCreateRequest" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Article - BackOffice</title>
  <meta name="description" content="Formulaire backoffice pour creer ou modifier un article Iran War News." />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen font-sans text-slate-800 bg-slate-50">
<%
  List<PlainCategoryRow> categories = (List<PlainCategoryRow>) request.getAttribute("categories");
  List<String> statuts = (List<String>) request.getAttribute("statuts");
  List<String> errors = (List<String>) request.getAttribute("errors");
  PlainArticleCreateRequest form = (PlainArticleCreateRequest) request.getAttribute("form");
  Set<Integer> selectedCategoryIds = (Set<Integer>) request.getAttribute("selectedCategoryIds");
  String submitLabel = (String) request.getAttribute("submitLabel");
  String formAction = (String) request.getAttribute("formAction");

  String titre = form == null || form.getTitre() == null ? "" : form.getTitre();
  String slug = form == null || form.getSlug() == null ? "" : form.getSlug();
  String sousTitre = form == null || form.getSousTitre() == null ? "" : form.getSousTitre();
  String chapeau = form == null || form.getChapeau() == null ? "" : form.getChapeau();
  String contenu = form == null || form.getContenu() == null ? "" : form.getContenu();
  String metaTitle = form == null || form.getMetaTitle() == null ? "" : form.getMetaTitle();
  String metaDescription = form == null || form.getMetaDescription() == null ? "" : form.getMetaDescription();
  String metaKeywords = form == null || form.getMetaKeywords() == null ? "" : form.getMetaKeywords();
  String statutValue = form == null || form.getStatut() == null ? "brouillon" : form.getStatut();
  String effectiveSubmitLabel = submitLabel == null ? "Creer" : submitLabel;
  String effectiveFormAction = formAction == null ? "/noframework/admin/articles/new" : formAction;
%>
<div class="flex min-h-screen">
  <aside class="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-slate-200 bg-white/95 px-6 py-7 backdrop-blur xl:block">
    <a href="/noframework/admin/dashboard" class="flex items-center gap-3">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-slate-900 text-white">IW</div>
      <div><p class="text-sm text-slate-500">Backoffice</p><p class="text-lg font-semibold text-slate-900">Iran War News</p></div>
    </a>
    <nav class="mt-10 space-y-1">
      <a href="/noframework/admin/dashboard" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Dashboard</a>
      <a href="/noframework/admin/articles" class="flex items-center gap-3 rounded-xl bg-blue-50 px-4 py-3 font-semibold text-blue-700">Articles</a>
      <a href="/noframework/admin/articles/drafts" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Brouillons</a>
      <a href="/noframework/admin/articles/archives" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Archives</a>
      <a href="/noframework/admin/categories" class="flex items-center gap-3 rounded-xl px-4 py-3 text-slate-600 transition hover:bg-slate-100">Categories</a>
    </nav>
  </aside>

  <div class="w-full xl:ml-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-white/85 backdrop-blur">
      <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
        <input type="search" placeholder="Rechercher..." class="h-11 w-full max-w-xl rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
        <div class="flex items-center gap-3">
          <a href="/noframework/home" target="_blank" class="hidden rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50 md:inline-flex">Voir le site</a>
          <a href="/noframework/logout" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Deconnexion</a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900"><%= "Mettre a jour".equals(effectiveSubmitLabel) ? "Modifier" : "Creer" %> un article</h1>
          <p class="mt-2 text-sm text-slate-600">Renseignez les informations editoriales, SEO et taxonomie avant publication.</p>
        </div>
        <a href="/noframework/admin/articles" class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Retour a la liste</a>
      </div>

      <div class="grid gap-6 lg:grid-cols-3">
        <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft lg:col-span-2">
          <% if (errors != null && !errors.isEmpty()) { %>
            <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800">
              <% for (String err : errors) { %><div><%= err %></div><% } %>
            </div>
          <% } %>

          <form action="<%= effectiveFormAction %>" method="post" class="space-y-5">
            <div>
              <label for="titre" class="mb-2 block text-sm font-semibold text-slate-700">Titre *</label>
              <input id="titre" name="titre" maxlength="255" value="<%= titre %>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
            </div>

            <div>
              <label for="slug" class="mb-2 block text-sm font-semibold text-slate-700">Slug (URL) *</label>
              <div class="flex rounded-xl border border-slate-200 bg-slate-50 focus-within:border-blue-300 focus-within:bg-white">
                <span class="inline-flex items-center border-r border-slate-200 px-4 text-sm text-slate-500">/article/</span>
                <input id="slug" name="slug" maxlength="270" value="<%= slug %>" class="h-11 w-full bg-transparent px-3 text-sm outline-none" />
              </div>
            </div>

            <div>
              <label for="sousTitre" class="mb-2 block text-sm font-semibold text-slate-700">Sous-titre</label>
              <input id="sousTitre" name="sousTitre" maxlength="255" value="<%= sousTitre %>" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
            </div>

            <div>
              <label for="chapeau" class="mb-2 block text-sm font-semibold text-slate-700">Chapeau</label>
              <textarea id="chapeau" name="chapeau" rows="3" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"><%= chapeau %></textarea>
            </div>

            <div>
              <label for="contenu" class="mb-2 block text-sm font-semibold text-slate-700">Contenu *</label>
              <textarea id="contenu" name="contenu" rows="12" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"><%= contenu %></textarea>
            </div>

            <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
              <h2 class="text-sm font-semibold uppercase tracking-wide text-slate-600">SEO</h2>
              <div class="mt-4 space-y-4">
                <div>
                  <label for="metaTitle" class="mb-2 block text-sm font-semibold text-slate-700">Meta Title</label>
                  <input id="metaTitle" name="metaTitle" maxlength="70" value="<%= metaTitle %>" class="h-11 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm outline-none transition focus:border-blue-300" />
                  <p class="mt-1 text-xs text-slate-500"><span id="metaTitleCount">0</span>/70 caracteres</p>
                </div>
                <div>
                  <label for="metaDescription" class="mb-2 block text-sm font-semibold text-slate-700">Meta Description</label>
                  <textarea id="metaDescription" name="metaDescription" rows="2" maxlength="165" class="w-full rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition focus:border-blue-300"><%= metaDescription %></textarea>
                  <p class="mt-1 text-xs text-slate-500"><span id="metaDescCount">0</span>/165 caracteres</p>
                </div>
                <div>
                  <label for="metaKeywords" class="mb-2 block text-sm font-semibold text-slate-700">Meta Keywords</label>
                  <input id="metaKeywords" name="metaKeywords" maxlength="255" value="<%= metaKeywords %>" class="h-11 w-full rounded-xl border border-slate-200 bg-white px-4 text-sm outline-none transition focus:border-blue-300" />
                </div>
              </div>
            </div>

            <div class="grid gap-4 md:grid-cols-2">
              <div>
                <label for="categoryIds" class="mb-2 block text-sm font-semibold text-slate-700">Categories</label>
                <div class="rounded-2xl border border-slate-200 bg-slate-50 p-3">
                  <select id="categoryIds" name="categoryIds" multiple class="hidden">
                    <% if (categories != null) {
                         for (PlainCategoryRow cat : categories) {
                           boolean selected = selectedCategoryIds != null && selectedCategoryIds.contains(cat.getId()); %>
                    <option value="<%= cat.getId() %>" <%= selected ? "selected" : "" %>><%= cat.getNom() %></option>
                    <%   }
                       } %>
                  </select>
                  <div id="categorieChips" class="flex flex-wrap gap-2" role="group" aria-label="Selection des categories">
                    <% if (categories != null) {
                         for (PlainCategoryRow cat : categories) {
                           boolean selected = selectedCategoryIds != null && selectedCategoryIds.contains(cat.getId()); %>
                    <button type="button" class="category-chip inline-flex items-center rounded-full border px-3 py-1.5 text-sm font-medium transition duration-150 <%= selected ? "bg-blue-600 border-blue-600 text-white shadow-sm" : "border-slate-300 bg-white text-slate-700 hover:-translate-y-0.5 hover:border-blue-200 hover:bg-blue-50 hover:text-blue-700" %>" data-category-id="<%= cat.getId() %>" aria-pressed="<%= selected %>"><%= cat.getNom() %></button>
                    <%   }
                       } %>
                  </div>
                </div>
              </div>

              <div>
                <label for="statut" class="mb-2 block text-sm font-semibold text-slate-700">Statut</label>
                <select id="statut" name="statut" class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white">
                  <% if (statuts != null) {
                       for (String s : statuts) { %>
                    <option value="<%= s %>" <%= s.equals(statutValue) ? "selected" : "" %>><%= s %></option>
                  <%   }
                     } %>
                </select>
              </div>
            </div>

            <label for="aLaUne" class="flex items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-medium text-slate-700">
              <input type="checkbox" id="aLaUne" name="aLaUne" class="h-4 w-4 rounded border-slate-300 text-blue-600" <%= form != null && form.isaLaUne() ? "checked" : "" %> />
              Mettre a la une
            </label>

            <div class="flex flex-wrap gap-3 pt-2">
              <button type="submit" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700"><%= "Mettre a jour".equals(effectiveSubmitLabel) ? "Enregistrer" : "Creer" %></button>
              <a href="/noframework/admin/articles" class="rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Annuler</a>
            </div>
          </form>
        </section>

        <aside class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
          <h2 class="text-lg font-semibold text-slate-900">Aide de redaction</h2>
          <div class="mt-4 space-y-4 text-sm text-slate-600">
            <p><span class="font-semibold text-slate-800">Titre :</span> titre principal de l'article.</p>
            <p><span class="font-semibold text-slate-800">Slug :</span> URL unique. Exemple: mon-article-2024.</p>
            <p><span class="font-semibold text-slate-800">Chapeau :</span> introduction resumee.</p>
            <p><span class="font-semibold text-slate-800">Contenu :</span> corps de l'article (HTML accepte).</p>
          </div>
        </aside>
      </div>
    </main>
  </div>
</div>

<script>
  function updateCount(inputId, countId) {
    const input = document.getElementById(inputId);
    const count = document.getElementById(countId);
    if (input && count) {
      count.textContent = input.value.length;
      input.addEventListener('input', () => {
        count.textContent = input.value.length;
      });
    }
  }

  updateCount('metaTitle', 'metaTitleCount');
  updateCount('metaDescription', 'metaDescCount');

  const titleInput = document.getElementById('titre');
  const slugInput = document.getElementById('slug');
  if (titleInput && slugInput) {
    titleInput.addEventListener('input', function() {
      if (!slugInput.value || slugInput.dataset.autoGenerated === 'true') {
        const slug = this.value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
        slugInput.value = slug;
        slugInput.dataset.autoGenerated = 'true';
      }
    });
    slugInput.addEventListener('input', function() {
      this.dataset.autoGenerated = 'false';
    });
  }

  const categoriesSelect = document.getElementById('categoryIds');
  const chipsContainer = document.getElementById('categorieChips');

  function setChipState(chip, selected) {
    chip.setAttribute('aria-pressed', selected ? 'true' : 'false');
    chip.classList.toggle('bg-blue-600', selected);
    chip.classList.toggle('border-blue-600', selected);
    chip.classList.toggle('text-white', selected);
    chip.classList.toggle('shadow-sm', selected);
    chip.classList.toggle('bg-white', !selected);
    chip.classList.toggle('border-slate-300', !selected);
    chip.classList.toggle('text-slate-700', !selected);
  }

  if (categoriesSelect && chipsContainer) {
    const chips = Array.from(chipsContainer.querySelectorAll('.category-chip'));
    chips.forEach((chip) => {
      const categoryId = chip.dataset.categoryId;
      chip.addEventListener('click', () => {
        const option = Array.from(categoriesSelect.options).find((opt) => String(opt.value) === String(categoryId));
        if (!option) return;
        option.selected = !option.selected;
        setChipState(chip, option.selected);
      });
    });
  }
</script>
</body>
</html>
