<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><c:out value="${mode == 'edit' ? 'Modifier' : 'Nouvelle'}"/> catégorie - Iran War News</title>
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
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1.25rem 1.5rem;
      margin: 0;
    }

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

    .help-card {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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

    .slug-preview {
      background: #f8f9fa;
      border: 2px dashed #dee2e6;
      border-radius: 10px;
      padding: 1rem;
      margin-top: 0.5rem;
    }

    .icon-box {
      width: 60px;
      height: 60px;
      border-radius: 15px;
      background: linear-gradient(45deg, #667eea, #764ba2);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 1rem;
    }

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

    .validation-feedback {
      display: block;
      font-size: 0.875rem;
      margin-top: 0.25rem;
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

<div class="container py-4" style="max-width: 1000px;">
  <!-- Header -->
  <div class="page-header p-4">
    <div class="d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h2 mb-2">
          <i class="bi bi-${mode == 'edit' ? 'pencil-square' : 'folder-plus'} me-3"></i>
          <c:out value="${mode == 'edit' ? 'Modifier' : 'Créer'}"/> une Catégorie
        </h1>
        <p class="mb-0 opacity-75">
          ${mode == 'edit' ? 'Modifiez les détails de votre catégorie' : 'Organisez votre contenu par thématiques'}
        </p>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-8">
      <!-- Form Section -->
      <div class="form-section animate-section">
        <div class="section-header">
          <div class="d-flex align-items-center">
            <i class="bi bi-folder2 me-3 fs-4"></i>
            <div>
              <h5 class="mb-1">Informations de la Catégorie</h5>
              <small class="opacity-75">Définissez les caractéristiques de votre catégorie</small>
            </div>
          </div>
        </div>
        <div class="card-body p-4">
          <c:choose>
            <c:when test="${mode == 'edit'}">
              <form:form method="post" modelAttribute="categoryForm" action="/categories/${categoryId}">
                <jsp:include page="_fields_enhanced.jsp" />
              </form:form>
            </c:when>
            <c:otherwise>
              <form:form method="post" modelAttribute="categoryForm" action="/categories">
                <jsp:include page="_fields_enhanced.jsp" />
              </form:form>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
      <!-- Help Card -->
      <div class="help-card card animate-section" style="animation-delay: 0.3s">
        <div class="card-header">
          <h6 class="card-title text-white mb-0">
            <i class="bi bi-lightbulb me-2"></i>Guide des Catégories
          </h6>
        </div>
        <div class="card-body">
          <div class="mb-4">
            <h6 class="text-white"><i class="bi bi-folder me-2"></i>Organisation</h6>
            <ul class="small mb-0 text-white-50">
              <li><strong>Nom :</strong> Court et descriptif (ex: "Politique", "Économie")</li>
              <li><strong>Slug :</strong> URL propre pour la navigation</li>
              <li><strong>Description :</strong> Courte explication de la thématique</li>
            </ul>
          </div>

          <div class="mb-4">
            <h6 class="text-white"><i class="bi bi-lightbulb me-2"></i>Bonnes Pratiques</h6>
            <ul class="small mb-0 text-white-50">
              <li>Utilisez des noms clairs et évidents</li>
              <li>Évitez les catégories trop spécifiques</li>
              <li>Limitez à 5-8 catégories principales</li>
              <li>Pensez SEO pour les slugs</li>
            </ul>
          </div>

          <div class="alert alert-light mb-0">
            <small class="text-dark">
              <i class="bi bi-info-circle me-1"></i>
              <strong>Info :</strong> Les catégories aident vos visiteurs à naviguer et trouvent votre contenu plus facilement.
            </small>
          </div>
        </div>
      </div>

      <!-- Examples Card -->
      <div class="card mt-3 animate-section" style="animation-delay: 0.5s; border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.08);">
        <div class="card-header bg-light" style="border-radius: 15px 15px 0 0;">
          <h6 class="card-title mb-0">
            <i class="bi bi-collection me-2"></i>Exemples de Catégories
          </h6>
        </div>
        <div class="card-body">
          <div class="d-flex align-items-center mb-3">
            <div class="icon-box me-3" style="width: 40px; height: 40px;">
              <i class="bi bi-globe text-white"></i>
            </div>
            <div>
              <h6 class="mb-0">International</h6>
              <small class="text-muted">Actualités mondiales</small>
            </div>
          </div>

          <div class="d-flex align-items-center mb-3">
            <div class="icon-box me-3" style="width: 40px; height: 40px;">
              <i class="bi bi-bank text-white"></i>
            </div>
            <div>
              <h6 class="mb-0">Politique</h6>
              <small class="text-muted">Vie politique nationale</small>
            </div>
          </div>

          <div class="d-flex align-items-center">
            <div class="icon-box me-3" style="width: 40px; height: 40px;">
              <i class="bi bi-graph-up text-white"></i>
            </div>
            <div>
              <h6 class="mb-0">Économie</h6>
              <small class="text-muted">Analyses économiques</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Auto-generate slug from name
document.getElementById('nom').addEventListener('input', function() {
  const slugInput = document.getElementById('slug');
  if (!slugInput.dataset.manuallyEdited) {
    const slug = this.value
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
    slugInput.value = slug;
    updateSlugPreview();
  }
});

document.getElementById('slug').addEventListener('input', function() {
  this.dataset.manuallyEdited = 'true';
  updateSlugPreview();
});

function updateSlugPreview() {
  const slug = document.getElementById('slug').value;
  const preview = document.getElementById('slugPreview');
  const fullUrl = document.getElementById('fullUrl');

  if (slug) {
    fullUrl.textContent = `http://localhost:8080/category/${slug}`;
    preview.style.display = 'block';
  } else {
    preview.style.display = 'none';
  }
}

// Initialize
updateSlugPreview();

// Smooth animations
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
