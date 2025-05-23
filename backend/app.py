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
    tc_kimlik_no = data.get('tc_kimlik_no')
    email = data.get('email')
    password = data.get('password')
    if not tc_kimlik_no or not email or not password:
        return jsonify({'message':'TC Kimlik No, e-posta ve şifre gerekli'}),400
    hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('INSERT INTO users (tc_kimlik_no,email,password_hash) VALUES (%s,%s,%s) RETURNING id',
                    (tc_kimlik_no,email,hashed))
        user_id = cur.fetchone()[0]
        conn.commit()
        return jsonify({'message':'Kullanıcı kaydedildi','user_id':str(user_id)}),201
    except psycopg2.errors.UniqueViolation:
        conn.rollback()
        return jsonify({'message':'Bu kullanıcı zaten var'}),409
    except Exception as e:
        conn.rollback()
        return jsonify({'message':'Kayıt hatası','error':str(e)}),500
    finally:
        cur.close();conn.close()

@app.route('/login', methods=['POST'])
def login():
    # Validate JSON and input
    if not request.is_json:
        return jsonify({'message':'JSON formatı gerekli'}),400
    data = request.get_json()
    tc = data.get('tc_kimlik_no')
    pw = data.get('password')
    if not tc or not pw:
        return jsonify({'message':'TC Kimlik No ve şifre gerekli'}),400
    # Authenticate
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT id,password_hash FROM users WHERE tc_kimlik_no=%s',(tc,))
        user = cur.fetchone()
        if not user or not bcrypt.checkpw(pw.encode('utf-8'), user[1].tobytes()):
            return jsonify({'message':'Geçersiz kimlik veya şifre'}),401
        token = jwt.encode({'user_id':str(user[0]),'exp':datetime.datetime.utcnow()+datetime.timedelta(hours=24)},
                           app.config['SECRET_KEY'],algorithm='HS256')
        return jsonify({'message':'Giriş başarılı','token':token}),200
    except Exception as e:
        return jsonify({'message':'Giriş hatası','error':str(e)}),500
    finally:
        cur.close();conn.close()

if __name__ == '__main__':
    logger.info('Sunucu başlatılıyor…')
    app.run(host='0.0.0.0',port=8000,debug=True,threaded=True)
