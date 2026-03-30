<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.front.PlainFrontCategory" %>
<%
  String pageTitle = (String) request.getAttribute("pageTitle");
  String metaDescription = (String) request.getAttribute("metaDescription");
  String metaKeywords = (String) request.getAttribute("metaKeywords");
  String metaRobots = (String) request.getAttribute("metaRobots");
  List<PlainFrontCategory> navCategories = (List<PlainFrontCategory>) request.getAttribute("navCategories");

  String safePageTitle = pageTitle == null || pageTitle.isBlank() ? "Iran War News" : pageTitle;
  String safeRobots = metaRobots == null || metaRobots.isBlank() ? "index, follow" : metaRobots;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><%= safePageTitle %> - Iran War News</title>
  <% if (metaDescription != null && !metaDescription.isBlank()) { %>
  <meta name="description" content="<%= metaDescription %>" />
  <% } %>
  <% if (metaKeywords != null && !metaKeywords.isBlank()) { %>
  <meta name="keywords" content="<%= metaKeywords %>" />
  <% } %>
  <meta name="robots" content="<%= safeRobots %>" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700;800&family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            ink: '#111111',
            paper: '#fafaf9',
            stone: '#e7e5e4',
            accent: '#4a5568'
          },
          fontFamily: {
            sans: ['Source Sans 3', 'ui-sans-serif', 'sans-serif'],
            serif: ['Playfair Display', 'ui-serif', 'serif']
          },
          boxShadow: {
            editorial: '0 12px 32px rgba(0, 0, 0, 0.08)'
          }
        }
      }
    };
  </script>
  <style>
    .article-content h2,
    .article-content h3,
    .article-content h4 {
      font-family: 'Playfair Display', ui-serif, serif;
      margin-top: 1.6rem;
      margin-bottom: 0.8rem;
      line-height: 1.25;
      color: #111111;
    }

    .article-content p {
      margin-top: 0.9rem;
      margin-bottom: 0.9rem;
    }

    .article-content a {
      text-decoration: underline;
      text-underline-offset: 3px;
      color: #1f2937;
      transition: color 0.2s ease;
    }

    .article-content a:hover {
      color: #111111;
    }
  </style>
</head>
<body class="bg-paper text-ink font-sans antialiased">

<header class="border-b border-stone bg-white/95 backdrop-blur-sm sticky top-0 z-50">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
    <div class="flex flex-col gap-3 lg:gap-4">
      <div class="flex items-end justify-between gap-4">
        <a href="/noframework/home" class="group inline-flex flex-col leading-none">
          <span class="text-[11px] uppercase tracking-[0.2em] text-gray-500">Edition Internationale</span>
          <span class="font-serif text-3xl sm:text-4xl font-bold tracking-tight group-hover:text-accent transition-colors">Iran War News</span>
        </a>
        <a href="/noframework/admin/dashboard" class="text-sm font-semibold uppercase tracking-widest text-gray-600 hover:text-ink transition-colors">Administration</a>
      </div>

      <div class="h-px bg-gradient-to-r from-transparent via-stone to-transparent"></div>

      <nav class="flex flex-wrap items-center gap-x-4 gap-y-2 text-[13px] sm:text-sm">
        <a href="/noframework/home" class="font-semibold text-ink hover:text-accent transition-colors">Accueil</a>
        <span class="text-gray-300">|</span>
        <% if (navCategories != null && !navCategories.isEmpty()) {
             for (int i = 0; i < navCategories.size(); i++) {
               PlainFrontCategory cat = navCategories.get(i);
        %>
          <a href="/noframework/home?categorySlugs=<%= cat.getSlug() %>" class="text-gray-600 hover:text-ink transition-colors"><%= cat.getNom() %></a>
          <% if (i < navCategories.size() - 1) { %>
            <span class="text-gray-300">|</span>
          <% } %>
        <%   }
           } else { %>
          <span class="text-gray-500">Aucune categorie disponible</span>
        <% } %>
      </nav>
    </div>
  </div>
</header>
