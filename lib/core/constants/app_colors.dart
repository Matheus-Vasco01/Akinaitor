import 'package:flutter/material.dart';

class AppColors {
  // Cores de fundo Premium (Space Teal/Dark Navy)
  static const Color background = Color(0xFF07171E);
  static const Color backgroundDark = Color(0xFF030A0D);

  // Fundo dos Cards (Efeito Glassmorphism de alta fidelidade)
  static const Color cardBg = Color(0xFF0C2530);
  static const Color cardBorder = Color(0xFF163E4D);

  // Compatibilidade
  static const Color surface = cardBg;
  static const Color border = cardBorder;

  // Neon Cyan / Electric Blue (Ações primárias)
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF0097A7);
  static const Color accent = Color(0xFF00B0FF);

  // Botões de Ação na Tela de Palpite
  static const Color answerYes = Color(0xFF00E676);
  static const Color answerNo = Color(0xFFFF1744);

  // Textos
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF98BCC7);

  // Gradientes Premium
  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF0D2834), Color(0xFF051218)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient magicGradient = LinearGradient(
    colors: [primary, Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = tealGradient;
}
