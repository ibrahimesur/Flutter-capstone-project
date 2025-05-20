@echo off
echo Flutter Web uygulamasi baslatiliyor...
cd %~dp0
flutter run -d chrome --web-renderer=canvaskit --web-hostname=localhost --web-port=8080
pause 