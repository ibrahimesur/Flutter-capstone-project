# Hastalık-Semptom API

Bu API, semptomlar verildiğinde olası hastalıkları tahmin eden bir servistir.

## Kurulum

1. Python 3.8 veya üzeri sürümün kurulu olması gereklidir.

2. Gerekli paketleri yükleyin:
```
pip install -r requirements.txt
```

3. API'yi başlatın:
```
python app.py
```

Servis varsayılan olarak 8000 portunda çalışır (http://localhost:8000).

## API Kullanımı

### Hastalık Tahmini

**Endpoint:** `/hastalik-tahmini`

**Method:** `POST`

**Request Body:**
```json
{
  "semptomlar": ["Ateş", "Öksürük", "Baş ağrısı"]
}
```

**Response:**
```json
{
  "hastalikAdi": "Üst Solunum Yolu Enfeksiyonu",
  "olasilik": 0.75,
  "eslesen_semptom_sayisi": 3,
  "toplam_semptom_sayisi": 5,
  "oneriler": "Bol sıvı tüketin, istirahat edin ve gerekirse ateş düşürücü alın."
}
```

## Not

Bu API'nin tahminleri sadece ön değerlendirme amaçlıdır ve kesin tanı yerine geçmez. Sağlık sorunları için daima bir doktora başvurunuz. 