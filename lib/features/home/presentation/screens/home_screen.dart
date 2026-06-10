import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../game/presentation/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.tealGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Imagem do Akinator Branco
                Center(
                  child: SizedBox(
                    height: 240,
                    child: Image.asset(
                      'assets/images/akinator_white.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Título "Gênio Professor"
                Text(
                  'Genio Professor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Subtítulo
                const Text(
                  'O genio mais inteligente da faculdade!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 36),
                // Card de instrução com visual premium (Glassmorphic)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.cardBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Pense em um professor da faculdade Biopark...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Professores disponíveis: Fabiane, Jefferson Speck, Jhoni, Willian, Guilherme Alves, Marcos Guido, Letícia, Jeferson Vorpagel, André Dorr, Renato, Marcel, Hiago, Wander, Alan, Fabiano.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Botão Começar estilizado e moderno com gradiente e glow
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.magicGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Comecar!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
