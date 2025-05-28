CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tc_kimlik_no VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_doctor BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- Doktorlar Tablosu
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY, -- Otomatik artan benzersiz kimlik
    institutional_id VARCHAR(255) UNIQUE NOT NULL, -- Kurumsal Doktor ID (Benzersiz)
    name VARCHAR(255) NOT NULL, -- Ad Soyad
    email VARCHAR(255) UNIQUE NOT NULL, -- E-posta (Benzersiz)
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
    FOREIGN KEY (hasta_id) REFERENCES users(id) ON DELETE CASCADE, -- users tablosuna foreign key bağlantısı
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE -- doctors tablosuna foreign key bağlantısı
);
