<?php
/**
 * Controleur pour la gestion des categories
 */
class CategoryController extends Controller
{
    public function index(): void
    {
        $categories = Category::all();

        $this->view('categories/list', [
            'categories' => $categories,
            'successMessage' => getFlash('success'),
            'errorMessage' => getFlash('error')
        ]);
    }

    public function create(): void
    {
        $this->view('categories/form', [
            'mode' => 'create',
            'categoryForm' => [],
            'errors' => []
        ]);
    }

    public function store(): void
    {
        $data = $this->inputAll();
        $errors = Category::validate($data);

        if (!empty($errors)) {
            $this->view('categories/form', [
                'mode' => 'create',
                'categoryForm' => $data,
                'errors' => $errors
            ]);
            return;
        }

        Category::create([
            'nom' => trim($data['nom']),
            'slug' => trim($data['slug']),
            'description' => trim($data['description'] ?? ''),
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ]);

        flash('success', 'Categorie creee avec succes.');
        $this->redirect('categories');
    }

    public function edit(string $id): void
    {
        $category = Category::find((int) $id);

        if (!$category) {
            http_response_code(404);
            require_once __DIR__ . '/../views/errors/404.php';
            exit;
        }

        $this->view('categories/form', [
            'mode' => 'edit',
            'categoryId' => $id,
            'categoryForm' => $category,
            'errors' => []
        ]);
    }

    public function update(string $id): void
    {
        $category = Category::find((int) $id);

        if (!$category) {
            http_response_code(404);
            require_once __DIR__ . '/../views/errors/404.php';
            exit;
        }

        $data = $this->inputAll();
        $errors = Category::validate($data, (int) $id);

        if (!empty($errors)) {
            $this->view('categories/form', [
                'mode' => 'edit',
                'categoryId' => $id,
                'categoryForm' => $data,
                'errors' => $errors
            ]);
            return;
        }

        Category::update((int) $id, [
            'nom' => trim($data['nom']),
            'slug' => trim($data['slug']),
            'description' => trim($data['description'] ?? ''),
            'updated_at' => date('Y-m-d H:i:s')
        ]);

        flash('success', 'Categorie mise a jour avec succes.');
        $this->redirect('categories');
    }

    public function delete(string $id): void
    {
        $category = Category::find((int) $id);

        if (!$category) {
            flash('error', 'Categorie non trouvee.');
            $this->redirect('categories');
            return;
        }

        Category::delete((int) $id);
        flash('success', 'Categorie supprimee avec succes.');
        $this->redirect('categories');
    }
}
