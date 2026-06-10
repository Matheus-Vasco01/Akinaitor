import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum GameState { playing, guessing, wrongChoice, victory }

class Professor {
  final String name;
  final String subject;
  final String description;

  const Professor({
    required this.name,
    required this.subject,
    required this.description,
  });
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState _state = GameState.playing;
  int _questionIndex = 1;
  final List<String> _userAnswers = [];
  Professor? _guessedProfessor;

  final List<Professor> _professores = const [
    Professor(
      name: 'Fabiane',
      subject: 'Coordenadora',
      description: 'Lidera o curso com maestria, resolve todos os pepinos e organiza as diretrizes do semestre.',
    ),
    Professor(
      name: 'Jefferson Speck',
      subject: 'Mobile',
      description: 'Adora criar apps responsivos, ensina Flutter/Kotlin e fala sobre o ciclo de vida das views.',
    ),
    Professor(
      name: 'Jeferson Bigode',
      subject: 'IA (Inteligencia Artificial)',
      description: 'Manja tudo de Redes Neurais, Machine Learning, Visao Computacional e algoritmos inteligentes.',
    ),
    Professor(
      name: 'Andre Dorr',
      subject: 'Teste de Software',
      description: 'Garante a qualidade do codigo, ensina testes unitarios e odeia bugs em producao.',
    ),
    Professor(
      name: 'Renato',
      subject: 'Projeto Integrador',
      description: 'Orienta o desenvolvimento dos projetos reais juntando todas as materias do semestre.',
    ),
    Professor(
      name: 'Marcel',
      subject: 'Empreendedorismo',
      description: 'Te ensina a criar startups, planejar modelos de negocio Canvas e fazer pitchs matadores.',
    ),
    Professor(
      name: 'Hiago',
      subject: 'Gestao de Projetos',
      description: 'Planeja escopo, cronogramas, metodologias ageis (Scrum/Kanban) e evita atrasos de entrega.',
    ),
    Professor(
      name: 'Alan',
      subject: 'Engenharia de Requisitos',
      description: 'Define as regras do sistema, escreve casos de uso e alinha o software com o cliente.',
    ),
    Professor(
      name: 'Wander',
      subject: 'Manutencao de Computadores',
      description: 'Desvenda o hardware, ensina a montar circuitos, arrumar PCs e entender a arquitetura.',
    ),
    Professor(
      name: 'Willian',
      subject: 'Banco de Dados',
      description: 'Domina queries SQL, modelagem de dados relacionais e fala sobre Normalizacao e Triggers.',
    ),
    Professor(
      name: 'Guilherme Alves',
      subject: 'Micro Servicos',
      description: 'Especialista em arquiteturas distribuidas, APIs REST escalaveis e Docker.',
    ),
    Professor(
      name: 'Marcos Guido',
      subject: 'Redes de Computadores',
      description: 'Decifra pacotes TCP/IP, roteamento, subredes e mantem a internet da faculdade funcionando.',
    ),
    Professor(
      name: 'Leticia',
      subject: 'Versionamento',
      description: 'Mestra do Git, resolve conflitos de merge de olhos fechados e ensina Git Flow.',
    ),
    Professor(
      name: 'Fabiano',
      subject: 'Leis de Lehman',
      description: 'Explica a evolucao e o envelhecimento dos sistemas de software pelas leis de Lehman.',
    ),
  ];

  final List<String> _questions = const [
    'Esse professor ensina sobre Git, Merges e Versionamento?',
    'Esse professor ministra aulas focadas em Desenvolvimento Mobile?',
    'Esse professor e especialista em Inteligencia Artificial (IA)?',
    'Esse professor ensina sobre Banco de Dados, Queries SQL e Tabelas?',
    'Essa pessoa e a Coordenadora Geral do curso?',
    'Esse professor explica sobre Redes, Protocolos e Pacotes TCP/IP?',
    'Esse professor foca em Testes de Software e Garantia de Qualidade (QA)?',
    'Esse professor fala sobre Evolucao de Software e Leis de Lehman?',
    'Esse professor ensina sobre Micro Servicos, Docker ou APIs escalaveis?',
    'Esse professor trata de Requisitos, Casos de Uso e regras de negocio?',
  ];

  void _answerQuestion(String answer) {
    _userAnswers.add(answer);

    if (_questionIndex == 5 && _state == GameState.playing) {
      _calculateGuess();
      setState(() {
        _state = GameState.guessing;
      });
    } else if (_questionIndex < _questions.length) {
      setState(() {
        _questionIndex++;
      });
    } else {
      _calculateGuess();
      setState(() {
        _state = GameState.guessing;
      });
    }
  }

  void _calculateGuess() {
    int matchedIndex = -1;
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] == 'Sim' || _userAnswers[i] == 'Provavelmente sim') {
        matchedIndex = i;
        break;
      }
    }

    if (matchedIndex != -1) {
      switch (matchedIndex) {
        case 0:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Leticia');
          break;
        case 1:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Jefferson Speck');
          break;
        case 2:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Jeferson Bigode');
          break;
        case 3:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Willian');
          break;
        case 4:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Fabiane');
          break;
        case 5:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Marcos Guido');
          break;
        case 6:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Andre Dorr');
          break;
        case 7:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Fabiano');
          break;
        case 8:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Guilherme Alves');
          break;
        case 9:
          _guessedProfessor = _professores.firstWhere((p) => p.name == 'Alan');
          break;
      }
    } else {
      final fallbacks = ['Renato', 'Marcel', 'Hiago', 'Wander'];
      final fallbackName = fallbacks[_userAnswers.length % fallbacks.length];
      _guessedProfessor = _professores.firstWhere((p) => p.name == fallbackName);
    }
  }

  void _resetGame() {
    setState(() {
      _state = GameState.playing;
      _questionIndex = 1;
      _userAnswers.clear();
      _guessedProfessor = null;
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
    final String guessName = _guessedProfessor?.name ?? 'Professor';
    final String guessSubject = _guessedProfessor?.subject ?? 'Materia';
    final String guessDesc = _guessedProfessor?.description ?? 'Descricao do professor.';

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
                guessName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Professor(a) de $guessSubject',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
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
