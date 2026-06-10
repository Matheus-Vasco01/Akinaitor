import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum GameState { playing, guessing, wrongChoice, victory }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState _state = GameState.playing;
  int _questionIndex = 1;

  final List<String> _questions = [
    'Esse professor usa muito quadro ou lousa nas aulas?',
    'Esse professor ensina desenvolvimento Mobile com Flutter?',
    'Esse professor diz que HTML nao e linguagem de programacao?',
    'Esse professor toma cafe em caneca com estampa de codigo?',
    'Esse professor reclama de chaves ou ponto e virgula esquecidos?',
    'Esse professor fala muito sobre ponteiros ou alocacao de memoria?',
    'Esse professor ja trabalhou desenvolvendo sistemas legados em COBOL?',
    'Esse professor prefere usar o terminal ao inves de IDEs visuais?',
    'Esse professor passa trabalhos praticos com prazos quase impossiveis?',
    'Esse professor ensina a criar consultas complexas em SQL?',
  ];

  void _answerQuestion(String answer) {
    if (_questionIndex == 5 && _state == GameState.playing) {
      setState(() {
        _state = GameState.guessing;
      });
    } else if (_questionIndex < _questions.length) {
      setState(() {
        _questionIndex++;
      });
    } else {
      setState(() {
        _state = GameState.guessing;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _state = GameState.playing;
      _questionIndex = 1;
    });
  }

  void _continueGame() {
    if (_questionIndex < _questions.length) {
      setState(() {
        _questionIndex++;
        _state = GameState.playing;
      });
    } else {
      _resetGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.tealGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case GameState.playing:
        return _buildPlayingState();
      case GameState.guessing:
        return _buildGuessingState();
      case GameState.wrongChoice:
        return _buildWrongChoiceState();
      case GameState.victory:
        return _buildVictoryState();
    }
  }

  Widget _buildPlayingState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Imagem do gênio no topo (Guaxinim ou Detetive)
        Center(
          child: SizedBox(
            height: 160,
            child: Image.asset(
              _questionIndex <= 5
                  ? 'assets/images/raccoon_questions.png'
                  : 'assets/images/detective_questions.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Card unificado com número, pergunta e opções
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Círculo azul com o número da pergunta (Sleek Circular Badge)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_questionIndex',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Texto da Pergunta
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _questions[_questionIndex - 1],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.cardBorder, height: 1.5, thickness: 1.5),
              // Opções de Resposta
              _buildOption('Sim', () => _answerQuestion('Sim')),
              const Divider(color: AppColors.cardBorder, height: 1),
              _buildOption('Nao', () => _answerQuestion('Não')),
              const Divider(color: AppColors.cardBorder, height: 1),
              _buildOption('Nao sei', () => _answerQuestion('Não sei')),
              const Divider(color: AppColors.cardBorder, height: 1),
              _buildOption('Provavelmente sim', () => _answerQuestion('Provavelmente sim')),
              const Divider(color: AppColors.cardBorder, height: 1),
              _buildOption('Provavelmente nao', () => _answerQuestion('Provavelmente não'), isLast: true),
            ],
          ),
        ),
        const Spacer(),
        // Botão para voltar ao início
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary, size: 18),
          label: const Text(
            'Voltar ao inicio',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildOption(String label, VoidCallback onTap, {bool isLast = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              )
            : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuessingState() {
    final bool isFirstGuess = _questionIndex <= 5;
    final String guessTitle = isFirstGuess ? 'Professor de Algoritmos' : 'Professor de Banco de Dados';
    final String guessDesc = isFirstGuess
        ? 'Te ensina Portugol e faz voce escrever codigo em folha de papel almaco.'
        : 'Explica a terceira forma normal e diz que tudo na vida e um relacionamento de muitos para muitos.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Imagem central (Guaxinim ou Detetive)
        Center(
          child: SizedBox(
            height: 200,
            child: Image.asset(
              _questionIndex <= 5
                  ? 'assets/images/raccoon_questions.png'
                  : 'assets/images/detective_questions.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Card de Palpite
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Estou pensando em...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                guessTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                guessDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Acertei?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Botões Sim e Não
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _state = GameState.victory;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.answerYes,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Sim!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _state = GameState.wrongChoice;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.answerNo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Errou!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildWrongChoiceState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Imagem central (Akinator Roxo)
        Center(
          child: SizedBox(
            height: 200,
            child: Image.asset(
              'assets/images/akinator_purple.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Card de Opções pós-erro
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'O que deseja fazer agora?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              // Botão Continuar
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.magicGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  onPressed: _continueGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continuar as perguntas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Botão Encerrar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.answerNo, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Encerrar partida',
                    style: TextStyle(
                      color: AppColors.answerNo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildVictoryState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Imagem do Akinator Feliz na vitória
        Center(
          child: SizedBox(
            height: 220,
            child: Image.asset(
              'assets/images/akinator_success.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Card de Vitória
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Eu sou genial!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nenhum professor escapa da minha mente brilhante!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              // Botão Jogar Novamente
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.magicGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Jogar Novamente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
