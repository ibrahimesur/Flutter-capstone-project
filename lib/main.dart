import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/doctor_panel/doctor_panel_screen.dart';
import 'screens/hospital_panel/hospital_panel_screen.dart';
import 'screens/semptom_tarama_screen.dart';
import 'widgets/appointment_booking_modal.dart';

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  // Mavi Tema Renkleri
  static const primaryColor = Color(0xFF2C3E50); // Koyu lacivert
  static const secondaryColor = Color(0xFF3498DB); // Açık mavi
  static const backgroundColor = Color(0xFFECF0F1); // Açık gri
  static const accentColor = Color(0xFF2980B9); // Orta mavi

  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sağlık Yönetim Sistemi',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/doctor-dashboard': (context) => const DoctorPanelScreen(),
        '/hospital-dashboard': (context) => const HospitalPanelScreen(),
        '/appointment': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final initialDepartment = args?['department'] as String?;
          return Scaffold(
            appBar: AppBar(title: const Text('Randevu Ayarlama')),
            body: Center(),
          );
        },
        '/semptom-tarama': (context) => Scaffold(
              appBar: AppBar(title: const Text('Semptom Tarama')),
              body: const SemptomTaramaScreen(),
            ),
      },
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          labelStyle: const TextStyle(color: primaryColor),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: primaryColor,
                displayColor: primaryColor,
              ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFFBFD4E8),
          selectedColor: primaryColor,
          labelStyle: TextStyle(color: primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[400],
        ),
      ),
    );
  }
}
