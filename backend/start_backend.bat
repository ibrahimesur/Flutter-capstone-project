@echo off
echo Flask API baslatiliyor...
cd %~dp0

echo Gereken paketler yukleniyor...
pip install -r requirements.txt

echo Model egitiliyor ve API baslatiliyor...
python app.py
pause 