@echo off
setlocal EnableExtensions

cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Docker n'est pas installe ou introuvable dans le PATH.
  exit /b 1
)

docker compose version >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Docker Compose v2 est requis ^(commande: docker compose^).
  exit /b 1
)

if /I not "%~1"=="--yes" (
  set /p answer=Cette operation va supprimer les volumes Docker du projet ^(base de donnees comprise^). Continuer ? ^(oui/non^): 
  if /I not "%answer%"=="oui" if /I not "%answer%"=="o" if /I not "%answer%"=="yes" if /I not "%answer%"=="y" (
    echo Operation annulee.
    exit /b 0
  )
)

echo [1/2] Suppression des conteneurs + volumes du projet...
docker compose down -v --remove-orphans
if errorlevel 1 exit /b 1

echo [2/2] Reinitialisation complete via start.bat...
call "%~dp0start.bat"
exit /b %errorlevel%
