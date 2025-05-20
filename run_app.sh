#!/bin/bash

echo "Flutter ve Flask backend'i baslatiliyor..."

# Proje dizinini belirle
PROJECT_DIR=$(dirname "$0")

# Backend servisini başlat (arka planda)
gnome-terminal --tab --title="Flask Backend" -- bash -c "cd $PROJECT_DIR/backend && python app.py; exec bash"

# 3 saniye bekle
sleep 3

# Flutter uygulamasını başlat
gnome-terminal --tab --title="Flutter App" -- bash -c "cd $PROJECT_DIR && flutter run -d chrome; exec bash"

echo "Uygulama baslatildi! Backend: http://127.0.0.1:8000/" 