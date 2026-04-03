# scripts\test_elk_alerts.ps1
Write-Host "=== TEST DES ALERTES ELK ===" -ForegroundColor Green

# Simuler des tentatives de brute force
Write-Host "Simulation d'attaque Brute Force..." -ForegroundColor Yellow

for ($i=1; $i -le 15; $i++) {
    $randomIP = "192.168.1." + (Get-Random -Minimum 10 -Maximum 200)
    
    # Envoyer un log personnalisé à Logstash
    $logEntry = @{
        timestamp = (Get-Date -Format "dd/MMM/yyyy:HH:mm:ss")
        client_ip = $randomIP
        request = "POST /login.php HTTP/1.1"
        response = 401
        message = "Login failed for user admin from $randomIP"
        tags = @("failed_auth")
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "http://localhost:5000" `
            -Method POST `
            -Body $logEntry `
            -ContentType "application/json" `
            -ErrorAction SilentlyContinue
        Write-Host "[$i/15] Tentative depuis $randomIP" -ForegroundColor Cyan
    } catch {
        Write-Host "Erreur d'envoi" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}

# Simuler une injection SQL
Write-Host "`nSimulation d'injection SQL..." -ForegroundColor Yellow
$sqlLog = @{
    timestamp = (Get-Date -Format "dd/MMM/yyyy:HH:mm:ss")
    client_ip = "10.0.0.50"
    request = "GET /vulnerabilities/sqli/?id=1' OR '1'='1 HTTP/1.1"
    response = 200
    message = "SQL injection attempt detected"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000" -Method POST -Body $sqlLog -ContentType "application/json"

Write-Host "`n=== TEST TERMINE ===" -ForegroundColor Green
Write-Host "Vérifiez Kibana pour voir les alertes:" -ForegroundColor Yellow
Write-Host "http://localhost:5601" -ForegroundColor Cyan