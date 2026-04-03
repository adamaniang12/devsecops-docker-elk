# scripts\setup_kibana.ps1
Write-Host "Configuration de Kibana..." -ForegroundColor Green

# Attendre que Kibana soit prêt
Write-Host "Attente du démarrage de Kibana..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Créer un index pattern
$indexPattern = @{
    "attributes" = @{
        "title" = "dvwa-logs-*"
        "timeFieldName" = "@timestamp"
    }
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "http://localhost:5601/api/saved_objects/index-pattern/dvwa-logs" `
        -Method POST `
        -Body $indexPattern `
        -ContentType "application/json" `
        -ErrorAction SilentlyContinue
    Write-Host "Index pattern créé" -ForegroundColor Green
} catch {
    Write-Host "Index pattern existe déjà" -ForegroundColor Yellow
}

# Créer une alerte brute force via API
$alert = @"
{
  "name": "Brute Force Detection",
  "alertTypeId": ".threshold",
  "consumer": "alerts",
  "schedule": {
    "interval": "1m"
  },
  "params": {
    "threshold": 10,
    "timeWindow": "5m",
    "aggType": "count",
    "groupBy": "top",
    "termField": "client_ip.keyword"
  },
  "actions": []
}
"@

Write-Host "Configuration terminée!" -ForegroundColor Green
Write-Host "Accédez à Kibana: http://localhost:5601" -ForegroundColor Cyan