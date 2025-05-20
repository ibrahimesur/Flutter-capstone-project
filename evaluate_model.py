import os
import csv
import joblib
import pandas as pd
from collections import Counter
from sklearn.metrics import accuracy_score, f1_score, classification_report
from sklearn.feature_extraction.text import TfidfVectorizer

# --- Yollar ---
BASE_DIR   = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_DIR, "backend", "models",
                          "disease_prediction_model.joblib")
DATASET    = os.path.join(BASE_DIR, "Datasets",
                          "Disease and symptoms dataset.csv")

# ---------- CSV'yi oku (app.py'deki ile aynı mantık) ----------
def load_dataset(path):
    for sep in [',', ';', '\t']:
        try:
            df = pd.read_csv(path, sep=sep, engine="python",
                             quoting=csv.QUOTE_NONE, encoding="utf-8-sig")
            df.columns = [c.strip().strip('"').strip("'") for c in df.columns]
            if "diseases" in df.columns:
                print(f"✓ CSV {len(df):,} satır, sep='{sep}'")
                return df
        except Exception as exc:
            print(f"sep='{sep}' okunamadı → {exc}")
    raise ValueError("'diseases' sütunu bulunamadı")

def prepare_data(df: pd.DataFrame):
    texts, labels = [], []
    for _, row in df.iterrows():
        disease = str(row.get("diseases", "")).strip()
        if not disease:
            continue
        symptoms = [
            col.lower()
            for col in df.columns
            if col != "diseases"
            and str(row.get(col, "0")).strip() not in ("0", "", "nan")
        ]
        if symptoms:
            texts.append(" ".join(symptoms))
            labels.append(disease)
    return texts, labels

# ---------- Veriyi hazırla ----------
df = load_dataset(DATASET)
texts, labels = prepare_data(df)
print("Hazır örnek sayısı:", len(labels))

# ---------- Modeli yükle ----------
if not os.path.exists(MODEL_PATH):
    raise FileNotFoundError("Model dosyası yok: " + MODEL_PATH)

model = joblib.load(MODEL_PATH)
print("Model yüklendi ― sınıf sayısı:", len(model.classes_))

# ---------- Tahmin & metrikler ----------
y_pred = model.predict(texts)
acc    = accuracy_score(labels, y_pred)
f1m    = f1_score(labels, y_pred, average="macro")

print(f"\nAccuracy : {acc:.4f}")
print(f"F1-macro : {f1m:.4f}")
print("\nİlk 20 sınıf için rapor:")
print(classification_report(labels, y_pred,
                            labels=model.classes_[:20],
                            zero_division=0)[:800])
