#!/usr/bin/env pwsh
# Script de préparation du serveur local Django

Write-Host "🔧 PRÉPARATION DU SERVEUR DJANGO LOCAL" -ForegroundColor Cyan
Write-Host "=" * 70
Write-Host ""

# Vérifier si on est dans le bon répertoire
$backendPath = "H:\Coding\Flutter\alert-app-backend\Alert-app"

if (-not (Test-Path $backendPath)) {
    Write-Host "❌ Erreur: Répertoire backend non trouvé: $backendPath" -ForegroundColor Red
    Write-Host "   Assure-toi que le backend Django est cloné dans H:\Coding\Flutter\" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Backend trouvé: $backendPath" -ForegroundColor Green
Write-Host ""

# Aller au répertoire backend
Push-Location $backendPath

try {
    # Étape 1: Vérifier que python est installé
    Write-Host "1️⃣  Vérification de Python..." -ForegroundColor Cyan
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Python: $pythonVersion" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Python n'est pas installé ou non disponible" -ForegroundColor Red
        exit 1
    }

    # Étape 2: Vérifier les dépendances
    Write-Host ""
    Write-Host "2️⃣  Installation des dépendances (si nécessaire)..." -ForegroundColor Cyan
    if (Test-Path "requirements.txt") {
        Write-Host "   Exécution: pip install -r requirements.txt" -ForegroundColor Yellow
        pip install -r requirements.txt
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Dépendances installées" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  requirements.txt non trouvé" -ForegroundColor Yellow
    }

    # Étape 3: Appliquer les migrations
    Write-Host ""
    Write-Host "3️⃣  Application des migrations..." -ForegroundColor Cyan
    Write-Host "   Exécution: python manage.py migrate" -ForegroundColor Yellow
    python manage.py migrate
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Migrations appliquées" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Erreur lors de l'application des migrations" -ForegroundColor Yellow
    }

    # Étape 4: Créer un superuser (optionnel)
    Write-Host ""
    Write-Host "4️⃣  Vérification du superuser..." -ForegroundColor Cyan
    Write-Host "   Suggestion: Créer un superuser pour accéder à /admin/" -ForegroundColor Yellow
    Write-Host "   Commande: python manage.py createsuperuser" -ForegroundColor Cyan

    # Étape 5: Lancer le serveur
    Write-Host ""
    Write-Host "5️⃣  Lancement du serveur Django..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   🚀 Serveur disponible à:" -ForegroundColor Green
    Write-Host "      http://127.0.0.1:8000/" -ForegroundColor Cyan
    Write-Host "      API: http://127.0.0.1:8000/api/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Appuie sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=" * 70
    Write-Host ""
    
    python manage.py runserver

} finally {
    Pop-Location
}
