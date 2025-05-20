#!/bin/bash

echo "Flutter ve Flask backend'i baslatiliyor..."

# Proje dizinini belirle
PROJECT_DIR=$(dirname "$0")

# Backend servisini başlat (arka planda)
osascript -e "tell application \"Terminal\" to do script \"cd $PROJECT_DIR/backend && python app.py\""

# 3 saniye bekle
sleep 3

# Flutter uygulamasını başlat
osascript -e "tell application \"Terminal\" to do script \"cd $PROJECT_DIR && flutter run -d chrome\""

echo "Uygulama baslatildi! Backend: http://127.0.0.1:8000/" 