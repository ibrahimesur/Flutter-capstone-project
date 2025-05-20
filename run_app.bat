@echo off
echo Flutter ve Flask backend'i baslatiliyor...

rem Flask API'yi başlat (yeni bir CMD penceresinde)
start cmd /k "cd %~dp0backend && python app.py"

rem 3 saniye bekle
timeout /t 3 /nobreak > nul

rem Flutter uygulamasını başlat
start cmd /k "cd %~dp0 && flutter run -d chrome"

echo Uygulama baslatildi! Backend: http://127.0.0.1:8000/ 