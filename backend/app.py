from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import socket
import logging
import csv
import pandas as pd
import joblib
from collections import Counter
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, classification_report
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)
CORS(app)

# ---------------- CORS -----------------
@app.after_request
def after_request(resp):
    resp.headers['Access-Control-Allow-Origin']  = '*'
    resp.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    resp.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    return resp

# --------------- Logging ---------------
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# --------------- Paths -----------------
BASE_DIR   = os.path.dirname(__file__)
MODEL_DIR  = os.path.join(BASE_DIR, 'models')
os.makedirs(MODEL_DIR, exist_ok=True)
MODEL_PATH = os.path.join(MODEL_DIR, 'disease_prediction_model.joblib')
DATASET_PATH = os.path.join(os.path.dirname(BASE_DIR), 'Datasets', 'Disease and symptoms dataset.csv')
logger.info('Veri seti yolu: %s', DATASET_PATH)

# --------------- Globals ---------------
model = None
vectorizer = None
disease_labels = None

# ============ Helpers ============

def get_ip_addresses():
    try:
        # Basit bir şekilde localhost ve 0.0.0.0 IP'lerini döndür
        return ['127.0.0.1', '0.0.0.0']
    except Exception as e:
        logger.error(f'IP adresleri alınamadı: {e}')
        return ['127.0.0.1']


def load_dataset(path: str) -> pd.DataFrame:
    """Try ',', ';', and tab separators; strip quotes; ensure 'diseases' col."""
    for sep in [',', ';', '\t']:
        try:
            df = pd.read_csv(path, sep=sep, engine='python', quoting=csv.QUOTE_NONE, encoding='utf-8-sig')
            df.columns = [c.strip().strip('"').strip("'") for c in df.columns]
            if 'diseases' in df.columns:
                logger.info("CSV okundu: %d satır, %d sütun (sep='%s')", len(df), len(df.columns), sep)
                return df
        except Exception as exc:
            logger.debug("Ayraç '%s' ile okunamadı: %s", sep, exc)
    raise ValueError("'diseases' sütunu bulunamadı — CSV ayraç/format hatası.")


def prepare_data(df: pd.DataFrame):
    texts, labels = [], []
    for _, row in df.iterrows():
        disease = str(row.get('diseases', '')).strip()
        if not disease:
            continue
        symptoms = [
            col.lower() for col in df.columns
            if col != 'diseases' and str(row.get(col, '0')).strip() not in ('0', '', 'nan')
        ]
        if symptoms:
            texts.append(' '.join(symptoms))
            labels.append(disease)
    logger.info('Hazırlanan örnek sayısı: %d', len(labels))
    return texts, labels


def train_model(texts, labels):
    logger.info("Model eğitimi başlıyor…")

    # -------- train / test split (stratify KAPALI) --------
    X_tr, X_te, y_tr, y_te = train_test_split(
        texts, labels, test_size=0.2, random_state=42
    )

    # -------- TF-IDF + Lojistik Regresyon --------
    tfidf = TfidfVectorizer(
        max_features=20_000,
        ngram_range=(1, 2),
        token_pattern=r"(?u)\b\w+\b",
        lowercase=True,
        sublinear_tf=True
    )
    clf = LogisticRegression(
        max_iter=4000,
        class_weight="balanced",
        n_jobs=-1,
    )
    pipe = Pipeline([("tfidf", tfidf), ("clf", clf)])

    # -------- eğit & değerlendir --------
    pipe.fit(X_tr, y_tr)
    y_pred = pipe.predict(X_te)
    acc = accuracy_score(y_te, y_pred)
    logger.info("Doğruluk: %.4f", acc)
    logger.info(
        "Sınıflandırma raporu:\n%s",
        classification_report(y_te, y_pred, zero_division=0)[:800]
    )

    # -------- kaydet --------
    joblib.dump(pipe, MODEL_PATH)
    logger.info("Model kaydedildi: %s", MODEL_PATH)
    return pipe, tfidf, sorted(set(labels))


def load_or_train(df: pd.DataFrame):
    global model, vectorizer, disease_labels
    if os.path.exists(MODEL_PATH):
        logger.info('Kayıtlı model bulunuyor, yükleniyor…')
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
    return jsonify({
        'message': 'Hastalık-Semptom API',
        'model_status': 'loaded' if model else 'not_loaded',
        'ip_addresses': get_ip_addresses()
    })

@app.route('/hastalik-tahmini', methods=['POST', 'OPTIONS'])
def predict():
    if request.method == 'OPTIONS':
        r = app.make_default_options_response()
        r.headers['Access-Control-Max-Age'] = '3600'
        return r
    if model is None:
        return jsonify(error='Model yüklenemedi'), 500
    data = request.get_json(silent=True)
    if not data or 'semptomlar' not in data:
        return jsonify(error="'semptomlar' listesi gerekir"), 400
    syms = [str(s).lower() for s in data['semptomlar'] if str(s).strip()]
    if not syms:
        return jsonify(error='Boş semptom listesi'), 400
    text = ' '.join(syms)
    try:
        pred = model.predict([text])[0]
        proba = model.predict_proba([text])[0].max()
    except Exception as exc:
        logger.error('Tahmin hatası: %s', exc, exc_info=True)
        return jsonify(error='Tahmin yapılamadı'), 500
    return jsonify(hastalikAdi=pred, olasilik=float(proba), eslesen_semptom_sayisi=len(syms))

@app.route('/train-model', methods=['POST'])
def retrain():
    if df is None:
        return jsonify(error='Veri seti yüklenemedi'), 500
    texts, labels = prepare_data(df)
    model, vectorizer, disease_labels = train_model(texts, labels)
    return jsonify(success=True, classes=len(disease_labels))

# ============ Run ============
if __name__ == '__main__':
    logger.info('Sunucu başlatılıyor…')
    app.run(host='0.0.0.0', port=8000, debug=True, threaded=True)
