<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${mode == 'edit' ? 'Modifier' : 'Creer'} un article - BackOffice</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <style>
    .form-label { font-weight: 500; }
    .char-count { font-size: 0.85rem; }
  </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin"><i class="bi bi-gear me-2"></i>BackOffice</a>
    <div class="navbar-nav ms-auto">
      <a class="nav-link" href="/">Voir le site</a>
    </div>
  </div>
</nav>

<div class="container py-4">
  <h1 class="h3 mb-4">
    <i class="bi bi-${mode == 'edit' ? 'pencil' : 'plus-lg'} me-2"></i>
    ${mode == 'edit' ? 'Modifier' : 'Creer'} un article
  </h1>

  <div class="row">
    <div class="col-lg-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <form:form action="${mode == 'edit' ? '/admin/articles/'.concat(articleId) : '/admin/articles'}"
                     method="post" modelAttribute="articleForm">

            <div class="mb-3">
              <label for="titre" class="form-label">Titre *</label>
              <form:input path="titre" cssClass="form-control" id="titre" maxlength="255" />
              <form:errors path="titre" cssClass="text-danger small" />
            </div>

            <div class="mb-3">
              <label for="slug" class="form-label">Slug (URL) *</label>
              <div class="input-group">
                <span class="input-group-text">/article/</span>
                <form:input path="slug" cssClass="form-control" id="slug" maxlength="270" />
              </div>
              <form:errors path="slug" cssClass="text-danger small" />
              <small class="text-muted">Utiliser des lettres minuscules, chiffres et tirets uniquement</small>
            </div>

            <div class="mb-3">
              <label for="sousTitre" class="form-label">Sous-titre</label>
              <form:input path="sousTitre" cssClass="form-control" id="sousTitre" maxlength="255" />
              <form:errors path="sousTitre" cssClass="text-danger small" />
            </div>

            <div class="mb-3">
              <label for="chapeau" class="form-label">Chapeau</label>
              <form:textarea path="chapeau" cssClass="form-control" id="chapeau" rows="3" />
              <form:errors path="chapeau" cssClass="text-danger small" />
              <small class="text-muted">Resume de l'article affiche en introduction</small>
            </div>

            <div class="mb-3">
              <label for="contenu" class="form-label">Contenu *</label>
              <form:textarea path="contenu" cssClass="form-control" id="contenu" rows="12" />
              <form:errors path="contenu" cssClass="text-danger small" />
              <small class="text-muted">HTML autorise</small>
            </div>

            <hr class="my-4" />
            <h5 class="mb-3"><i class="bi bi-search me-2"></i>SEO</h5>

            <div class="mb-3">
              <label for="metaTitle" class="form-label">Meta Title</label>
              <form:input path="metaTitle" cssClass="form-control" id="metaTitle" maxlength="70" />
              <form:errors path="metaTitle" cssClass="text-danger small" />
              <small class="text-muted char-count">
                <span id="metaTitleCount">0</span>/70 caracteres
              </small>
            </div>

            <div class="mb-3">
              <label for="metaDescription" class="form-label">Meta Description</label>
              <form:textarea path="metaDescription" cssClass="form-control" id="metaDescription" rows="2" maxlength="165" />
              <form:errors path="metaDescription" cssClass="text-danger small" />
              <small class="text-muted char-count">
                <span id="metaDescCount">0</span>/165 caracteres
              </small>
            </div>

            <div class="mb-3">
              <label for="metaKeywords" class="form-label">Meta Keywords</label>
              <form:input path="metaKeywords" cssClass="form-control" id="metaKeywords" maxlength="255" />
              <form:errors path="metaKeywords" cssClass="text-danger small" />
              <small class="text-muted">Mots-cles separes par des virgules</small>
            </div>

            <hr class="my-4" />

            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="categorieId" class="form-label">Categorie</label>
                <form:select path="categorieId" cssClass="form-select" id="categorieId">
                  <form:option value="">-- Aucune categorie --</form:option>
                  <c:forEach items="${categories}" var="cat">
                    <form:option value="${cat.id}">${cat.nom}</form:option>
                  </c:forEach>
                </form:select>
              </div>

              <div class="col-md-6 mb-3">
                <label for="statut" class="form-label">Statut</label>
                <form:select path="statut" cssClass="form-select" id="statut">
                  <c:forEach items="${statuts}" var="s">
                    <form:option value="${s}">${s}</form:option>
                  </c:forEach>
                </form:select>
              </div>
            </div>

            <div class="mb-4">
              <div class="form-check">
                <form:checkbox path="ALaUne" cssClass="form-check-input" id="aLaUne" />
                <label class="form-check-label" for="aLaUne">
                  <i class="bi bi-star-fill text-warning me-1"></i>Mettre a la une
                </label>
              </div>
            </div>

            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-lg me-1"></i>${mode == 'edit' ? 'Enregistrer' : 'Creer'}
              </button>
              <a href="/admin/articles" class="btn btn-outline-secondary">
                <i class="bi bi-x-lg me-1"></i>Annuler
              </a>
            </div>

          </form:form>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-header">
          <i class="bi bi-info-circle me-2"></i>Aide
        </div>
        <div class="card-body small">
          <p><strong>Titre :</strong> Le titre principal de l'article.</p>
          <p><strong>Slug :</strong> L'URL unique de l'article. Exemple: mon-article-2024</p>
          <p><strong>Chapeau :</strong> Introduction resumant l'article.</p>
          <p><strong>Contenu :</strong> Le corps de l'article. Vous pouvez utiliser du HTML.</p>
          <hr />
          <p><strong>Meta Title :</strong> Titre affiche dans les resultats de recherche (70 car. max).</p>
          <p><strong>Meta Description :</strong> Description pour les moteurs de recherche (165 car. max).</p>
          <hr />
          <p><strong>Statuts :</strong></p>
          <ul class="mb-0">
            <li><strong>brouillon</strong> - Non visible</li>
            <li><strong>publie</strong> - Visible sur le site</li>
            <li><strong>archive</strong> - Non visible</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Character counters
  function updateCount(inputId, countId, max) {
    const input = document.getElementById(inputId);
    const count = document.getElementById(countId);
    if (input && count) {
      count.textContent = input.value.length;
      input.addEventListener('input', () => {
        count.textContent = input.value.length;
      });
    }
  }

  updateCount('metaTitle', 'metaTitleCount', 70);
  updateCount('metaDescription', 'metaDescCount', 165);

  // Auto-generate slug from title
  document.getElementById('titre').addEventListener('input', function() {
    const slugInput = document.getElementById('slug');
    if (!slugInput.value || slugInput.dataset.autoGenerated === 'true') {
      const slug = this.value
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-+|-+$/g, '');
      slugInput.value = slug;
      slugInput.dataset.autoGenerated = 'true';
    }
  });

  document.getElementById('slug').addEventListener('input', function() {
    this.dataset.autoGenerated = 'false';
  });
</script>
</body>
</html>
