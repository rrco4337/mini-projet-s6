<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tableau de bord - Iran War News</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <link rel="stylesheet" href="/css/style.css" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    .dashboard-header {
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
      color: white;
      border-radius: 15px;
      margin-bottom: 2rem;
    }

    .stats-card {
      border: none;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      overflow: hidden;
      position: relative;
    }

    .stats-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    }

    .stats-card-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .stats-card-success { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
    .stats-card-warning { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
    .stats-card-info { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
    .stats-card-danger { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }

    .stats-card .card-body {
      position: relative;
      z-index: 2;
      color: white;
    }

    .stats-icon {
      position: absolute;
      right: 15px;
      top: 15px;
      font-size: 3rem;
      opacity: 0.3;
    }

    .stats-number {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 0;
    }

    .stats-label {
      font-size: 0.9rem;
      opacity: 0.9;
      margin-bottom: 0;
    }

    .chart-container {
      position: relative;
      height: 300px;
      margin-bottom: 2rem;
    }

    .activity-item {
      border-left: 4px solid #e94560;
      padding: 1rem;
      margin-bottom: 1rem;
      background: #f8f9fa;
      border-radius: 0 10px 10px 0;
      transition: all 0.3s ease;
    }

    .activity-item:hover {
      background: #e3f2fd;
      transform: translateX(5px);
    }

    .performance-meter {
      height: 8px;
      background: #e9ecef;
      border-radius: 10px;
      overflow: hidden;
    }

    .performance-fill {
      height: 100%;
      background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%);
      transition: width 1.5s ease-in-out;
      border-radius: 10px;
    }

    .quick-action-btn {
      border-radius: 12px;
      padding: 1rem;
      border: none;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      transition: all 0.3s ease;
      text-decoration: none;
      display: block;
    }

    .quick-action-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      color: white;
    }

    .welcome-text {
      font-size: 1.1rem;
      opacity: 0.9;
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .animate-card {
      animation: fadeInUp 0.6s ease-out forwards;
    }

    .animate-card:nth-child(1) { animation-delay: 0.1s; }
    .animate-card:nth-child(2) { animation-delay: 0.2s; }
    .animate-card:nth-child(3) { animation-delay: 0.3s; }
    .animate-card:nth-child(4) { animation-delay: 0.4s; }
    .animate-card:nth-child(5) { animation-delay: 0.5s; }
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
  <div class="dashboard-header p-4 text-center">
    <h1 class="h2 mb-3">
      <i class="bi bi-speedometer2 me-3"></i>
      Tableau de bord Iran War News
    </h1>
    <p class="welcome-text mb-0">
      Bienvenue dans votre espace d'administration. Gérez efficacement votre contenu éditorial.
    </p>
  </div>

  <!-- Statistiques principales -->
  <div class="row mb-5">
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card stats-card stats-card-primary animate-card">
        <div class="stats-icon">
          <i class="bi bi-newspaper"></i>
        </div>
        <div class="card-body">
          <div class="stats-number">${totalArticles}</div>
          <div class="stats-label">Articles Total</div>
        </div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card stats-card stats-card-success animate-card">
        <div class="stats-icon">
          <i class="bi bi-check-circle"></i>
        </div>
        <div class="card-body">
          <div class="stats-number">${publishedCount}</div>
          <div class="stats-label">Articles Publiés</div>
        </div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card stats-card stats-card-warning animate-card">
        <div class="stats-icon">
          <i class="bi bi-star-fill"></i>
        </div>
        <div class="card-body">
          <div class="stats-number">${featuredCount}</div>
          <div class="stats-label">À la une</div>
        </div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card stats-card stats-card-info animate-card">
        <div class="stats-icon">
          <i class="bi bi-eye"></i>
        </div>
        <div class="card-body">
          <div class="stats-number">
            <c:choose>
              <c:when test="${totalViews >= 1000}">
                <fmt:formatNumber value="${totalViews / 1000}" maxFractionDigits="1" />k
              </c:when>
              <c:otherwise>${totalViews}</c:otherwise>
            </c:choose>
          </div>
          <div class="stats-label">Vues Totales</div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <!-- Graphiques et analytics -->
    <div class="col-lg-8 mb-4">
      <div class="card shadow-sm animate-card">
        <div class="card-header bg-transparent">
          <h5 class="card-title mb-0">
            <i class="bi bi-pie-chart me-2"></i>Répartition des Articles
          </h5>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <canvas id="statusChart"></canvas>
          </div>

          <div class="row mt-4">
            <div class="col-md-4 text-center">
              <div class="mb-3">
                <div class="d-inline-flex align-items-center justify-content-center bg-success text-white rounded-circle" style="width: 50px; height: 50px;">
                  <i class="bi bi-check-lg"></i>
                </div>
              </div>
              <h6>Articles Publiés</h6>
              <div class="performance-meter mb-2">
                <div class="performance-fill" style="width: ${totalArticles > 0 ? (publishedCount * 100 / totalArticles) : 0}%"></div>
              </div>
              <small class="text-muted">${publishedCount} / ${totalArticles}</small>
            </div>

            <div class="col-md-4 text-center">
              <div class="mb-3">
                <div class="d-inline-flex align-items-center justify-content-center bg-warning text-white rounded-circle" style="width: 50px; height: 50px;">
                  <i class="bi bi-pencil"></i>
                </div>
              </div>
              <h6>Brouillons</h6>
              <div class="performance-meter mb-2">
                <div class="performance-fill" style="width: ${totalArticles > 0 ? (draftCount * 100 / totalArticles) : 0}%"></div>
              </div>
              <small class="text-muted">${draftCount} / ${totalArticles}</small>
            </div>

            <div class="col-md-4 text-center">
              <div class="mb-3">
                <div class="d-inline-flex align-items-center justify-content-center bg-secondary text-white rounded-circle" style="width: 50px; height: 50px;">
                  <i class="bi bi-archive"></i>
                </div>
              </div>
              <h6>Archives</h6>
              <div class="performance-meter mb-2">
                <div class="performance-fill" style="width: ${totalArticles > 0 ? (archivedCount * 100 / totalArticles) : 0}%"></div>
              </div>
              <small class="text-muted">${archivedCount} / ${totalArticles}</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Activité récente -->
    <div class="col-lg-4 mb-4">
      <div class="card shadow-sm animate-card">
        <div class="card-header bg-transparent">
          <h5 class="card-title mb-0">
            <i class="bi bi-clock me-2"></i>Activité Récente
          </h5>
        </div>
        <div class="card-body">
          <c:if test="${not empty recentArticles}">
            <c:forEach items="${recentArticles}" var="article" varStatus="status">
              <div class="activity-item">
                <div class="d-flex justify-content-between align-items-start">
                  <div class="flex-grow-1">
                    <h6 class="mb-1">
                      <c:out value="${article.titre}" />
                    </h6>
                    <small class="text-muted">
                      <i class="bi bi-calendar me-1"></i>
                      ${formattedDates[article.id]}
                    </small>
                  </div>
                  <span class="badge ${article.statut == 'publie' ? 'bg-success' : (article.statut == 'brouillon' ? 'bg-warning' : 'bg-secondary')}">
                    ${article.statut}
                  </span>
                </div>
              </div>
            </c:forEach>
          </c:if>

          <c:if test="${empty recentArticles}">
            <div class="text-center py-4 text-muted">
              <i class="bi bi-inbox display-4 mb-3"></i>
              <p>Aucun article récent</p>
            </div>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- Article le plus populaire -->
  <c:if test="${not empty mostViewedArticle && mostViewedArticle.vues > 0}">
    <div class="row mb-4">
      <div class="col-12">
        <div class="card shadow-sm animate-card">
          <div class="card-header bg-transparent">
            <h5 class="card-title mb-0">
              <i class="bi bi-trophy me-2"></i>Article le plus populaire
            </h5>
          </div>
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-md-8">
                <h6 class="mb-2">
                  <a href="/article/${mostViewedArticle.slug}" target="_blank" class="text-decoration-none">
                    <c:out value="${mostViewedArticle.titre}" />
                  </a>
                </h6>
                <p class="text-muted mb-2">
                  <c:out value="${mostViewedArticle.chapeau}" />
                </p>
                <small class="text-muted">
                  <c:if test="${mostViewedArticle.categorie != null}">
                    <i class="bi bi-folder me-1"></i>
                    <c:out value="${mostViewedArticle.categorie.nom}" />
                  </c:if>
                </small>
              </div>
              <div class="col-md-4 text-center">
                <div class="display-4 text-primary mb-2">
                  <i class="bi bi-eye-fill"></i>
                </div>
                <h3 class="text-primary">${mostViewedArticle.vues}</h3>
                <small class="text-muted">vues</small>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Actions rapides -->
  <div class="row mb-4">
    <div class="col-12">
      <div class="card shadow-sm animate-card">
        <div class="card-header bg-transparent">
          <h5 class="card-title mb-0">
            <i class="bi bi-lightning me-2"></i>Actions Rapides
          </h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-3 mb-3">
              <a href="/admin/articles/new" class="quick-action-btn text-center">
                <i class="bi bi-plus-lg d-block mb-2" style="font-size: 1.5rem;"></i>
                <strong>Nouvel Article</strong>
                <small class="d-block mt-1">Créer un article</small>
              </a>
            </div>
            <div class="col-md-3 mb-3">
              <a href="/admin/articles" class="quick-action-btn text-center" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <i class="bi bi-list-ul d-block mb-2" style="font-size: 1.5rem;"></i>
                <strong>Gérer Articles</strong>
                <small class="d-block mt-1">Modifier, supprimer</small>
              </a>
            </div>
            <div class="col-md-3 mb-3">
              <a href="/categories/new" class="quick-action-btn text-center" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                <i class="bi bi-folder-plus d-block mb-2" style="font-size: 1.5rem;"></i>
                <strong>Nouvelle Catégorie</strong>
                <small class="d-block mt-1">Organiser le contenu</small>
              </a>
            </div>
            <div class="col-md-3 mb-3">
              <a href="/" target="_blank" class="quick-action-btn text-center" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                <i class="bi bi-box-arrow-up-right d-block mb-2" style="font-size: 1.5rem;"></i>
                <strong>Voir le Site</strong>
                <small class="d-block mt-1">Interface publique</small>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Catégories existantes -->
  <div class="row">
    <div class="col-12">
      <div class="card shadow-sm animate-card">
        <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
          <h5 class="card-title mb-0">
            <i class="bi bi-folder me-2"></i>Catégories
            <span class="badge bg-primary">${totalCategories}</span>
          </h5>
          <a href="/categories" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-gear me-1"></i>Gérer
          </a>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-4 text-center">
              <div class="display-4 text-success mb-2">
                <i class="bi bi-folder-check"></i>
              </div>
              <h4 class="text-success">${totalCategories}</h4>
              <small class="text-muted">Catégories actives</small>
            </div>
            <div class="col-md-8">
              <p class="mb-2">Organisez votre contenu par thématiques :</p>
              <div class="d-flex justify-content-between">
                <small class="text-muted">
                  <i class="bi bi-info-circle me-1"></i>
                  Les catégories permettent une navigation structurée
                </small>
                <a href="/categories/new" class="small">
                  <i class="bi bi-plus me-1"></i>Ajouter
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Graphique en camembert pour les statuts d'articles
const ctx = document.getElementById('statusChart').getContext('2d');
const statusData = ${statusData};

new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: ['Publiés', 'Brouillons', 'Archivés'],
        datasets: [{
            data: statusData,
            backgroundColor: [
                '#28a745', // Vert pour publiés
                '#ffc107', // Jaune pour brouillons
                '#6c757d'  // Gris pour archivés
            ],
            borderWidth: 3,
            borderColor: '#fff'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom',
                labels: {
                    padding: 20,
                    usePointStyle: true
                }
            }
        },
        cutout: '60%',
        animation: {
            animateScale: true,
            animateRotate: true,
            duration: 1500
        }
    }
});

// Animation des cartes au scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observer toutes les cartes animées
document.querySelectorAll('.animate-card').forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(30px)';
    observer.observe(card);
});

// Animation des barres de progression
setTimeout(() => {
    document.querySelectorAll('.performance-fill').forEach(bar => {
        const width = bar.style.width;
        bar.style.width = '0%';
        setTimeout(() => {
            bar.style.width = width;
        }, 300);
    });
}, 1000);
</script>
</body>
</html>