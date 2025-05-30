CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tc_kimlik_no VARCHAR(11) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    institutional_id VARCHAR(255) UNIQUE, -- Doktor ve Hastane Yönetimi için
    user_type VARCHAR(50) NOT NULL DEFAULT 'patient', -- Kullanıcı tipi: patient, doctor, hospital_admin
    is_doctor BOOLEAN DEFAULT FALSE, -- Kullanılmayacaksa kaldırılabilir
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- Doktorlar Tablosu
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY, -- Otomatik artan benzersiz kimlik
    institutional_id VARCHAR(255) UNIQUE NOT NULL, -- Kurumsal Doktor ID (Benzersiz)
    name VARCHAR(255) NOT NULL, -- Ad Soyad
    email VARCHAR(255) UNIQUE NOT NULL, -- E-posta (Benzersiz)
    department VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL, -- Şifre (Hashlenmiş veya güvenli bir şekilde saklanmalı)
    department VARCHAR(255), -- Bölüm (isteğe bağlı)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Kayıt tarihi
);


-- Hastane Yönetimi Tablosu
CREATE TABLE hospital_admins (
    admin_id SERIAL PRIMARY KEY, -- Otomatik artan benzersiz kimlik
    institutional_id VARCHAR(255) UNIQUE NOT NULL, -- Kurumsal Hastane ID (Benzersiz)
    name VARCHAR(255) NOT NULL, -- Ad Soyad
    email VARCHAR(255) UNIQUE NOT NULL, -- E-posta (Benzersiz)
    password VARCHAR(255) NOT NULL, -- Şifre (Hashlenmiş veya güvenli bir şekilde saklanmalı)
    hospital_name VARCHAR(255), -- Bağlı olduğu hastane adı (isteğe bağlı)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Kayıt tarihi
);

CREATE TABLE randevular (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Randevular için benzersiz UUID
    hasta_id UUID NOT NULL, -- users tablosundaki kullanıcının (hastanın) ID'si
    doctor_id SERIAL NOT NULL, -- doctors tablosundaki doktorun ID'si
    randevu_tarihi DATE NOT NULL,
    randevu_saati TIME NOT NULL,
    olusturma_tarihi TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    guncelleme_tarihi TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    notlar TEXT,
    doktor_notlari TEXT (Doktor tarafından eklenen notlar),
    FOREIGN KEY (hasta_id) REFERENCES users(id) ON DELETE CASCADE, -- users tablosuna foreign key bağlantısı
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE -- doctors tablosuna foreign key bağlantısı
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

