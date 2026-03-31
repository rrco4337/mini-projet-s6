<?php
/**
 * Controleur pour la gestion des articles (admin)
 */
class ArticleAdminController extends Controller
{
    public function index(): void
    {
        $articles = Article::getByStatut('publie');
        $articles = array_map(function($article) {
            $article['categories'] = Article::getCategories($article['id']);
            return $article;
        }, $articles);

        $this->view('admin/articles/list', [
            'articles' => $articles,
            'successMessage' => getFlash('success'),
            'errorMessage' => getFlash('error')
        ]);
    }

    public function drafts(): void
    {
        $articles = Article::getByStatut('brouillon');
        $articles = array_map(function($article) {
            $article['categories'] = Article::getCategories($article['id']);
            return $article;
        }, $articles);

        $this->view('admin/articles/drafts', [
            'articles' => $articles,
            'successMessage' => getFlash('success'),
            'errorMessage' => getFlash('error')
        ]);
    }

    public function archives(): void
    {
        $articles = Article::getByStatut('archive');
        $articles = array_map(function($article) {
            $article['categories'] = Article::getCategories($article['id']);
            return $article;
        }, $articles);

        $this->view('admin/articles/archives', [
            'articles' => $articles,
            'successMessage' => getFlash('success'),
            'errorMessage' => getFlash('error')
        ]);
    }

    public function create(): void
    {
        $this->view('admin/articles/form', [
            'mode' => 'create',
            'articleForm' => [],
            'categories' => Category::all(),
            'statuts' => ['brouillon', 'publie', 'archive'],
            'errors' => []
        ]);
    }

    public function store(): void
    {
        $data = $this->inputAll();
        $errors = $this->validate($data);

        if (!empty($errors)) {
            $this->view('admin/articles/form', [
                'mode' => 'create',
                'articleForm' => $data,
                'categories' => Category::all(),
                'statuts' => ['brouillon', 'publie', 'archive'],
                'errors' => $errors
            ]);
            return;
        }

        // Gerer l'upload d'images
        $imageUne = null;
        if (!empty($_FILES['images']['name'][0])) {
            $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
            $alt = trim($alts[0] ?? '');
            $imageUne = Media::upload($_FILES['images'], $alt);
        }

        $articleData = [
            'titre' => trim($data['titre']),
            'slug' => trim($data['slug']),
            'sous_titre' => trim($data['sousTitre'] ?? ''),
            'chapeau' => trim($data['chapeau'] ?? ''),
            'contenu' => $data['contenu'],
            'meta_title' => trim($data['metaTitle'] ?? ''),
            'meta_description' => trim($data['metaDescription'] ?? ''),
            'meta_keywords' => trim($data['metaKeywords'] ?? ''),
            'statut' => $data['statut'] ?? 'brouillon',
            'a_la_une' => isset($data['ALaUne']) ? true : false,
            'image_une' => $imageUne,
            'vues' => 0,
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ];

        if ($data['statut'] === 'publie') {
            $articleData['date_publication'] = date('Y-m-d H:i:s');
        }

        $articleId = Article::create($articleData);

        // Synchroniser les categories
        if (!empty($data['categorieIds'])) {
            Article::syncCategories($articleId, $data['categorieIds']);
        }

        flash('success', 'Article cree avec succes.');
        $this->redirect('admin/articles');
    }

    public function edit(string $id): void
    {
        $article = Article::find((int) $id);

        if (!$article) {
            http_response_code(404);
            require_once __DIR__ . '/../views/errors/404.php';
            exit;
        }

        $selectedCategories = Article::getCategories($article['id']);
        $selectedCategoryIds = array_column($selectedCategories, 'id');

        $articleForm = [
            'titre' => $article['titre'],
            'slug' => $article['slug'],
            'sousTitre' => $article['sous_titre'],
            'chapeau' => $article['chapeau'],
            'contenu' => $article['contenu'],
            'metaTitle' => $article['meta_title'],
            'metaDescription' => $article['meta_description'],
            'metaKeywords' => $article['meta_keywords'],
            'statut' => $article['statut'],
            'ALaUne' => $article['a_la_une'],
            'categorieIds' => $selectedCategoryIds
        ];

        $this->view('admin/articles/form', [
            'mode' => 'edit',
            'articleId' => $id,
            'articleForm' => $articleForm,
            'categories' => Category::all(),
            'statuts' => ['brouillon', 'publie', 'archive'],
            'errors' => []
        ]);
    }

    public function update(string $id): void
    {
        $article = Article::find((int) $id);

        if (!$article) {
            http_response_code(404);
            require_once __DIR__ . '/../views/errors/404.php';
            exit;
        }

        $data = $this->inputAll();
        $errors = $this->validate($data, (int) $id);

        if (!empty($errors)) {
            $this->view('admin/articles/form', [
                'mode' => 'edit',
                'articleId' => $id,
                'articleForm' => $data,
                'categories' => Category::all(),
                'statuts' => ['brouillon', 'publie', 'archive'],
                'errors' => $errors
            ]);
            return;
        }

        // Gerer l'upload d'images
        $imageUne = $article['image_une'];
        if (!empty($_FILES['images']['name'][0])) {
            $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
            $alt = trim($alts[0] ?? '');
            $newImage = Media::upload($_FILES['images'], $alt);
            if ($newImage) {
                $imageUne = $newImage;
            }
        }

        $articleData = [
            'titre' => trim($data['titre']),
            'slug' => trim($data['slug']),
            'sous_titre' => trim($data['sousTitre'] ?? ''),
            'chapeau' => trim($data['chapeau'] ?? ''),
            'contenu' => $data['contenu'],
            'meta_title' => trim($data['metaTitle'] ?? ''),
            'meta_description' => trim($data['metaDescription'] ?? ''),
            'meta_keywords' => trim($data['metaKeywords'] ?? ''),
            'statut' => $data['statut'] ?? $article['statut'],
            'a_la_une' => isset($data['ALaUne']) ? true : false,
            'image_une' => $imageUne,
            'updated_at' => date('Y-m-d H:i:s')
        ];

        // Mettre a jour la date de publication si necessaire
        if ($data['statut'] === 'publie' && $article['statut'] !== 'publie') {
            $articleData['date_publication'] = date('Y-m-d H:i:s');
        }

        Article::update((int) $id, $articleData);

        // Synchroniser les categories
        Article::syncCategories((int) $id, $data['categorieIds'] ?? []);

        flash('success', 'Article mis a jour avec succes.');
        $this->redirect('admin/articles');
    }

    public function delete(string $id): void
    {
        $article = Article::find((int) $id);

        if (!$article) {
            flash('error', 'Article non trouve.');
            $this->redirect('admin/articles');
            return;
        }

        Article::delete((int) $id);
        flash('success', 'Article supprime avec succes.');
        $this->redirect('admin/articles');
    }

    public function archive(string $id): void
    {
        $article = Article::find((int) $id);

        if (!$article) {
            flash('error', 'Article non trouve.');
            $this->redirect('admin/articles');
            return;
        }

        Article::archive((int) $id);
        flash('success', 'Article archive avec succes.');
        $this->redirect('admin/articles');
    }

    public function restore(string $id): void
    {
        $article = Article::find((int) $id);

        if (!$article) {
            flash('error', 'Article non trouve.');
            $this->redirect('admin/articles/archives');
            return;
        }

        Article::restore((int) $id);
        flash('success', 'Article restaure avec succes.');
        $this->redirect('admin/articles/drafts');
    }

    private function validate(array $data, ?int $excludeId = null): array
    {
        $errors = [];

        if (empty(trim($data['titre'] ?? ''))) {
            $errors['titre'] = 'Le titre est obligatoire.';
        } elseif (strlen($data['titre']) > 255) {
            $errors['titre'] = 'Le titre ne doit pas depasser 255 caracteres.';
        }

        if (empty(trim($data['slug'] ?? ''))) {
            $errors['slug'] = 'Le slug est obligatoire.';
        } elseif (strlen($data['slug']) > 270) {
            $errors['slug'] = 'Le slug ne doit pas depasser 270 caracteres.';
        } elseif (!preg_match('/^[a-z0-9-]+$/', $data['slug'])) {
            $errors['slug'] = 'Le slug ne peut contenir que des lettres minuscules, chiffres et tirets.';
        } else {
            // Verifier l'unicite du slug
            $existing = Article::findBySlug($data['slug']);
            if ($existing && (!$excludeId || $existing['id'] != $excludeId)) {
                $errors['slug'] = 'Ce slug existe deja.';
            }
        }

        if (empty(trim($data['contenu'] ?? ''))) {
            $errors['contenu'] = 'Le contenu est obligatoire.';
        }

        return $errors;
    }
}
