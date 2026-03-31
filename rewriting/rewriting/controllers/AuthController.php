<?php
/**
 * Controleur pour l'authentification
 */
class AuthController extends Controller
{
    public function showLogin(): void
    {
        $errorMessage = null;
        $successMessage = null;

        if (isset($_GET['error'])) {
            $errorMessage = 'Identifiants incorrects.';
        }

        if (isset($_GET['logout'])) {
            $successMessage = 'Vous etes deconnecte.';
        }

        $this->view('auth/login', [
            'errorMessage' => $errorMessage,
            'successMessage' => $successMessage
        ]);
    }

    public function login(): void
    {
        $username = $this->input('username', '');
        $password = $this->input('password', '');

        if (Auth::attempt($username, $password)) {
            $this->redirect('admin');
        } else {
            $this->redirect('login?error=1');
        }
    }

    public function logout(): void
    {
        Auth::logout();
        $this->redirect('?logout=true');
    }
}
