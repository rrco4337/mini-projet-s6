<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestion des Catégories - Iran War News</title>
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

    .category-card {
      border: none;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      transition: all 0.3s ease;
      margin-bottom: 1.5rem;
      overflow: hidden;
      background: white;
    }

    .category-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }

    .category-icon {
      width: 60px;
      height: 60px;
      border-radius: 15px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 1rem;
    }

    .stats-card {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      border-radius: 15px;
      color: white;
      padding: 1.5rem;
      text-align: center;
      border: none;
      margin-bottom: 1.5rem;
    }

    .action-btn {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: none;
      transition: all 0.3s ease;
      margin: 0 3px;
    }

    .action-btn:hover {
      transform: scale(1.1);
    }

    .btn-edit {
      background: linear-gradient(45deg, #6f42c1, #e83e8c);
      color: white;
    }

    .btn-delete {
      background: linear-gradient(45deg, #dc3545, #fd7e14);
      color: white;
    }

    .search-box {
      background: white;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      border: 2px solid #e9ecef;
      padding: 0.75rem 1rem;
      transition: all 0.3s ease;
    }

    .search-box:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
    }

    .category-meta {
      font-size: 0.85rem;
      color: #6c757d;
    }

    .empty-state {
      text-align: center;
      padding: 4rem 1rem;
      background: white;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
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

    .animate-category {
      animation: slideInUp 0.6s ease-out forwards;
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
          <i class="bi bi-folder2 me-3"></i>Gestion des Catégories
        </h1>
        <p class="mb-0 opacity-75">Organisez et structurez votre contenu par thématiques</p>
      </div>
      <a class="btn btn-light btn-lg" href="/categories/new">
        <i class="bi bi-plus-lg me-2"></i>Nouvelle Catégorie
      </a>
    </div>
  </div>

  <!-- Messages -->
  <c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
      <i class="bi bi-check-circle me-2"></i>${successMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
      <i class="bi bi-exclamation-circle me-2"></i>${errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="row">
    <!-- Sidebar -->
    <div class="col-lg-3 mb-4">
      <!-- Stats Card -->
      <div class="stats-card">
        <div class="fs-3 fw-bold mb-1">${not empty categories ? categories.size() : 0}</div>
        <div class="small opacity-75">Catégories Total</div>
      </div>

      <!-- Search -->
      <div class="mb-3">
        <input type="text" class="form-control search-box" id="searchInput"
               placeholder="Rechercher une catégorie..." />
      </div>

      <div class="mt-3">
        <a href="/admin" class="btn btn-outline-secondary w-100">
          <i class="bi bi-arrow-left me-1"></i>Retour au dashboard
        </a>
      </div>
    </div>

    <!-- Main Content -->
    <div class="col-lg-9">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h5 class="mb-1">Toutes les Catégories</h5>
          <p class="text-muted small mb-0" id="resultsCount">
            <span class="results-number">${not empty categories ? categories.size() : 0}</span> catégorie(s) trouvée(s)
          </p>
        </div>
      </div>

      <!-- Categories Grid -->
      <div class="row" id="categoriesGrid">
        <c:forEach items="${categories}" var="category" varStatus="status">
          <div class="col-lg-6 col-xl-4 category-item animate-category"
               style="animation-delay: ${status.index * 0.1}s"
               data-name="${category.nom}"
               data-slug="${category.slug}"
               data-description="${category.description}">
            <div class="category-card card h-100">
              <div class="card-body d-flex flex-column">
                <div class="d-flex align-items-start justify-content-between mb-3">
                  <div class="category-icon">
                    <i class="bi bi-folder2-open text-white fs-4"></i>
                  </div>
                  <div class="d-flex">
                    <a class="action-btn btn-edit" href="/categories/${category.id}/edit"
                       title="Modifier" data-bs-toggle="tooltip">
                      <i class="bi bi-pencil"></i>
                    </a>
                    <form action="/categories/${category.id}/delete" method="post" class="d-inline">
                      <button type="submit" class="action-btn btn-delete"
                              title="Supprimer" data-bs-toggle="tooltip"
                              onclick="return confirm('Supprimer cette catégorie ? Tous les articles associés perdront leur catégorie.');">
                        <i class="bi bi-trash"></i>
                      </button>
                    </form>
                  </div>
                </div>

                <div class="flex-grow-1">
                  <h6 class="card-title fw-bold mb-2">
                    <c:out value="${category.nom}" />
                  </h6>

                  <p class="category-meta mb-2">
                    <i class="bi bi-link-45deg me-1"></i>
                    <small class="text-muted">/${category.slug}</small>
                  </p>

                  <p class="text-muted small mb-3">
                    <c:choose>
                      <c:when test="${not empty category.description}">
                        <c:out value="${category.description}" />
                      </c:when>
                      <c:otherwise>
                        <em>Aucune description disponible</em>
                      </c:otherwise>
                    </c:choose>
                  </p>
                </div>

                <div class="mt-auto">
                  <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted">
                      <i class="bi bi-hash me-1"></i>ID: ${category.id}
                    </small>
                    <span class="badge bg-primary">
                      <i class="bi bi-folder me-1"></i>Catégorie
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>

        <c:if test="${empty categories}">
          <div class="col-12">
            <div class="empty-state">
              <div class="display-1 text-muted mb-4">
                <i class="bi bi-folder-plus"></i>
              </div>
              <h5 class="text-muted mb-3">Aucune catégorie trouvée</h5>
              <p class="text-muted mb-4">
                Commencez par créer votre première catégorie pour organiser vos articles !
              </p>
              <a href="/categories/new" class="btn btn-primary btn-lg">
                <i class="bi bi-plus-lg me-2"></i>Créer une Catégorie
              </a>
            </div>
          </div>
        </c:if>
      </div>

      <!-- Quick Actions -->
      <c:if test="${not empty categories}">
        <div class="mt-5">
          <div class="card shadow-sm" style="border-radius: 15px; border: none;">
            <div class="card-header bg-light" style="border-radius: 15px 15px 0 0;">
              <h6 class="card-title mb-0">
                <i class="bi bi-lightning me-2"></i>Actions Rapides
              </h6>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-4 text-center">
                  <a href="/categories/new" class="btn btn-outline-primary w-100 py-2">
                    <i class="bi bi-plus-lg d-block mb-2"></i>
                    <strong>Nouvelle Catégorie</strong>
                  </a>
                </div>
                <div class="col-md-4 text-center">
                  <a href="/admin/articles" class="btn btn-outline-secondary w-100 py-2">
                    <i class="bi bi-newspaper d-block mb-2"></i>
                    <strong>Gérer Articles</strong>
                  </a>
                </div>
                <div class="col-md-4 text-center">
                  <a href="/admin" class="btn btn-outline-success w-100 py-2">
                    <i class="bi bi-speedometer2 d-block mb-2"></i>
                    <strong>Dashboard</strong>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </c:if>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Initialize tooltips
const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
});

// Search functionality
const searchInput = document.getElementById('searchInput');
const resultsNumber = document.querySelector('.results-number');

function filterCategories() {
  const searchTerm = searchInput.value.toLowerCase();
  const categories = document.querySelectorAll('.category-item');
  let visibleCount = 0;

  categories.forEach(category => {
    const name = category.dataset.name.toLowerCase();
    const slug = category.dataset.slug.toLowerCase();
    const description = category.dataset.description ? category.dataset.description.toLowerCase() : '';

    const matches = name.includes(searchTerm) ||
                   slug.includes(searchTerm) ||
                   description.includes(searchTerm);

    if (matches) {
      category.style.display = 'block';
      visibleCount++;
    } else {
      category.style.display = 'none';
    }
  });

  resultsNumber.textContent = visibleCount;
}

searchInput.addEventListener('input', filterCategories);

// Smooth animations
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.animate-category').forEach((el, index) => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(30px)';
  observer.observe(el);
});

// Confirmation for deletion with more details
document.querySelectorAll('.btn-delete').forEach(button => {
  button.addEventListener('click', function(e) {
    const categoryCard = this.closest('.category-item');
    const categoryName = categoryCard.dataset.name;

    if (!confirm(`Êtes-vous sûr de vouloir supprimer la catégorie "${categoryName}" ?\n\nCette action est irréversible et tous les articles associés perdront leur catégorie.`)) {
      e.preventDefault();
    }
  });
});
</script>
</body>
</html>
