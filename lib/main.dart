import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/doctor_panel/doctor_panel_screen.dart';
import 'screens/semptom_tarama_screen.dart';

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
        '/doctor-panel': (context) => const DoctorPanelScreen(),
        '/semptom-tarama': (context) => Scaffold(
              appBar: AppBar(title: Text('Semptom Tarama')),
              body: SemptomTaramaScreen(),
            ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: primaryColor,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: secondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: primaryColor),
          prefixIconColor: primaryColor,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFFBFD4E8), // secondaryColor.withOpacity(0.3)
          selectedColor: primaryColor,
          labelStyle: TextStyle(color: primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[400],
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          final args = settings.arguments as Map<String, dynamic>?;
          int initialTab = 0;
          if (args != null && args['initialTab'] != null) {
            initialTab = args['initialTab'] as int;
          }
          return MaterialPageRoute(
            builder: (context) => HomeScreen(initialTab: initialTab),
            settings: settings,
          );
        }
        // ... diğer route'lar ...
      },
    );
  }
}
