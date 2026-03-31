@echo off
setlocal EnableExtensions EnableDelayedExpansion

cd /d "%~dp0"

set "DB_NAME=mini_projet_s6"
set "DB_USER=postgres"
set "DB_PASSWORD=admin"

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

echo [1/6] Build + demarrage des services Docker...
docker compose up -d --build
if errorlevel 1 exit /b 1

set "DB_CID="
for /f "usebackq delims=" %%i in (`docker compose ps -q db`) do set "DB_CID=%%i"
if "%DB_CID%"=="" (
  echo [ERROR] Impossible de trouver le conteneur DB.
  exit /b 1
)

echo [2/6] Attente de PostgreSQL ^(healthcheck^)...
set "DB_HEALTH=unknown"
for /L %%n in (1,1,60) do (
  for /f "usebackq delims=" %%h in (`docker inspect --format="{{if .State.Health}}{{.State.Health.Status}}{{else}}unknown{{end}}" %DB_CID%`) do set "DB_HEALTH=%%h"
  if /I "!DB_HEALTH!"=="healthy" goto :db_ready
  timeout /t 2 /nobreak >nul
)

if /I not "%DB_HEALTH%"=="healthy" (
  echo [ERROR] PostgreSQL n'est pas devenu healthy a temps.
  docker compose logs --tail=80 db
  exit /b 1
)

:db_ready
echo [3/6] Alignement du mot de passe reseau PostgreSQL...
docker compose exec -T db sh -lc "psql -U postgres -d postgres -v ON_ERROR_STOP=1 -c \"ALTER ROLE postgres WITH PASSWORD '%DB_PASSWORD%';\"" >nul
if errorlevel 1 exit /b 1

set "SCHEMA_EXISTS="
for /f "usebackq delims=" %%s in (`docker compose exec -T db sh -lc "psql -U %DB_USER% -d %DB_NAME% -tAc \"SELECT to_regclass('public.articles') IS NOT NULL;\""`) do set "SCHEMA_EXISTS=%%s"

echo [4/6] Initialisation base de donnees si necessaire...
if /I not "%SCHEMA_EXISTS%"=="t" (
  docker compose exec -T db sh -lc "psql -U %DB_USER% -d %DB_NAME% -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/01-base.sql"
  if errorlevel 1 exit /b 1
  docker compose exec -T db sh -lc "psql -U %DB_USER% -d %DB_NAME% -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/02-init-data.sql"
  if errorlevel 1 exit /b 1
) else (
  echo Schema deja present, initialisation completee precedemment.
)

echo [5/6] Application des migrations SQL...
for %%f in ("bd\migration_*.sql") do (
  echo  - %%~nxf
  type "%%f" | docker compose exec -T db sh -lc "psql -U %DB_USER% -d %DB_NAME% -v ON_ERROR_STOP=1"
  if errorlevel 1 exit /b 1
)

echo [6/6] Verification finale...
set "APP_STATUS="
for /f "usebackq delims=" %%c in (`curl -s -o NUL -w "%%{http_code}" http://localhost:8000`) do set "APP_STATUS=%%c"
if not "%APP_STATUS%"=="200" (
  echo [WARN] L'application ne repond pas en HTTP 200 ^(code: %APP_STATUS%^).
  docker compose logs --tail=80 web
  exit /b 1
)

echo.
echo Projet pret.
echo - Application: http://localhost:8000
echo - Adminer: http://localhost:8081
echo - DB: %DB_NAME% ^(user: %DB_USER%^)

exit /b 0
