<?php
/**
 * Routeur simple pour gerer les URLs
 */
class Router
{
    private array $routes = [];
    private array $middlewares = [];

    public function get(string $path, array $handler, array $middlewares = []): self
    {
        $this->addRoute('GET', $path, $handler, $middlewares);
        return $this;
    }

    public function post(string $path, array $handler, array $middlewares = []): self
    {
        $this->addRoute('POST', $path, $handler, $middlewares);
        return $this;
    }

    private function addRoute(string $method, string $path, array $handler, array $middlewares): void
    {
        // Convertir les parametres de route {param} en regex
        $pattern = preg_replace('/\{([a-zA-Z_]+)\}/', '(?P<$1>[^/]+)', $path);
        $pattern = '#^' . $pattern . '$#';

        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'pattern' => $pattern,
            'controller' => $handler[0],
            'action' => $handler[1],
            'middlewares' => $middlewares
        ];
    }

    public function dispatch(): void
    {
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = $this->getUri();

        foreach ($this->routes as $route) {
            if ($route['method'] !== $method) {
                continue;
            }

            if (preg_match($route['pattern'], $uri, $matches)) {
                // Executer les middlewares
                foreach ($route['middlewares'] as $middleware) {
                    $this->executeMiddleware($middleware);
                }

                // Extraire les parametres
                $params = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

                // Creer le controleur et executer l'action
                $controllerName = $route['controller'];
                $action = $route['action'];

                if (!class_exists($controllerName)) {
                    $this->notFound();
                    return;
                }

                $controller = new $controllerName();

                if (!method_exists($controller, $action)) {
                    $this->notFound();
                    return;
                }

                call_user_func_array([$controller, $action], $params);
                return;
            }
        }

        $this->notFound();
    }

    private function getUri(): string
    {
        $uri = $_SERVER['REQUEST_URI'] ?? '/';

        // Retirer le prefixe BASE_URL
        $baseUrl = BASE_URL;
        if (strpos($uri, $baseUrl) === 0) {
            $uri = substr($uri, strlen($baseUrl));
        }

        // Retirer la query string
        if (($pos = strpos($uri, '?')) !== false) {
            $uri = substr($uri, 0, $pos);
        }

        // S'assurer que l'URI commence par /
        $uri = '/' . ltrim($uri, '/');

        // Retirer le slash final sauf pour /
        if ($uri !== '/') {
            $uri = rtrim($uri, '/');
        }

        return $uri;
    }

    private function executeMiddleware(string $middleware): void
    {
        switch ($middleware) {
            case 'auth':
                if (!Auth::check()) {
                    header('Location: ' . url('login'));
                    exit;
                }
                break;
            case 'guest':
                if (Auth::check()) {
                    header('Location: ' . url('admin'));
                    exit;
                }
                break;
        }
    }

    private function notFound(): void
    {
        http_response_code(404);
        require_once __DIR__ . '/../views/errors/404.php';
        exit;
    }
}
