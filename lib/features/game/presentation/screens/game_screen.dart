import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/floating_widget.dart';
import '../../../../core/widgets/pixel_background.dart';
import '../../../../core/widgets/pixel_container.dart';
import '../../data/akinator_repository.dart';
import '../../domain/models/akinator_models.dart';
import '../../domain/services/akinator_engine.dart';

enum GameState { playing, guessing, wrongChoice, victory }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AkinatorRepository _repository = const AkinatorRepository();

  GameState _state = GameState.playing;
  AkinatorEngine? _engine;
  bool _isLoading = true;
  String? _errorMessage;

  String? _getTeacherImage(String? name) {
    if (name == null) return null;
    final lowercaseName = name.toLowerCase();
    if (lowercaseName.contains('jefferson speck')) {
      return 'assets/images/jefferson_speck.jpg';
    } else if (lowercaseName.contains('jeferson vorpagel') || lowercaseName.contains('vorpagel')) {
      return 'assets/images/jeferson_vorpagel.jpg';
    } else if (lowercaseName.contains('willian')) {
      return 'assets/images/willian.png';
    } else if ((lowercaseName.contains('fabiane') || lowercaseName == 'fabi') && !lowercaseName.contains('fabiano')) {
      return 'assets/images/fabi.jpg';
    } else if (lowercaseName.contains('letícia') || lowercaseName.contains('leticia')) {
      return 'assets/images/leticia.jpg';
    } else if (lowercaseName.contains('andré dorr') || lowercaseName.contains('andre dorr')) {
      return 'assets/images/andre_dorr.jpg';
    } else if (lowercaseName.contains('hiago')) {
      return 'assets/images/hiago.jpg';
    } else if (lowercaseName.contains('guilherme alves')) {
      return 'assets/images/guilherme_alves.jpg';
    } else if (lowercaseName.contains('vander')) {
      return 'assets/images/vander.jpg';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.load();
      if (!mounted) {
        return;
      }

      setState(() {
        _engine = AkinatorEngine(
          teachers: data.teachers,
          questions: data.questions,
        );
        _state = GameState.playing;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Nao foi possivel carregar as perguntas e professores.';
        _isLoading = false;
      });
    }
  }

  void _answerQuestion(AkinatorAnswer answer) {
    final engine = _engine;
    if (engine == null || engine.currentQuestion == null) {
      return;
    }

    engine.submitAnswer(answer);

    setState(() {
      _state = engine.hasGuess ? GameState.guessing : GameState.playing;
    });
  }

  void _resetGame() {
    final engine = _engine;
    if (engine == null) {
      return;
    }

    engine.reset();
    setState(() {
      _state = GameState.playing;
    });
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PixelBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return _buildContent();
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 20),
          Text(
            'Preparando as perguntas...',
            style: GoogleFonts.pressStart2p(
              color: AppColors.primary,
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: PixelContainer(
        backgroundColor: Colors.white,
        borderColor: AppColors.primary,
        borderWidth: 3.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Erro inesperado.',
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                color: AppColors.textSecondary,
                fontSize: 20,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loadGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  'TENTAR NOVAMENTE',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPlayingState() {
    final engine = _engine;
    final question = engine?.currentQuestion;
    if (engine == null || question == null) {
      return _buildErrorState();
    }

    final answeredQuestions = engine.answeredQuestions;
    final questionIndex = answeredQuestions.length + 1;

    return Column(
      children: [
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            height: 140,
            child: FloatingWidget(
              child: Image.asset(
                'assets/images/genie_happy.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        PixelContainer(
          backgroundColor: AppColors.questionBg,
          borderColor: AppColors.questionBorder,
          borderWidth: 3.5,
          tagText: 'PERGUNTA $questionIndex',
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var index = 0; index < AkinatorAnswer.values.length; index++)
                  _buildOption(
                    AkinatorAnswer.values[index].label,
                    () => _answerQuestion(AkinatorAnswer.values[index]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '<- VOLTAR AO INICIO',
            style: GoogleFonts.pressStart2p(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 2.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.vt323(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFCF9F7),
          side: const BorderSide(color: Color(0xFFF0ECE9), width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.vt323(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGuessingState() {
    final engine = _engine;
    final guessedTeacher = engine?.finalGuess;
    final customImage = _getTeacherImage(guessedTeacher?.name);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: SizedBox(
            height: 200,
            child: customImage != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: Image.asset(
                      customImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : FloatingWidget(
                    child: Image.asset(
                      'assets/images/genie_happy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        PixelContainer(
          backgroundColor: Colors.white,
          borderColor: AppColors.primary,
          borderWidth: 3.0,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Estou pensando em...',
                style: GoogleFonts.vt323(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                guessedTeacher?.name ?? 'Professor misterioso',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Acertei?',
                style: GoogleFonts.vt323(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _state = GameState.victory;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          'Sim!',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _state = GameState.wrongChoice;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCF9F7),
                          side: const BorderSide(color: AppColors.primary, width: 2.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          'Errou!',
                          style: GoogleFonts.pressStart2p(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
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
        Center(
          child: SizedBox(
            height: 160,
            child: Image.asset(
              'assets/images/genie_confused.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 24),
        PixelContainer(
          backgroundColor: Colors.white,
          borderColor: AppColors.primary,
          borderWidth: 3.0,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VOCE ME PEGOU!',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Deu erro 404 na minha mente... Na proxima eu compilo certo!',
                textAlign: TextAlign.center,
                style: GoogleFonts.vt323(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'JOGAR DE NOVO',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '<- VOLTAR AO INICIO',
            style: GoogleFonts.pressStart2p(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildVictoryState() {
    final guessedTeacher = _engine?.finalGuess?.name ?? 'Professor';
    final answeredCount = _engine?.answeredQuestions.length ?? 0;
    final customImage = _getTeacherImage(guessedTeacher);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: SizedBox(
            height: 180,
            child: customImage != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: Image.asset(
                      customImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : FloatingWidget(
                    child: Image.asset(
                      'assets/images/genie_happy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        PixelContainer(
          backgroundColor: Colors.white,
          borderColor: AppColors.primary,
          borderWidth: 3.0,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EU SOU GENIAL!',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Voce estava pensando em $guessedTeacher.',
                textAlign: TextAlign.center,
                style: GoogleFonts.vt323(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoBadge(
                icon: Icons.question_answer_rounded,
                label: '$answeredCount respostas',
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'JOGAR NOVAMENTE',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '<- VOLTAR AO INICIO',
            style: GoogleFonts.pressStart2p(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
