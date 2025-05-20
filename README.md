# Sağlık Yönetim Sistemi

Bu proje, kullanıcıların semptomlarını girerek olası hastalıkları tahmin eden bir sağlık uygulamasıdır. Flutter ön yüz ve Flask backend kullanılarak geliştirilmiştir.

## Özellikler

- Semptom tarama ve hastalık tahmini
- Sohbet benzeri arayüz
- Makine öğrenimi tabanlı hastalık tahmini (773 farklı hastalık sınıfı)
- Web ve mobil platformlarda çalışma

## Veri Seti Hakkında

Projede kullanılan "Disease and symptoms dataset.csv" veri seti, GitHub boyut sınırlamaları nedeniyle repository'ye dahil edilmemiştir. Bu veri setini edinmek için:

1. [Bu linkten](https://www.kaggle.com/datasets/itachi9604/disease-symptom-description-dataset) veri setini indirebilirsiniz
2. İndirdiğiniz "Disease and symptoms dataset.csv" dosyasını projenin "Datasets" klasörüne yerleştirin

## Kurulum

### Backend (Flask)

1. Backend klasörüne gidin:
```
cd backend
```

2. Gerekli paketleri yükleyin:
```
pip install -r requirements.txt
```

3. Flask uygulamasını başlatın:
```
python app.py
```

### Frontend (Flutter)

1. Gerekli paketleri yükleyin:
```
flutter pub get
```

2. Uygulamayı çalıştırın:
```
flutter run -d chrome
```

## API Endpointleri

- `/` - API bilgisi
- `/hastalik-tahmini` - POST isteği ile semptom analizi
- `/train-model` - Modeli yeniden eğitme

## Geliştirme

Projeye katkıda bulunmak için lütfen önce bir issue açın.
