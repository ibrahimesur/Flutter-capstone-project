from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import logging
import csv
import pandas as pd
import joblib
import psycopg2
import bcrypt
from dotenv import load_dotenv
import jwt
import datetime
from functools import wraps

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, classification_report

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})  # Tüm endpoint'ler için CORS'u etkinleştir
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

# ---------------- CORS -----------------
@app.after_request
def after_request(resp):
    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    resp.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    return resp

# --------------- Logging ---------------
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# --------------- Paths -----------------
BASE_DIR = os.path.dirname(__file__)
MODEL_DIR = os.path.join(BASE_DIR, 'models')
os.makedirs(MODEL_DIR, exist_ok=True)
MODEL_PATH = os.path.join(MODEL_DIR, 'disease_prediction_model.joblib')
DATASET_PATH = os.path.join(os.path.dirname(BASE_DIR), 'Datasets', 'Disease and symptoms dataset.csv')
logger.info('Veri seti yolu: %s', DATASET_PATH)

# ============ Globals ============
model = None
vectorizer = None
disease_labels = None

def get_ip_addresses():
    try:
        return ['127.0.0.1', '0.0.0.0']
    except Exception as e:
        logger.error(f'IP adresleri alınamadı: {e}')
        return ['127.0.0.1']

# ============ Helpers ============
def load_dataset(path: str) -> pd.DataFrame:
    for sep in [',', ';', '\t']:
        try:
            df = pd.read_csv(
                path,
                sep=sep,
                engine='python',
                quoting=csv.QUOTE_NONE,
                encoding='utf-8-sig'
            )
            df.columns = [c.strip().strip('"').strip("'") for c in df.columns]
            if 'diseases' in df.columns:
                logger.info("CSV okundu: %d satır, %d sütun (sep='%s')", len(df), len(df.columns), sep)
                return df
        except Exception:
            pass
    raise ValueError("'diseases' sütunu bulunamadı — CSV ayraç/format hatası.")

def prepare_data(df: pd.DataFrame):
    texts, labels = [], []
    for _, row in df.iterrows():
        disease = str(row.get('diseases', '')).strip()
        if not disease:
            continue
        symptoms = [
            col.lower()
            for col in df.columns
            if col != 'diseases' and str(row.get(col, '0')).strip() not in ('0', '', 'nan')
        ]
        if symptoms:
            texts.append(' '.join(symptoms))
            labels.append(disease)
    logger.info('Hazırlanan örnek sayısı: %d', len(labels))
    return texts, labels

def get_db_connection():
    db_url = os.getenv('DATABASE_URL')
    if not db_url:
        raise RuntimeError("DATABASE_URL ortam değişkeni ayarlı değil")
    return psycopg2.connect(dsn=db_url)

def train_model(texts, labels):
    logger.info("Model eğitimi başlıyor…")
    X_tr, X_te, y_tr, y_te = train_test_split(texts, labels, test_size=0.2, random_state=42)
    tfidf = TfidfVectorizer(max_features=20000, ngram_range=(1,2), token_pattern=r"(?u)\b\w+\b", lowercase=True, sublinear_tf=True)
    clf = LogisticRegression(max_iter=4000, class_weight="balanced", n_jobs=-1)
    pipe = Pipeline([("tfidf", tfidf), ("clf", clf)])
    pipe.fit(X_tr, y_tr)
    y_pred = pipe.predict(X_te)
    acc = accuracy_score(y_te, y_pred)
    logger.info("Doğruluk: %.4f", acc)
    logger.info("Sınıflandırma raporu:\n%s", classification_report(y_te, y_pred, zero_division=0)[:800])
    joblib.dump(pipe, MODEL_PATH)
    logger.info("Model kaydedildi: %s", MODEL_PATH)
    return pipe, tfidf, sorted(set(labels))

def load_or_train(df: pd.DataFrame):
    global model, vectorizer, disease_labels
    if os.path.exists(MODEL_PATH):
        model = joblib.load(MODEL_PATH)
        vectorizer = model.named_steps['tfidf']
        disease_labels = model.classes_.tolist()
    else:
        texts, labels = prepare_data(df)
        model, vectorizer, disease_labels = train_model(texts, labels)

# ============ Startup ============
try:
    df = load_dataset(DATASET_PATH)
    load_or_train(df)
except Exception as exc:
    logger.error('Başlatma hatası: %s', exc, exc_info=True)
    df = None
    model = None

# ============ Routes ============
@app.route('/')
def root():
    return jsonify({'message':'Hastalık-Semptom API','model_status':'loaded' if model else 'not_loaded','ip_addresses':get_ip_addresses()})

@app.route('/hastalik-tahmini', methods=['POST','OPTIONS'])
def predict():
    if request.method == 'OPTIONS':
        r = app.make_default_options_response()
        r.headers['Access-Control-Max-Age'] = '3600'
        return r
    if not request.is_json:
        return jsonify({'error':'JSON formatı gerekli'}),400
    data = request.get_json()
    syms = data.get('semptomlar')
    if not syms or not isinstance(syms,list):
        return jsonify({'error':'"semptomlar" listesi gerekli'}),400
    syms = [str(s).lower() for s in syms if str(s).strip()]
    if not syms:
        return jsonify({'error':'Boş semptom listesi'}),400
    text = ' '.join(syms)
    try:
        pred = model.predict([text])[0]
        proba = float(model.predict_proba([text])[0].max())
    except Exception as exc:
        logger.error('Tahmin hatası: %s', exc, exc_info=True)
        return jsonify({'error':'Tahmin yapılamadı'}),500
    return jsonify(hastalikAdi=pred, olasilik=proba, eslesen_semptom_sayisi=len(syms))

@app.route('/train-model', methods=['POST'])
def retrain():
    global model, vectorizer, disease_labels
    if df is None:
        return jsonify({'error':'Veri seti yüklenemedi'}),500
    texts, labels = prepare_data(df)
    model, vectorizer, disease_labels = train_model(texts, labels)
    return jsonify(success=True, classes=len(disease_labels))

@app.route('/register', methods=['POST'])
def register():
    if not request.is_json:
        return jsonify({'message':'JSON formatı gerekli'}),400
    data = request.get_json()
    name = data.get('name')
    tc_kimlik_no = data.get('tc_kimlik_no')
    institutional_id = data.get('institutional_id')
    email = data.get('email')
    password = data.get('password')
    user_type = data.get('user_type')

    if not name or not email or not password or not user_type:
        return jsonify({'message':'Ad, e-posta, şifre ve kullanıcı tipi gerekli'}),400

    table_name = None
    insert_columns = []
    insert_values = []
    unique_constraint_column = None

    if user_type == 'patient':
        if not tc_kimlik_no:
            return jsonify({'message':'Hasta kaydı için TC Kimlik No gerekli'}),400
        table_name = 'users'
        insert_columns = ['tc_kimlik_no', 'email', 'password_hash', 'is_doctor']
        insert_values = [tc_kimlik_no, email, password, False]
        unique_constraint_column = 'tc_kimlik_no'
    elif user_type == 'doctor':
        if not institutional_id:
            return jsonify({'message':'Doktor kaydı için Kurumsal ID gerekli'}),400
        table_name = 'doctors'
        insert_columns = ['name', 'institutional_id', 'email', 'password_hash']
        insert_values = [name, institutional_id, email, password]
        unique_constraint_column = 'institutional_id'
    elif user_type == 'hospital_admin':
        if not institutional_id:
            return jsonify({'message':'Hastane yönetimi kaydı için Kurumsal ID gerekli'}),400
        table_name = 'hospital_admins'
        insert_columns = ['institutional_id', 'hospital_name']
        insert_values = [institutional_id, data.get('hospital_name')]
        unique_constraint_column = 'institutional_id'
    else:
        return jsonify({'message':'Geçersiz kullanıcı tipi belirtildi'}), 400

    hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    if user_type == 'patient' or user_type == 'doctor':
        insert_values[insert_columns.index('password_hash')] = hashed

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        # Dinamik olarak insert sorgusu oluştur
        cols = ', '.join(insert_columns)
        placeholders = ', '.join(['%s'] * len(insert_columns))
        query = f'INSERT INTO {table_name} ({cols}) VALUES ({placeholders}) RETURNING {unique_constraint_column}'

        cur.execute(query, tuple(insert_values))
        inserted_id = cur.fetchone()[0]
        conn.commit()

        return jsonify({'message':'Kullanıcı başarıyla kaydedildi', f'{unique_constraint_column}': str(inserted_id), 'user_type': user_type}),201

    except psycopg2.errors.UniqueViolation:
        conn.rollback()
        return jsonify({'message':f'Bu {unique_constraint_column} zaten kullanılıyor'}),409
    except Exception as e:
        conn.rollback()
        logger.error('Kayıt hatası: %s', e, exc_info=True)
        return jsonify({'message':'Kayıt hatası','error':str(e)}),500
    finally:
        cur.close();conn.close()

@app.route('/login', methods=['POST'])
def login():
    # Validate JSON and input
    if not request.is_json:
        return jsonify({'message':'JSON formatı gerekli'}),400
    data = request.get_json()
    identifier = data.get('identifier') # TC Kimlik No veya Kurumsal ID
    email = data.get('email')
    password = data.get('password')
    user_type = data.get('user_type') # 'patient', 'doctor', 'hospital_admin'

    if not identifier or not password or not user_type:
        return jsonify({'message':'Kimlik (TC No/ID), e-posta, şifre ve kullanıcı tipi gerekli'}),400

    table_name = None
    identifier_column = None
    user_id_column = None
    password_column = None
    email_column = None

    if user_type == 'patient':
        table_name = 'users'
        identifier_column = 'tc_kimlik_no'
        user_id_column = 'id'
        password_column = 'password_hash'
        email_column = 'email'
    elif user_type == 'doctor':
        table_name = 'doctors'
        identifier_column = 'institutional_id'
        user_id_column = 'doctor_id'
        password_column = 'password_hash'
        email_column = 'email'
    elif user_type == 'hospital_admin':
        table_name = 'hospital_admins'
        identifier_column = 'institutional_id'
        user_id_column = 'admin_id'
        password_column = 'password_hash'
        email_column = 'email'
    else:
        return jsonify({'message':'Geçersiz kullanıcı tipi belirtildi'}), 400

    # Authenticate
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f'SELECT {user_id_column}, {password_column}, {email_column} FROM {table_name} WHERE {identifier_column}=%s', (identifier,))
        user = cur.fetchone()

        if user:
            logger.info('DEBUG: User found: %s', user) # User objesini logla
            hashed_password_from_db = None
            if user[1] is not None:
                # Veritabanından çekilen şifreyi her zaman bytes türüne dönüştür
                hashed_password_from_db = bytes(user[1]) if isinstance(user[1], memoryview) else str(user[1]).encode('utf-8')
                logger.info('DEBUG: Hashed password from DB (type: %s): %s', type(hashed_password_from_db), hashed_password_from_db) # Hashed şifreyi ve türünü logla

            if hashed_password_from_db and bcrypt.checkpw(password.encode('utf-8'), hashed_password_from_db):
                 user_id_value = user[0]

                 if user_type == 'patient':
                      return jsonify({
                           'message':'Giriş başarılı',
                           'user_type': user_type,
                           'hasta_id': str(user_id_value)
                          }), 200
                 else:
                     return jsonify({
                          'message':'Giriş başarılı',
                          'user_type': user_type
                         }), 200

            else:
                return jsonify({'message':'Geçersiz kimlik veya şifre'}),401

        else:
            return jsonify({'message':'Geçersiz kimlik veya şifre'}),401

    except psycopg2.OperationalError as e:
        logger.error('Veritabanı bağlantı veya işlem hatası: %s', e, exc_info=True)
        return jsonify({'message':'Giriş hatası', 'error':'Veritabanı bağlantı veya işlem hatası.'}),500
    except Exception as e:
        logger.error('Beklenmedik giriş hatası: %s', e, exc_info=True)
        return jsonify({'message':'Giriş hatası','error':'Beklenmedik sunucu hatası.'}),500
    finally:
        if 'cur' in locals() and cur is not None:
             cur.close()
        if 'conn' in locals() and conn is not None:
             conn.close()

@app.route('/book-appointment', methods=['POST'])
def book_appointment():
    if not request.is_json:
        return jsonify({'message': 'JSON formatı gerekli'}), 400
    
    data = request.get_json()
    hasta_id = data.get('hasta_id')
    doctor_id = data.get('doctor_id')
    randevu_tarihi_str = data.get('randevu_tarihi')
    randevu_saati_str = data.get('randevu_saati')
    notlar = data.get('notlar', '')  # İsteğe bağlı notlar
    
    if not all([hasta_id, doctor_id, randevu_tarihi_str, randevu_saati_str]):
        return jsonify({'message': 'Tüm alanlar gerekli'}), 400
    
    try:
        # Tarih ve saat formatlarını kontrol et
        try:
            randevu_tarihi = datetime.datetime.strptime(randevu_tarihi_str, '%Y-%m-%d').date()
            randevu_saati = datetime.datetime.strptime(randevu_saati_str, '%H:%M').time()
        except ValueError:
            return jsonify({'message': 'Geçersiz tarih veya saat formatı. YYYY-MM-DD ve HH:MM kullanın.'}), 400

        conn = get_db_connection()
        cur = conn.cursor()
        
        # Hasta ve doktor varlığını kontrol et
        cur.execute('SELECT id FROM users WHERE id = %s', (hasta_id,))
        if not cur.fetchone():
            return jsonify({'message': 'Hasta bulunamadı'}), 404
            
        cur.execute('SELECT doctor_id FROM doctors WHERE doctor_id = %s', (doctor_id,))
        if not cur.fetchone():
            return jsonify({'message': 'Doktor bulunamadı'}), 404

        # Takvimde bu zaman dilimi var mı kontrol et
        cur.execute('''
            SELECT takvim_id, durum FROM doktor_takvimleri 
            WHERE doctor_id = %s 
            AND tarih = %s 
            AND saat = %s
        ''', (doctor_id, randevu_tarihi, randevu_saati))
        
        takvim_kaydi = cur.fetchone()
        
        takvim_id = None

        if takvim_kaydi:
            takvim_id, durum = takvim_kaydi
            if durum == 'dolu':
                return jsonify({'message': 'Seçilen zaman dilimi zaten dolu'}), 409
            # Eğer kayıt varsa ve müsaitse, id'yi alacağız ve aşağıda durumunu güncelleyeceğiz
        else:
            # Eğer takvim kaydı yoksa, yeni bir kayıt ekleyelim ve durumunu 'dolu' yapalım
            cur.execute('''
                INSERT INTO doktor_takvimleri (doctor_id, tarih, saat, durum)
                VALUES (%s, %s, %s, 'dolu')
                RETURNING takvim_id
            ''', (doctor_id, randevu_tarihi, randevu_saati))
            takvim_id = cur.fetchone()[0]

        # Aynı hasta için aynı tarih ve saatte başka randevu var mı kontrol et
        # Bu kontrol takvim kaydı kontrolünden sonra gelmeli ki, takvimde olmayan ama randevusu olan durumu olmasın
        cur.execute('''
            SELECT id FROM randevular 
            WHERE hasta_id = %s 
            AND randevu_tarihi = %s 
            AND randevu_saati = %s
        ''', (hasta_id, randevu_tarihi, randevu_saati))
        
        if cur.fetchone():
            # Eğer hasta için randevu zaten varsa ve biz yeni takvim kaydı eklediysek onu silmeliyiz
            if not takvim_kaydi:
                 # Yeni eklenen takvim kaydını sil
                 cur.execute('DELETE FROM doktor_takvimleri WHERE takvim_id = %s', (takvim_id,))
                 conn.commit() # Silme işlemini kaydet

            return jsonify({'message': 'Bu tarih ve saatte zaten bir randevunuz var'}), 409
        
        # Randevuyu oluştur
        cur.execute('''
            INSERT INTO randevular (
                hasta_id, 
                doctor_id, 
                randevu_tarihi, 
                randevu_saati,
                notlar
            )
            VALUES (%s, %s, %s, %s, %s)
            RETURNING id
        ''', (hasta_id, doctor_id, randevu_tarihi, randevu_saati, notlar))
        
        randevu_id = cur.fetchone()[0]
        
        # Takvim durumunu güncelle (Eğer takvim kaydı daha önce varsa)
        if takvim_kaydi:
             cur.execute('''
                 UPDATE doktor_takvimleri 
                 SET durum = 'dolu' 
                 WHERE takvim_id = %s
             ''', (takvim_id,))

        conn.commit()
        
        return jsonify({
            'message': 'Randevu başarıyla oluşturuldu',
            'randevu_id': str(randevu_id),
            'randevu_tarihi': randevu_tarihi_str,
            'randevu_saati': randevu_saati_str
        }), 201
        
    except Exception as e:
        conn.rollback()
        logger.error('Randevu oluşturma hatası: %s', e, exc_info=True)
        return jsonify({'message': 'Randevu oluşturulurken hata oluştu', 'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

@app.route('/list-doctors', methods=['GET', 'OPTIONS'])
def list_doctors():
    if request.method == 'OPTIONS':
        r = app.make_default_options_response()
        r.headers['Access-Control-Max-Age'] = '3600'
        return r

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT name, doctor_id, institutional_id, department FROM doctors')
        doctors = cur.fetchall()

        doctor_list = []
        for doc in doctors:
            doctor_list.append({
                'name': doc[0],
                'doctor_id': doc[1],
                'institutional_id': doc[2],
                'department': doc[3]
            })

        return jsonify(doctor_list), 200

    except Exception as e:
        logger.error('Doktor listeleme hatası: %s', e, exc_info=True)
        return jsonify({'error': 'Doktorlar listelenirken bir hata oluştu'}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

@app.route('/get-appointments/<hasta_id>', methods=['GET'])
def get_appointments(hasta_id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            SELECT r.id, r.hasta_id, d.name as doctor, d.department, 
                   r.randevu_tarihi, r.randevu_saati
            FROM randevular r
            JOIN doctors d ON r.doctor_id = d.doctor_id
            WHERE r.hasta_id = %s
            ORDER BY r.randevu_tarihi ASC, r.randevu_saati ASC
        """, (hasta_id,))
        
        appointments = cur.fetchall()
        
        if not appointments:
            return jsonify([]), 200

        appointment_list = []
        for appt in appointments:
            appointment_list.append({
                'id': str(appt[0]),
                'hasta_id': str(appt[1]),
                'doctor': appt[2],
                'department': appt[3],
                'randevu_tarihi': appt[4].isoformat(),
                'randevu_saati': appt[5].strftime('%H:%M')
            })

        return jsonify(appointment_list), 200

    except Exception as e:
        logger.error('Randevuları getirme hatası: %s', e, exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

@app.route('/get-doctor-availability/<int:doctor_id>', methods=['GET'])
def get_doctor_availability(doctor_id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # URL'den tarih parametrelerini al
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')

        if not start_date_str or not end_date_str:
            return jsonify({'message': 'Başlangıç ve bitiş tarihi gerekli'}), 400

        try:
            start_date = datetime.datetime.strptime(start_date_str, '%Y-%m-%d').date()
            end_date = datetime.datetime.strptime(end_date_str, '%Y-%m-%d').date()
        except ValueError:
            return jsonify({'message': 'Geçersiz tarih formatı. YYYY-MM-DD kullanın.'}), 400

        # Tarih listesini oluştur
        date_list = []
        current_date = start_date
        while current_date <= end_date:
            date_list.append(current_date)
            current_date += datetime.timedelta(days=1)

        # Veritabanından mevcut takvim verilerini çek
        cur.execute('''
            SELECT takvim_id, tarih, saat, durum
            FROM doktor_takvimleri
            WHERE doctor_id = %s::text
            AND tarih BETWEEN %s AND %s
            ORDER BY tarih, saat
        ''', (str(doctor_id), start_date, end_date))

        db_takvim_datalari = cur.fetchall()

        # Veritabanından gelen verileri düzenle
        db_slots = {}
        for takvim_id, tarih, saat, durum in db_takvim_datalari:
            tarih_str = tarih.strftime('%Y-%m-%d')
            saat_str = saat.strftime('%H:%M')
            if tarih_str not in db_slots:
                db_slots[tarih_str] = {}
            db_slots[tarih_str][saat_str] = {'id': takvim_id, 'durum': durum}

        # Kurala göre tüm potansiyel zaman dilimlerini oluştur ve veritabanındaki durumla eşleştir
        availability_by_date = {}
        time_intervals = [('09:00', '12:30'), ('14:00', '16:30')]

        for current_date in date_list:
            tarih_str = current_date.strftime('%Y-%m-%d')
            day_of_week = current_date.strftime('%a')  # Pazartesi, Salı vs.
            day_of_week_int = current_date.weekday()  # 0=Pzt, 6=Paz

            # Sadece hafta içi (Pazartesi=0, Cuma=4)
            if 0 <= day_of_week_int <= 4:
                availability_by_date[tarih_str] = {
                    'date': tarih_str,
                    'day_of_week': day_of_week,
                    'time_slots': []
                }

                for start_time_str, end_time_str in time_intervals:
                    start_hour, start_minute = map(int, start_time_str.split(':'))
                    end_hour, end_minute = map(int, end_time_str.split(':'))

                    current_time = datetime.time(start_hour, start_minute)
                    end_time = datetime.time(end_hour, end_minute)

                    while current_time <= end_time:
                        saat_str = current_time.strftime('%H:%M')

                        # Veritabanında bu slot var mı ve durumu ne?
                        db_slot_info = db_slots.get(tarih_str, {}).get(saat_str)

                        slot_durum = 'müsait'
                        slot_id = None

                        if db_slot_info:
                            slot_durum = db_slot_info['durum']  # 'müsait' veya 'dolu'
                            slot_id = db_slot_info['id']

                        availability_by_date[tarih_str]['time_slots'].append({
                            'id': slot_id,  # Eğer veritabanında varsa ID'si, yoksa None
                            'time': saat_str,
                            'durum': slot_durum
                        })

                        # 30 dakika ekle
                        current_datetime = datetime.datetime.combine(current_date, current_time)
                        next_datetime = current_datetime + datetime.timedelta(minutes=30)
                        current_time = next_datetime.time()

        # Tarihleri sırala ve yanıtı oluştur
        sorted_dates = sorted(availability_by_date.keys())
        response_data = {
            'availability': [availability_by_date[date] for date in sorted_dates]
        }

        return jsonify(response_data), 200

    except Exception as e:
        logger.error('Takvim sorgulanırken hata: %s', e, exc_info=True)
        return jsonify({'message': 'Takvim sorgulanırken hata oluştu', 'error': str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

# Doktor müsaitlik eklemek için yeni endpoint (Frontend'in yapısına uygun olarak birden fazla zaman dilimi eklemeye yönelik olabilir)
@app.route('/add-doctor-availability', methods=['POST'])
def add_doctor_availability():
    if not request.is_json:
        return jsonify({'message': 'JSON formatı gerekli'}), 400
    
    data = request.get_json()
    doctor_id = data.get('doctor_id')
    # Takvim bilgileri [{ "tarih": "YYYY-MM-DD", "saat": "HH:MM" }, ...]
    availability_slots = data.get('availability_slots')
    
    if not all([doctor_id, availability_slots]) or not isinstance(availability_slots, list) or not availability_slots:
        return jsonify({'message': 'Doktor ID ve müsait zaman dilimleri (liste) gerekli'}), 400
        
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # Doktorun varlığını kontrol et
        cur.execute('SELECT doctor_id FROM doctors WHERE doctor_id = %s', (doctor_id,))
        if not cur.fetchone():
            return jsonify({'message': 'Doktor bulunamadı'}), 404

        added_slots = []
        errors = []

        for slot in availability_slots:
            tarih = slot.get('tarih')
            saat = slot.get('saat')

            if not tarih or not saat:
                errors.append({'slot': slot, 'message': 'Tarih ve saat bilgisi eksik'})
                continue
                
            try:
                 datetime.datetime.strptime(tarih, '%Y-%m-%d').date()
                 datetime.datetime.strptime(saat, '%H:%M').time()
            except ValueError:
                 errors.append({'slot': slot, 'message': 'Geçersiz tarih veya saat formatı. YYYY-MM-DD ve HH:MM kullanın.'})
                 continue

            # Zaman diliminin zaten eklenmiş olup olmadığını kontrol et
            cur.execute('''
                SELECT takvim_id, durum FROM doktor_takvimleri  
                WHERE doctor_id = %s AND tarih = %s AND saat = %s
            ''', (doctor_id, tarih, saat))
            
            if cur.fetchone():
                 errors.append({'slot': slot, 'message': 'Bu zaman dilimi zaten eklenmiş'})
                 continue
            
            # Yeni müsait zaman dilimi ekle
            cur.execute('''
                INSERT INTO doktor_takvimleri (doctor_id, tarih, saat, durum)
                VALUES (%s, %s, %s, 'müsait')
                RETURNING id
            ''', (doctor_id, tarih, saat))
            
            added_slots.append({'slot': slot, 'id': cur.fetchone()[0]})

        conn.commit()
        
        response = {
            'message': f'{len(added_slots)} müsait zaman dilimi eklendi.',
            'added_slots': added_slots,
            'errors': errors
        }
        
        status_code = 201 if added_slots else (400 if errors else 200) # Eğer hiç eklenmediyse ve hatalar varsa 400, sadece bilgi ise 200
        
        return jsonify(response), status_code
        
    except Exception as e:
        conn.rollback()
        logger.error('Takvim ekleme hatası: %s', e, exc_info=True)
        return jsonify({'message': 'Takvim eklenirken hata oluştu', 'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

# Doktor takvimindeki bir zaman diliminin durumunu güncellemek için endpoint (örn: randevu alındığında dolu yapmak)
@app.route('/update-availability-status/<int:takvim_id>', methods=['PUT'])
def update_availability_status(takvim_id):
    if not request.is_json:
        return jsonify({'message': 'JSON formatı gerekli'}), 400
    
    data = request.get_json()
    status = data.get('durum') # 'müsait' veya 'dolu'

    if not status or status not in ['müsait', 'dolu']:
         return jsonify({'message': 'Geçerli durum bilgisi (müsait/dolu) gerekli'}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute('''
            UPDATE doktor_takvimleri
            SET durum = %s
            WHERE id = %s
            RETURNING id
        ''', (status, takvim_id))

        if not cur.fetchone():
            conn.rollback()
            return jsonify({'message': 'Belirtilen takvim kaydı bulunamadı'}), 404

        conn.commit()

        return jsonify({'message': 'Takvim durumu güncellendi'}), 200

    except Exception as e:
        conn.rollback()
        logger.error('Takvim durumu güncelleme hatası: %s', e, exc_info=True)
        return jsonify({'message': 'Takvim durumu güncellenirken hata oluştu', 'error': str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

@app.route('/get-profile/<hasta_id>', methods=['GET'])
def get_profile(hasta_id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            SELECT ad_soyad, yas, boy, kilo, kan_grubu, kronik_hastaliklar, alerjiler
            FROM saglik_profili
            WHERE hasta_id = %s
        """, (hasta_id,))
        
        profile = cur.fetchone()
        
        if not profile:
            return jsonify({'message': 'Profil bulunamadı'}), 404

        profile_data = {
            'ad_soyad': profile[0],
            'yas': profile[1],
            'boy': profile[2],
            'kilo': float(profile[3]) if profile[3] else None,
            'kan_grubu': profile[4],
            'kronik_hastaliklar': profile[5],
            'alerjiler': profile[6]
        }

        return jsonify(profile_data), 200

    except Exception as e:
        logger.error('Profil getirme hatası: %s', e, exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

@app.route('/update-profile', methods=['POST'])
def update_profile():
    if not request.is_json:
        return jsonify({'message': 'JSON formatı gerekli'}), 400
    
    data = request.get_json()
    hasta_id = data.get('hasta_id')
    
    if not hasta_id:
        return jsonify({'message': 'Hasta ID gerekli'}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # Önce profil var mı kontrol et
        cur.execute("SELECT 1 FROM saglik_profili WHERE hasta_id = %s", (hasta_id,))
        profile_exists = cur.fetchone() is not None

        if profile_exists:
            # Profili güncelle
            cur.execute("""
                UPDATE saglik_profili
                SET ad_soyad = %s,
                    yas = %s,
                    boy = %s,
                    kilo = %s,
                    kan_grubu = %s,
                    kronik_hastaliklar = %s,
                    alerjiler = %s
                WHERE hasta_id = %s
            """, (
                data.get('ad_soyad'),
                data.get('yas'),
                data.get('boy'),
                data.get('kilo'),
                data.get('kan_grubu'),
                data.get('kronik_hastaliklar'),
                data.get('alerjiler'),
                hasta_id
            ))
        else:
            # Yeni profil oluştur
            cur.execute("""
                INSERT INTO saglik_profili (
                    hasta_id, ad_soyad, yas, boy, kilo, kan_grubu, 
                    kronik_hastaliklar, alerjiler
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                hasta_id,
                data.get('ad_soyad'),
                data.get('yas'),
                data.get('boy'),
                data.get('kilo'),
                data.get('kan_grubu'),
                data.get('kronik_hastaliklar'),
                data.get('alerjiler')
            ))

        conn.commit()
        return jsonify({'message': 'Profil başarıyla güncellendi'}), 200

    except Exception as e:
        conn.rollback()
        logger.error('Profil güncelleme hatası: %s', e, exc_info=True)
        return jsonify({'error': str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
            cur.close()
        if 'conn' in locals() and conn is not None:
            conn.close()

if __name__ == '__main__':
    logger.info('Sunucu başlatılıyor…')
    app.run(host='0.0.0.0',port=8000,debug=True,threaded=True)
