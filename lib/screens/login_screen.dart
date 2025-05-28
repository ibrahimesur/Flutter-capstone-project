import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _tcKimlikNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tcKimlikNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Aktif olan herhangi bir input elementinin odağını kaldır (Web için faydalı olabilir)
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      // Backend URL'sini web için 127.0.0.1:8000 olarak ayarlıyoruz
      // Android emülatörü için 10.0.2.2:8000 kullanılması gerekir
      final url = Uri.parse('http://127.0.0.1:8000/login');
      
      String userType;
      String identifier;
      String emailToSend = '';

      switch (_tabController.index) {
        case 0: // Hasta
          userType = 'patient';
          identifier = _tcKimlikNoController.text;
          emailToSend = _emailController.text;
          break;
        case 1: // Doktor
          userType = 'doctor';
          identifier = _emailController.text;
          break;
        case 2: // Hastane Yönetimi
          userType = 'hospital_admin';
          identifier = _emailController.text;
          break;
        default:
          userType = 'patient';
          identifier = _tcKimlikNoController.text;
          emailToSend = _emailController.text;
      }

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'identifier': identifier,
            'email': emailToSend,
            'password': _passwordController.text,
            'user_type': userType,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print('Giriş başarılı: ${responseData['message']}');
          
          // Başarılı hasta girişi durumunda hasta ID'sini kaydet
          if (userType == 'patient') {
             // Backend'den dönen yanıtın yapısını kontrol edin.
             // Backend login endpoint'i artık başarılı hasta girişinde 'hasta_id'yi döndürüyor.
             final String? receivedHastaId = responseData['hasta_id'];

             if (receivedHastaId != null) {
               final prefs = await SharedPreferences.getInstance();
               await prefs.setString('hasta_id', receivedHastaId); // Hasta ID'sini 'hasta_id' anahtarıyla kaydedin
               print('Hasta ID SharedPreferences\'a kaydedildi: $receivedHastaId');
             } else {
               print('Login başarılı ama backend hasta ID\'si döndürmedi.');
               // Kullanıcıya bilgi verilebilir veya bir hata loglanabilir.
             }
          }

          // Sekme durumuna göre yönlendirme
          switch (_tabController.index) {
            case 0: // Hasta
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1: // Doktor
              Navigator.pushReplacementNamed(context, '/doctor-dashboard');
              break;
            case 2: // Hastane Yönetimi
              Navigator.pushReplacementNamed(context, '/hospital-dashboard');
              break;
          }
        } else if (response.statusCode == 401) {
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı hatası: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: HealthApp.accentColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: HealthApp.accentColor,
              tabs: const [
                Tab(text: 'Hasta Girişi'),
                Tab(text: 'Doktor Girişi'),
                Tab(text: 'Hastane Yönetimi'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPatientLoginForm(),
                  _buildDoctorLoginForm(),
                  _buildHospitalLoginForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hasta Girişi',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Devam etmek için giriş yapın',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _tcKimlikNoController,
              decoration: const InputDecoration(
                labelText: 'TC Kimlik No',
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              maxLength: 11,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'TC Kimlik No gerekli';
                }
                if (value.length != 11) {
                  return 'TC Kimlik No 11 haneli olmalıdır';
                }
                if (!RegExp(r'^[0-9]+').hasMatch(value)) {
                  return 'TC Kimlik No sadece rakamlardan oluşmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hesabınız yok mu?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Üye Olun'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Doktor Girişi',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Devam etmek için giriş yapın',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Doktor ID',
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Doktor ID gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hesabınız yok mu?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Üye Olun'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hastane Yönetimi Girişi',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Devam etmek için giriş yapın',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Hastane ID',
                prefixIcon: Icon(Icons.business),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hastane ID gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hesabınız yok mu?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Üye Olun'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
