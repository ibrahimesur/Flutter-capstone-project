#!/bin/bash

echo "Flutter ve Flask backend'i baslatiliyor..."

# Proje dizinini belirle
PROJECT_DIR=$(dirname "$0")

# xterm yüklü mü kontrol et, yoksa yükle
if ! command -v xterm &> /dev/null; then
    echo "xterm yüklü değil, yükleniyor..."
    sudo apt-get update && sudo apt-get install -y xterm
fi

# Backend servisini başlat (arka planda)
xterm -title "Flask Backend" -e "cd $PROJECT_DIR/backend && python app.py; bash" &

# 3 saniye bekle
sleep 3

# Flutter uygulamasını başlat
xterm -title "Flutter App" -e "cd $PROJECT_DIR && flutter run -d chrome; bash" &

echo "Uygulama baslatildi! Backend: http://127.0.0.1:8000/" 