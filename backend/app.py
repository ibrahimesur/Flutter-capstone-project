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
CORS(app)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

# ---------------- CORS -----------------
@app.after_request
def after_request(resp):
    resp.headers['Access-Control-Allow-Origin'] = '*'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    resp.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
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
        insert_columns = ['name', 'institutional_id', 'email', 'password']
        insert_values = [name, institutional_id, email, password]
        unique_constraint_column = 'institutional_id'
    elif user_type == 'hospital_admin':
        if not institutional_id:
            return jsonify({'message':'Hastane yönetimi kaydı için Kurumsal ID gerekli'}),400
        table_name = 'hospital_admins'
        insert_columns = ['name', 'institutional_id', 'email', 'password']
        insert_values = [name, institutional_id, email, password]
        unique_constraint_column = 'institutional_id'
    else:
        return jsonify({'message':'Geçersiz kullanıcı tipi belirtildi'}), 400

    hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    if user_type == 'patient':
        insert_values[insert_columns.index('password_hash')] = hashed
    else:
        insert_values[insert_columns.index('password')] = hashed

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

    if user_type == 'patient':
        table_name = 'users'
        identifier_column = 'tc_kimlik_no'
        user_id_column = 'id'
        password_column = 'password_hash'
    elif user_type == 'doctor':
        table_name = 'doctors'
        identifier_column = 'institutional_id'
        user_id_column = 'doctor_id'
        password_column = 'password'
    elif user_type == 'hospital_admin':
        table_name = 'hospital_admins'
        identifier_column = 'institutional_id'
        user_id_column = 'admin_id'
        password_column = 'password'
    else:
        return jsonify({'message':'Geçersiz kullanıcı tipi belirtildi'}), 400

    # Authenticate
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f'SELECT {user_id_column}, {password_column} FROM {table_name} WHERE {identifier_column}=%s', (identifier,))
        user = cur.fetchone()

        if user:
            hashed_password_from_db = None
            if isinstance(user[1], str):
                 hashed_password_from_db = user[1].encode('utf-8')
            elif isinstance(user[1], bytes):
                 hashed_password_from_db = user[1]
            else:
                logger.error('Beklenmedik şifre formatı tipi: %s', type(user[1]))
                return jsonify({'message':'Giriş hatası', 'error':'Beklenmedik şifre formatı.'}), 500

            if bcrypt.checkpw(password.encode('utf-8'), hashed_password_from_db):
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

@app.route('/book-appointment', methods=['POST','OPTIONS'])
def book_appointment():
    if request.method == 'OPTIONS':
        r = app.make_default_options_response()
        r.headers['Access-Control-Max-Age'] = '3600'
        return r

    if not request.is_json:
        return jsonify({'error':'JSON formatı gerekli'}), 400

    data = request.get_json()
    # TODO: hasta_id bilgisini frontend'den almanız gerekiyor.
    # Güvenlik nedeniyle bu bilginin backend tarafından doğrulanması önemlidir.
    # Şu an için varsayımsal olarak istek gövdesinden alıyoruz:
    hasta_id = data.get('hasta_id')

    doctor_name = data.get('doctor')
    appointment_date_str = data.get('date')
    appointment_time_str = data.get('time')
    department = data.get('department')

    if not hasta_id or not doctor_name or not appointment_date_str or not appointment_time_str:
        return jsonify({'error':'Hasta ID, Doktor adı, tarih ve saat bilgileri eksik'}), 400

    try:
        appointment_date = datetime.datetime.fromisoformat(appointment_date_str.replace('Z', '+00:00')).date()
        appointment_time = appointment_time_str + ":00" if len(appointment_time_str) == 5 else appointment_time_str

        conn = get_db_connection()
        cur = conn.cursor();

        cur.execute('SELECT doctor_id FROM doctors WHERE LOWER(name) = LOWER(%s)', (doctor_name.strip(),))
        doctor_result = cur.fetchone()

        if not doctor_result:
            conn.rollback();cur.close();conn.close();
            return jsonify({'error':f'{doctor_name} adında bir doktor bulunamadı'}), 404

        doctor_id = doctor_result[0]

        cur.execute(
            """
            INSERT INTO randevular (hasta_id, doctor_id, randevu_tarihi, randevu_saati)
            VALUES (%s, %s, %s, %s)
            RETURNING id, hasta_id;
            """,
            (hasta_id, doctor_id, appointment_date, appointment_time)
        )
        result = cur.fetchone()
        new_appointment_id = result[0]
        booked_hasta_id = result[1]
        conn.commit()

        return jsonify({
            'message':'Randevu başarıyla oluşturuldu',
            'appointment_id': str(new_appointment_id),
            'hasta_id': str(booked_hasta_id),
            'doctor_id': doctor_id,
            'randevu_tarihi': appointment_date.isoformat(),
            'randevu_saati': appointment_time
            }), 201

    except ValueError as ve:
        logger.error('Tarih/Saat format hatası: %s', ve, exc_info=True)
        return jsonify({'error':f'Tarih veya saat formatı geçersiz: {ve}'}), 400
    except Exception as e:
        conn.rollback();logger.error('Randevu oluşturma hatası: %s', e, exc_info=True);
        return jsonify({'message':'Randevu oluşturulurken bir hata oluştu', 'error':str(e)}), 500
    finally:
        if 'cur' in locals() and cur is not None:
             cur.close()
        if 'conn' in locals() and conn is not None:
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
                'doctor_id': str(doc[1]),
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

if __name__ == '__main__':
    logger.info('Sunucu başlatılıyor…')
    app.run(host='0.0.0.0',port=8000,debug=True,threaded=True)
