import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/doctor/doctor_dashboard.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  // Renkleri static olarak tanımlayalım ki dışarıdan erişilebilinsin
  static const primaryColor = Color(0xFFE0D3F5);    // Ana pastel lila
  static const secondaryColor = Color(0xFFF0E6FF);  // Açık pastel leylak
  static const backgroundColor = Color(0xFFFAF8FF); // Çok açık lila
  static const accentColor = Color(0xFF9B8BB4);

  const HealthApp({super.key});     // Orta ton leylak

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sağlık Yönetim Sistemi',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: primaryColor.withOpacity(0.85),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
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
            foregroundColor: accentColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            borderSide: BorderSide(color: secondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: TextStyle(color: accentColor),
          prefixIconColor: accentColor,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: secondaryColor.withOpacity(0.3),
          selectedColor: primaryColor,
          labelStyle: TextStyle(color: accentColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.grey[400],
        ),
      ),
    );
  }
} 