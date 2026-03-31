<?php
/**
 * Classe de base pour les controleurs
 */
abstract class Controller
{
    protected array $data = [];

    protected function view(string $template, array $data = []): void
    {
        // Fusionner les donnees
        $this->data = array_merge($this->data, $data);

        // Extraire les variables pour la vue
        extract($this->data);

        // Charger les categories pour la navigation
        $navCategories = Category::all();

        // Inclure le template
        $viewPath = __DIR__ . '/../views/' . $template . '.php';

        if (!file_exists($viewPath)) {
            throw new Exception("Vue non trouvee: $template");
        }

        require $viewPath;
    }

    protected function redirect(string $path): void
    {
        header('Location: ' . url($path));
        exit;
    }

    protected function json(array $data, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    protected function input(string $key, $default = null)
    {
        return $_POST[$key] ?? $_GET[$key] ?? $default;
    }

    protected function inputAll(): array
    {
        return array_merge($_GET, $_POST);
    }
}
