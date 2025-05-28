import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tcKimlikNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _tcKimlikNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üye Ol'),
        backgroundColor: HealthApp.accentColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Hasta Kaydı'),
            Tab(text: 'Doktor Kaydı'),
            Tab(text: 'Hastane Yönetimi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegisterForm('Hasta'),
          _buildRegisterForm('Doktor'),
          _buildRegisterForm('Hastane Yönetimi'),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(String userType) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$userType Hesabı Oluştur',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: HealthApp.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sağlık hizmetlerine erişmek için üye olun',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad Soyad gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (userType == 'Hasta')
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
                )
              else
                TextFormField(
                  controller: _tcKimlikNoController,
                  decoration: InputDecoration(
                    labelText: userType == 'Doktor' ? 'Doktor ID' : 'Hastane ID',
                    prefixIcon: const Icon(Icons.business),
                    hintText: userType == 'Doktor' ? 'Örn: DR12345' : 'Örn: HST789',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${userType == 'Doktor' ? 'Doktor' : 'Hastane'} ID gerekli';
                    }
                    if (userType == 'Doktor' && !value.startsWith('DR')) {
                      return 'Doktor ID "DR" ile başlamalıdır';
                    }
                    if (userType == 'Hastane Yönetimi' && !value.startsWith('HST')) {
                      return 'Hastane ID "HST" ile başlamalıdır';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta gerekli';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi girin';
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
                  if (value.length < 6) {
                    return 'Şifre en az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre Tekrar',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre tekrarı gerekli';
                  }
                  if (value != _passwordController.text) {
                    return 'Şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HealthApp.accentColor,
                  foregroundColor: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Üye Ol',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Zaten hesabınız var mı?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Giriş Yapın'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    const String apiUrl = 'http://127.0.0.1:8000/register';

    // Seçili sekmeye göre kullanıcı tipini ve gönderilecek kimlik bilgisini belirle
    String userType;
    String? tcKimlikNoToSend = null;
    String? institutionalIdToSend = null;

    switch (_tabController.index) {
      case 0: // Hasta
        userType = 'patient';
        tcKimlikNoToSend = _tcKimlikNoController.text;
        break;
      case 1: // Doktor
        userType = 'doctor';
        institutionalIdToSend = _tcKimlikNoController.text; // Doktor ID'si için aynı controller kullanılıyor
        break;
      case 2: // Hastane Yönetimi
        userType = 'hospital_admin';
        institutionalIdToSend = _tcKimlikNoController.text; // Hastane ID'si için aynı controller kullanılıyor
        break;
      default:
        // Bu duruma düşmemeli ama fallback olarak hasta diyelim
        userType = 'patient';
        tcKimlikNoToSend = _tcKimlikNoController.text;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'name': _nameController.text,
          'tc_kimlik_no': tcKimlikNoToSend,
          'institutional_id': institutionalIdToSend,
          'email': _emailController.text,
          'password': _passwordController.text,
          'user_type': userType,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kullanıcı başarıyla kaydedildi! Giriş sayfasına yönlendiriliyorsunuz...'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        final responseData = jsonDecode(response.body);
        // Backend'den gelen mesajı daha anlaşılır göstermek için kontrol
        String errorMessage = 'Kayıt başarısız';
        if (responseData != null && responseData['message'] != null) {
          errorMessage = 'Kayıt başarısız: ${responseData['message']}';
        } else if (responseData != null && responseData['error'] != null) {
           errorMessage = 'Kayıt başarısız: ${responseData['error']}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt sırasında bir hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
