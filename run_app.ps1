# Flutter ve Flask backend'i aynı anda çalıştıran PowerShell script

# Çalışma dizinini proje klasörüne ayarla
$projectDir = $PSScriptRoot

# İlk olarak Flask backend'i başlat (yeni bir pencerede)
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectDir\backend'; python app.py"

# 3 saniye bekle - backend'in başlaması için
Start-Sleep -Seconds 3

# Sonra Flutter uygulamasını başlat
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectDir'; flutter run -d chrome"

Write-Host "Uygulama başlatılıyor... Backend: http://127.0.0.1:8000/" -ForegroundColor Green 