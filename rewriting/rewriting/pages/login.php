<?php
$pageTitle = 'Connexion - Iran War News';

$error = '';

// Traiter le login
if ($_POST && isset($_POST['username'], $_POST['password'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    $user = fetchOne('SELECT id, username, password_hash, role FROM users WHERE username = ? AND actif = true', [$username]);
    
    if ($user && password_verify($password, $user['password_hash'])) {
        // Login réussi
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['user_role'] = $user['role'];
        
        setFlash('success', 'Bienvenue ' . e($user['username']));
        redirect('/admin');
    } else {
        $error = 'Identifiants invalides';
    }
}

// Si déjà connecté, rediriger vers admin
if (isLogged()) {
    redirect('/admin');
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle; ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-blue-600 to-blue-900">
    <div class="min-h-screen flex items-center justify-center px-4">
        <div class="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
            <!-- Logo -->
            <div class="text-center mb-8">
                <div class="inline-flex h-14 w-14 items-center justify-center rounded-lg bg-blue-600 text-white text-xl font-bold mb-4">
                    I
                </div>
                <h1 class="text-3xl font-serif font-bold text-gray-900">Iran War News</h1>
                <p class="text-gray-500 text-sm mt-2">Connexion à l'espace d'administration</p>
            </div>

            <?php if ($error): ?>
            <div class="p-4 mb-6 bg-red-50 text-red-800 rounded-lg border border-red-200 text-sm font-semibold">
                ⚠️ <?php echo e($error); ?>
            </div>
            <?php endif; ?>

            <form method="POST" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-gray-900 mb-2">Utilisateur</label>
                    <input 
                        type="text" 
                        name="username" 
                        placeholder="Entrez votre identifiant" 
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        required
                        autofocus
                    >
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-900 mb-2">Mot de passe</label>
                    <input 
                        type="password" 
                        name="password" 
                        placeholder="Entrez votre mot de passe" 
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        required
                    >
                </div>

                <button type="submit" class="w-full py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold text-lg">
                    Se connecter
                </button>
            </form>

            <div class="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200 text-center text-sm text-gray-700">
                <p><strong>Identifiant:</strong> admin</p>
                <p><strong>Mot de passe:</strong> test123</p>
            </div>
        </div>
    </div>
</body>
</html>
