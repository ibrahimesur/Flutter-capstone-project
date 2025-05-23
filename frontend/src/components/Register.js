import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Register() {
  const [tcKimlikNo, setTcKimlikNo] = useState('');
  const [password, setPassword] = useState('');
  const [passwordRepeat, setPasswordRepeat] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (password !== passwordRepeat) {
      setMessage('Şifreler eşleşmiyor!');
      return;
    }

    // Backend modelimiz şimdilik hem TC Kimlik No hem de e-posta bekliyor.
    // E-posta alanını kaldırdığımız için backend'e geçici bir değer göndereceğiz veya
    // backend'i sadece TC Kimlik No ile çalışacak şekilde güncellememiz gerekecek.
    // Şimdilik backend'in e-posta ihtiyacını karşılamak için TC Kimlik No'yu e-posta olarak gönderiyoruz.
    // NOT: Bu geçici bir çözümdür ve backend modelinin güncellenmesi idealdir.

    try {
      const response = await axios.post('http://127.0.0.1:5000/register', {
        tc_kimlik_no: tcKimlikNo,
        email: `${tcKimlikNo}@example.com`, // Geçici e-posta değeri
        password: password,
      });
      setMessage(response.data.message);
      // Kayıt başarılı olursa giriş sayfasına yönlendir
      if (response.status === 201) {
          setTimeout(() => {
              navigate('/login');
          }, 2000); // 2 saniye sonra yönlendir
      }
    } catch (error) {
      setMessage(error.response?.data?.message || 'Kayıt başarısız.');
    }
  };

  return (
    <div>
      <h2>Kullanıcı Kayıt</h2>
      <form onSubmit={handleSubmit}>
        {/* Ad Soyad alanı görselde var, ancak backend modelimizde yoktu.
            Şimdilik atlıyoruz. İhtiyaç olursa backend'e eklememiz gerekir.
        <div>
          <label>Ad Soyad:</label>
          <input
            type="text"
            // state ve handler eklemeniz gerekir
            required
          />
        </div>
        */}
        <div>
          <label>TC Kimlik No:</label>
          <input
            type="text"
            value={tcKimlikNo}
            onChange={(e) => setTcKimlikNo(e.target.value)}
            required
            maxLength="11" // 11 hane sınırı
          />
        </div>
        {/* E-posta alanı kaldırıldı */}
        <div>
          <label>Şifre:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Şifre Tekrar:</label>
           <input
            type="password"
            value={passwordRepeat}
            onChange={(e) => setPasswordRepeat(e.target.value)}
            required
          />
        </div>
         {/* Doktor olarak kayıt ol checkbox'ı görselde var, ancak backend'de rol yönetimi yoktu.
             Şimdilik atlıyoruz. İhtiyaç olursa backend ve frontend'e eklememiz gerekir.
         <div>
             <input type="checkbox" id="doctor" name="doctor" />
             <label for="doctor">Doktor olarak kayıt ol</label>
         </div>
         */}
        <button type="submit">Kaydol</button>
      </form>
      {message && <p>{message}</p>}
    </div>
  );
}

export default Register; 