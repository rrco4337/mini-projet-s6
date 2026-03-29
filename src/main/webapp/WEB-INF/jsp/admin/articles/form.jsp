<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${mode == 'edit' ? 'Modifier' : 'Créer'} un article - Iran War News</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <link rel="stylesheet" href="/css/style.css" />
  <style>
    .page-header {
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
      color: white;
      border-radius: 15px;
      margin-bottom: 2rem;
    }

    .form-section {
      background: white;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      border: none;
      margin-bottom: 2rem;
      overflow: hidden;
    }

    .section-header {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-bottom: 1px solid #dee2e6;
      padding: 1.25rem 1.5rem;
      margin: 0;
    }

    .section-icon {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
    }

    .icon-content { background: linear-gradient(45deg, #667eea, #764ba2); }
    .icon-seo { background: linear-gradient(45deg, #4facfe, #00f2fe); }
    .icon-settings { background: linear-gradient(45deg, #fa709a, #fee140); }

    .form-label {
      font-weight: 600;
      color: #495057;
      margin-bottom: 0.5rem;
    }

    .form-control, .form-select {
      border: 2px solid #e9ecef;
      border-radius: 10px;
      padding: 0.75rem 1rem;
      transition: all 0.3s ease;
    }

    .form-control:focus, .form-select:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
    }

    .char-counter {
      font-size: 0.85rem;
      padding: 0.25rem 0.75rem;
      border-radius: 15px;
      background: #f8f9fa;
      display: inline-block;
      margin-top: 0.25rem;
    }

    .char-counter.warning { background: #fff3cd; color: #856404; }
    .char-counter.danger { background: #f8d7da; color: #721c24; }

    .help-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px;
      border: none;
      position: sticky;
      top: 20px;
    }

    .help-card .card-header {
      background: rgba(255,255,255,0.1);
      border-color: rgba(255,255,255,0.1);
      border-radius: 15px 15px 0 0;
    }

    .form-check-input:checked {
      background-color: #667eea;
      border-color: #667eea;
    }

    .btn-primary {
      background: linear-gradient(45deg, #667eea, #764ba2);
      border: none;
      border-radius: 10px;
      padding: 0.75rem 2rem;
      font-weight: 600;
    }

    .btn-primary:hover {
      background: linear-gradient(45deg, #5a67d8, #6b46c1);
      transform: translateY(-1px);
    }

    .btn-outline-secondary {
      border: 2px solid #e9ecef;
      border-radius: 10px;
      padding: 0.75rem 2rem;
      font-weight: 600;
    }

    .preview-badge {
      background: linear-gradient(45deg, #28a745, #20c997);
      color: white;
      border-radius: 20px;
      padding: 0.5rem 1rem;
      font-size: 0.85rem;
      border: none;
    }

    .status-badge-publie { background: linear-gradient(45deg, #28a745, #20c997); }
    .status-badge-brouillon { background: linear-gradient(45deg, #ffc107, #fd7e14); }
    .status-badge-archive { background: linear-gradient(45deg, #6c757d, #495057); }

    @keyframes slideInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .animate-section {
      animation: slideInUp 0.6s ease-out forwards;
    }

    .slug-preview {
      background: #f8f9fa;
      border: 2px dashed #dee2e6;
      border-radius: 10px;
      padding: 1rem;
      margin-top: 0.5rem;
    }
  </style>
</head>
<body class="bg-light">

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin">
      <i class="bi bi-shield-check me-2"></i>BackOffice
    </a>
    <div class="navbar-nav ms-auto">
      <a class="nav-link" href="/" target="_blank">
        <i class="bi bi-box-arrow-up-right me-1"></i>Voir le site
      </a>
      <a class="nav-link" href="/logout">
        <i class="bi bi-box-arrow-right me-1"></i>Déconnexion
      </a>
    </div>
  </div>
</nav>

<div class="container py-4">
  <!-- Header -->
  <div class="page-header p-4">
    <div class="d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h2 mb-2">
          <i class="bi bi-${mode == 'edit' ? 'pencil-square' : 'plus-square'} me-3"></i>
          ${mode == 'edit' ? 'Modifier' : 'Créer'} un Article
        </h1>
        <p class="mb-0 opacity-75">
          ${mode == 'edit' ? 'Modifiez les détails de votre article' : 'Rédigez un nouvel article pour votre site'}
        </p>
      </div>
      <c:if test="${mode == 'edit'}">
        <a class="btn btn-light" href="/article/${articleForm.slug}" target="_blank">
          <i class="bi bi-eye me-2"></i>Prévisualiser
        </a>
      </c:if>
    </div>
  </div>

  <form:form action="${mode == 'edit' ? '/admin/articles/'.concat(articleId) : '/admin/articles'}"
             method="post" modelAttribute="articleForm">

    <div class="row">
      <div class="col-lg-8">
        <!-- Content Section -->
        <div class="form-section animate-section">
          <div class="section-header">
            <div class="d-flex align-items-center">
              <div class="section-icon icon-content">
                <i class="bi bi-file-text text-white"></i>
              </div>
              <div>
                <h5 class="mb-1">Contenu Principal</h5>
                <small class="text-muted">Informations essentielles de votre article</small>
              </div>
            </div>
          </div>
          <div class="card-body p-4">
            <div class="row">
              <div class="col-md-8 mb-3">
                <label for="titre" class="form-label">
                  <i class="bi bi-type me-2"></i>Titre *
                </label>
                <form:input path="titre" cssClass="form-control" id="titre" maxlength="255"
                           placeholder="Saisissez le titre de votre article..." />
                <form:errors path="titre" cssClass="text-danger small mt-1 d-block" />
                <small class="text-muted">Le titre principal visible sur votre site</small>
              </div>
              <div class="col-md-4 mb-3">
                <label for="statut" class="form-label">
                  <i class="bi bi-circle-fill me-2"></i>Statut
                </label>
                <form:select path="statut" cssClass="form-select" id="statut">
                  <c:forEach items="${statuts}" var="s">
                    <form:option value="${s}">${s == 'publie' ? 'Publié' : s == 'brouillon' ? 'Brouillon' : 'Archivé'}</form:option>
                  </c:forEach>
                </form:select>
              </div>
            </div>

            <div class="mb-3">
              <label for="slug" class="form-label">
                <i class="bi bi-link-45deg me-2"></i>Slug (URL) *
              </label>
              <div class="input-group">
                <span class="input-group-text bg-light">/article/</span>
                <form:input path="slug" cssClass="form-control" id="slug" maxlength="270"
                           placeholder="url-de-votre-article" />
              </div>
              <form:errors path="slug" cssClass="text-danger small mt-1 d-block" />
              <div class="slug-preview" id="slugPreview" style="display: none;">
                <small class="text-muted">
                  <i class="bi bi-globe me-1"></i>URL complète :
                  <strong id="fullUrl">http://localhost:8080/article/</strong>
                </small>
              </div>
            </div>

            <div class="mb-3">
              <label for="sousTitre" class="form-label">
                <i class="bi bi-subtitle me-2"></i>Sous-titre
              </label>
              <form:input path="sousTitre" cssClass="form-control" id="sousTitre" maxlength="255"
                         placeholder="Un sous-titre optionnel..." />
              <form:errors path="sousTitre" cssClass="text-danger small mt-1 d-block" />
            </div>

            <div class="mb-3">
              <label for="chapeau" class="form-label">
                <i class="bi bi-quote me-2"></i>Chapeau
              </label>
              <form:textarea path="chapeau" cssClass="form-control" id="chapeau" rows="3"
                           placeholder="Introduction ou résumé de l'article..." />
              <form:errors path="chapeau" cssClass="text-danger small mt-1 d-block" />
              <small class="text-muted">Résumé affiché en introduction de l'article</small>
            </div>

            <div class="mb-3">
              <label for="contenu" class="form-label">
                <i class="bi bi-file-richtext me-2"></i>Contenu principal *
              </label>
              <form:textarea path="contenu" cssClass="form-control" id="contenu" rows="15"
                           placeholder="Rédigez le contenu de votre article ici..." />
              <form:errors path="contenu" cssClass="text-danger small mt-1 d-block" />
              <small class="text-muted">
                <i class="bi bi-info-circle me-1"></i>HTML autorisé pour le formatage
              </small>
            </div>
          </div>
        </div>

        <!-- SEO Section -->
        <div class="form-section animate-section" style="animation-delay: 0.2s">
          <div class="section-header">
            <div class="d-flex align-items-center">
              <div class="section-icon icon-seo">
                <i class="bi bi-search text-white"></i>
              </div>
              <div>
                <h5 class="mb-1">Optimisation SEO</h5>
                <small class="text-muted">Améliorez votre référencement naturel</small>
              </div>
            </div>
          </div>
          <div class="card-body p-4">
            <div class="mb-3">
              <label for="metaTitle" class="form-label">
                <i class="bi bi-tag me-2"></i>Meta Title
              </label>
              <form:input path="metaTitle" cssClass="form-control" id="metaTitle" maxlength="70"
                         placeholder="Titre pour les moteurs de recherche..." />
              <form:errors path="metaTitle" cssClass="text-danger small mt-1 d-block" />
              <span class="char-counter" id="metaTitleCounter">0/70 caractères</span>
            </div>

            <div class="mb-3">
              <label for="metaDescription" class="form-label">
                <i class="bi bi-card-text me-2"></i>Meta Description
              </label>
              <form:textarea path="metaDescription" cssClass="form-control" id="metaDescription"
                           rows="3" maxlength="165"
                           placeholder="Description pour les résultats de recherche..." />
              <form:errors path="metaDescription" cssClass="text-danger small mt-1 d-block" />
              <span class="char-counter" id="metaDescCounter">0/165 caractères</span>
            </div>

            <div class="mb-3">
              <label for="metaKeywords" class="form-label">
                <i class="bi bi-tags me-2"></i>Meta Keywords
              </label>
              <form:input path="metaKeywords" cssClass="form-control" id="metaKeywords" maxlength="255"
                         placeholder="mot-clé1, mot-clé2, mot-clé3..." />
              <form:errors path="metaKeywords" cssClass="text-danger small mt-1 d-block" />
              <small class="text-muted">Séparez les mots-clés par des virgules</small>
            </div>
          </div>
        </div>

        <!-- Settings Section -->
        <div class="form-section animate-section" style="animation-delay: 0.4s">
          <div class="section-header">
            <div class="d-flex align-items-center">
              <div class="section-icon icon-settings">
                <i class="bi bi-gear text-white"></i>
              </div>
              <div>
                <h5 class="mb-1">Paramètres</h5>
                <small class="text-muted">Configuration et organisation</small>
              </div>
            </div>
          </div>
          <div class="card-body p-4">
            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="categorieId" class="form-label">
                  <i class="bi bi-folder me-2"></i>Catégorie
                </label>
                <form:select path="categorieId" cssClass="form-select" id="categorieId">
                  <form:option value="">-- Aucune catégorie --</form:option>
                  <c:forEach items="${categories}" var="cat">
                    <form:option value="${cat.id}">${cat.nom}</form:option>
                  </c:forEach>
                </form:select>
                <small class="text-muted">Classez votre article par thématique</small>
              </div>
              <div class="col-md-6 mb-3">
                <div class="form-check form-switch mt-4">
                  <form:checkbox path="aLaUne" cssClass="form-check-input" id="aLaUne" />
                  <label class="form-check-label fw-bold" for="aLaUne">
                    <i class="bi bi-star-fill text-warning me-2"></i>
                    Mettre à la une
                  </label>
                </div>
                <small class="text-muted d-block">Afficher en vedette sur la page d'accueil</small>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="d-flex gap-3 mb-4">
          <button type="submit" class="btn btn-primary btn-lg">
            <i class="bi bi-check-lg me-2"></i>
            ${mode == 'edit' ? 'Enregistrer les modifications' : 'Publier l\'article'}
          </button>
          <a href="/admin/articles" class="btn btn-outline-secondary btn-lg">
            <i class="bi bi-arrow-left me-2"></i>Retour à la liste
          </a>
        </div>
      </div>

      <!-- Sidebar -->
      <div class="col-lg-4">
        <div class="help-card card animate-section" style="animation-delay: 0.6s">
          <div class="card-header">
            <h6 class="card-title text-white mb-0">
              <i class="bi bi-lightbulb me-2"></i>Guide de rédaction
            </h6>
          </div>
          <div class="card-body">
            <div class="mb-4">
              <h6 class="text-white"><i class="bi bi-pencil me-2"></i>Contenu</h6>
              <ul class="small mb-0 text-white-50">
                <li><strong>Titre :</strong> Accrocheur et informatif (50-60 caractères idéal)</li>
                <li><strong>Slug :</strong> URL propre sans espaces ni caractères spéciaux</li>
                <li><strong>Chapeau :</strong> Résumé engageant de 2-3 phrases</li>
                <li><strong>Contenu :</strong> Structure claire avec titres et paragraphes</li>
              </ul>
            </div>

            <div class="mb-4">
              <h6 class="text-white"><i class="bi bi-graph-up me-2"></i>SEO</h6>
              <ul class="small mb-0 text-white-50">
                <li><strong>Meta Title :</strong> 50-60 caractères avec mot-clé principal</li>
                <li><strong>Meta Description :</strong> 150-160 caractères engageants</li>
                <li><strong>Keywords :</strong> 3-5 mots-clés pertinents maximum</li>
              </ul>
            </div>

            <div class="mb-4">
              <h6 class="text-white"><i class="bi bi-gear me-2"></i>Statuts</h6>
              <div class="d-flex flex-column gap-2">
                <span class="badge status-badge-brouillon">
                  <i class="bi bi-pencil me-1"></i>Brouillon - Non visible
                </span>
                <span class="badge status-badge-publie">
                  <i class="bi bi-check-circle me-1"></i>Publié - Visible
                </span>
                <span class="badge status-badge-archive">
                  <i class="bi bi-archive me-1"></i>Archivé - Masqué
                </span>
              </div>
            </div>

            <div class="alert alert-light mb-0">
              <small class="text-dark">
                <i class="bi bi-info-circle me-1"></i>
                <strong>Conseil :</strong> Utilisez le mode brouillon pour préparer vos articles avant publication.
              </small>
            </div>
          </div>
        </div>

        <!-- Preview Card -->
        <div class="card mt-3 animate-section" style="animation-delay: 0.8s">
          <div class="card-header bg-light">
            <h6 class="card-title mb-0">
              <i class="bi bi-eye me-2"></i>Aperçu en temps réel
            </h6>
          </div>
          <div class="card-body" id="livePreview">
            <div class="placeholder-glow">
              <span class="badge preview-badge mb-2">En attente...</span>
              <h6 class="placeholder col-8"></h6>
              <p class="placeholder col-12"></p>
              <p class="placeholder col-6"></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </form:form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Character counters with visual feedback
function setupCharCounter(inputId, counterId, maxLength) {
  const input = document.getElementById(inputId);
  const counter = document.getElementById(counterId);

  function updateCounter() {
    const length = input.value.length;
    counter.textContent = `${length}/${maxLength} caractères`;

    // Visual feedback
    counter.className = 'char-counter';
    if (length > maxLength * 0.8) {
      counter.classList.add('warning');
    }
    if (length > maxLength * 0.95) {
      counter.classList.remove('warning');
      counter.classList.add('danger');
    }
  }

  input.addEventListener('input', updateCounter);
  updateCounter(); // Initialize
}

setupCharCounter('metaTitle', 'metaTitleCounter', 70);
setupCharCounter('metaDescription', 'metaDescCounter', 165);

// Slug management
const titreInput = document.getElementById('titre');
const slugInput = document.getElementById('slug');
const fullUrlSpan = document.getElementById('fullUrl');
const slugPreview = document.getElementById('slugPreview');

function updateSlugPreview() {
  const slug = slugInput.value;
  if (slug) {
    fullUrlSpan.textContent = `http://localhost:8080/article/${slug}`;
    slugPreview.style.display = 'block';
  } else {
    slugPreview.style.display = 'none';
  }
}

function generateSlug(text) {
  return text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

titreInput.addEventListener('input', function() {
  if (!slugInput.dataset.manuallyEdited) {
    const slug = generateSlug(this.value);
    slugInput.value = slug;
    updateSlugPreview();
  }
});

slugInput.addEventListener('input', function() {
  this.dataset.manuallyEdited = 'true';
  updateSlugPreview();
});

// Initialize
updateSlugPreview();

// Live preview
function updateLivePreview() {
  const titre = document.getElementById('titre').value;
  const chapeau = document.getElementById('chapeau').value;
  const statut = document.getElementById('statut').value;
  const preview = document.getElementById('livePreview');

  let statusText = 'En attente...';
  let statusClass = 'preview-badge';

  switch(statut) {
    case 'publie':
      statusText = 'Publié';
      statusClass = 'badge status-badge-publie';
      break;
    case 'brouillon':
      statusText = 'Brouillon';
      statusClass = 'badge status-badge-brouillon';
      break;
    case 'archive':
      statusText = 'Archivé';
      statusClass = 'badge status-badge-archive';
      break;
  }

  preview.innerHTML = `
    <span class="${statusClass} mb-2">${statusText}</span>
    <h6 class="mt-2">${titre || 'Titre de l\'article'}</h6>
    <p class="text-muted small mb-0">${chapeau || 'Chapeau de l\'article apparaîtra ici...'}</p>
  `;
}

// Update preview on input changes
['titre', 'chapeau', 'statut'].forEach(id => {
  document.getElementById(id).addEventListener('input', updateLivePreview);
});

// Initialize preview
updateLivePreview();

// Smooth reveal animations
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.animate-section').forEach((el) => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(30px)';
  observer.observe(el);
});
</script>
</body>
</html>
