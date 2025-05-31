CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tc_kimlik_no VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('patient', 'doctor', 'hospital_admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- Doktorlar Tablosu
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY, -- Otomatik artan benzersiz kimlik
    institutional_id VARCHAR(255) UNIQUE NOT NULL, -- Kurumsal Doktor ID (Benzersiz)
    name VARCHAR(255) NOT NULL, -- Ad Soyad
    email VARCHAR(255) UNIQUE NOT NULL, -- E-posta (Benzersiz)
    password_hash VARCHAR(255) NOT NULL, -- Şifre (Hashlenmiş veya güvenli bir şekilde saklanmalı)
    department VARCHAR(255), -- Bölüm (isteğe bağlı)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Kayıt tarihi
);


-- Hastane Yönetimi Tablosu
CREATE TABLE hospital_admins (
    admin_id SERIAL PRIMARY KEY, -- Otomatik artan benzersiz kimlik
    institutional_id VARCHAR(255) UNIQUE NOT NULL, -- Kurumsal Hastane ID (Benzersiz)
    hospital_name VARCHAR(255), -- Bağlı olduğu hastane adı (isteğe bağlı)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Kayıt tarihi
     name VARCHAR(255) NOT NULL, -- Ad Soyad
    email VARCHAR(255) UNIQUE NOT NULL, -- E-posta (Benzersiz)
    password VARCHAR(255) NOT NULL, -- Şifre (Hashlenmiş veya güvenli bir şekilde saklanmalı)
);

CREATE TABLE randevular (
    id SERIAL PRIMARY KEY,
    hasta_id INTEGER REFERENCES users(id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    randevu_tarihi DATE NOT NULL,
    randevu_saati TIME NOT NULL,
    notlar TEXT,
    doktor_notlari TEXT,
    durum VARCHAR(20) DEFAULT 'beklemede' CHECK (durum IN ('beklemede', 'tamamlandı', 'iptal')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE saglik_profili (
    hasta_id INT PRIMARY KEY,
    ad_soyad VARCHAR(255),
    yas INT,
    boy INT,
    kilo DECIMAL(5, 2),
    kan_grubu VARCHAR(5),
    kronik_hastaliklar TEXT,
    alerjiler TEXT,
    FOREIGN KEY (hasta_id) REFERENCES users(id) 
); 

CREATE TABLE doktor_takvimleri (
    takvim_id VARCHAR(255) PRIMARY KEY,
    doctor_id INTEGER NOT NULL,
    tarih DATE NOT NULL,
    saat TIME NOT NULL,
    durum VARCHAR(20) DEFAULT 'müsait',
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    UNIQUE (doctor_id, tarih, saat)
);

