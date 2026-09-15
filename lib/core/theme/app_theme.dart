import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs de la marque - Bleu Dolibarr & Ardoise
  static const Color primaryBlue = Color(0xFF003366);      // Bleu foncé principal Dolibarr
  static const Color primaryLight = Color(0xFF1E6091);     // Bleu d'accentuation plus clair
  static const Color accentCyan = Color(0xFF00B4D8);       // Cyan moderne
  
  static const Color backgroundLight = Color(0xFFF8FAFC);  // Fond d'écran très clair
  static const Color surfaceLight = Color(0xFFFFFFFF);     // Blanc des cartes
  
  static const Color textPrimary = Color(0xFF0F172A);      // Ardoise foncé (Textes principaux)
  static const Color textSecondary = Color(0xFF64748B);    // Ardoise moyen (Sous-titres)
  static const Color textMuted = Color(0xFF94A3B8);        // Ardoise clair (Textes d'aide)

  // Couleurs de statut
  static const Color statusSuccess = Color(0xFF10B981);    // Vert émeraude (Validé / Payé)
  static const Color statusWarning = Color(0xFFF59E0B);    // Ambre (Brouillon / En attente)
  static const Color statusError = Color(0xFFEF4444);      // Rouge (Annulé / En retard)
  static const Color statusInfo = Color(0xFF3B82F6);       // Bleu (En cours / Actif)

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentCyan,
        surface: surfaceLight,
        error: statusError,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusError),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
      ),
    );
  }
}
