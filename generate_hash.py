import bcrypt

# Kullanmak istediğiniz yeni şifreyi buraya yazın
# Lütfen bu satırdaki "BURAYA_GERCEK_SIFREYI_GIRIN" kısmını doktor hesabı için belirlediğiniz gerçek şifre ile değiştirin.
password_to_hash = "123qwe"

# Şifreyi hashle
hashed_bytes = bcrypt.hashpw(password_to_hash.encode('utf-8'), bcrypt.gensalt())

# Hash'i string olarak al
hashed_string = hashed_bytes.decode('utf-8')

print("Oluşturulan bcrypt hash'i:")
print(hashed_string) 