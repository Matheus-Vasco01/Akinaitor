import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/floating_widget.dart';
import '../../../../core/widgets/pixel_background.dart';
import '../../../../core/widgets/pixel_container.dart';
import '../../../game/presentation/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PixelBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Imagem do Akinator Pixel com efeito de flutuar
              Center(
                child: SizedBox(
                  height: 220,
                  child: FloatingWidget(
                    child: Image.asset(
                      'assets/images/genie_happy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Título "GENIO CRAFT"
              Text(
                'GENIO CRAFT',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              // Subtítulo
              Text(
                'QUAL PROFESSOR DE ADS VOCE PENSOU?',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Card de instrução retro
              PixelContainer(
                backgroundColor: Colors.white,
                borderColor: AppColors.primary,
                borderWidth: 3.0,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.vt323(
                          fontSize: 22,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'Pense em um '),
                          TextSpan(
                            text: 'professor de ADS',
                            style: GoogleFonts.vt323(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const TextSpan(text: ' do seu curso...'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pode ser o de Logica que adora fluxograma, o de Banco de Dados viciado em SQL, ou o de Redes que so fala em roteador!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Botão JOGAR retro
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'JOGAR',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
