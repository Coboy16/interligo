import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Azul sólido profesional (inspira confianza)
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primarySoft = Color(0xFFEFF6FF);

  // Secondary - Azul oscuro elegante
  static const Color secondary = Color(0xFF1E293B);
  static const Color secondaryLight = Color(0xFF334155);
  static const Color secondaryDark = Color(0xFF0F172A);

  // Accent - Verde profesional para éxito
  static const Color accent = Color(0xFF059669);
  static const Color accentLight = Color(0xFF10B981);

  // Neutral - Tonos grises y blancos (clean & minimal)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Semantic
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF1A56DB);

  // Card specific - colores sólidos para tarjetas
  static const Color cardFrozen = Color(0xFF64748B);
  static const Color cardActive = Color(0xFF1A56DB);
  static const Color cardVisa = Color(0xFF1A1F71);
  static const Color cardMastercard = Color(0xFF0A0A0A);

  // Transactions
  static const Color income = Color(0xFF059669);
  static const Color expense = Color(0xFFDC2626);

  // Dividers & Borders
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Legacy gradient support (minimizar uso)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A56DB), Color(0xFF1A56DB)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A56DB), Color(0xFF1E3A8A)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A56DB), Color(0xFF1A56DB)],
  );
}
