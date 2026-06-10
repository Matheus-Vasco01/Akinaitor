import '../models/akinator_models.dart';

class AkinatorEngine {
  AkinatorEngine({
    required List<TeacherProfile> teachers,
    required List<AkinatorQuestion> questions,
  })  : _allTeachers = List<TeacherProfile>.unmodifiable(teachers),
        _allQuestions = List<AkinatorQuestion>.unmodifiable(questions) {
    reset();
  }

  final List<TeacherProfile> _allTeachers;
  final List<AkinatorQuestion> _allQuestions;

  final List<AnsweredQuestion> _answeredQuestions = [];
  final Set<String> _rejectedTeacherNames = <String>{};

  List<TeacherProfile> _possibleTeachers = const [];
  List<AkinatorQuestion> _remainingQuestions = const [];
  AkinatorQuestion? _currentQuestion;
  TeacherProfile? _finalGuess;
  bool _checkmate = false;

  AkinatorQuestion? get currentQuestion => _currentQuestion;
  TeacherProfile? get finalGuess => _finalGuess;
  List<AnsweredQuestion> get answeredQuestions =>
      List<AnsweredQuestion>.unmodifiable(_answeredQuestions);
  int get possibleTeachersCount => _possibleTeachers.length;
  bool get hasGuess => _finalGuess != null;
  bool get canContinueAfterWrongGuess => _activeTeachers.length > 1;

  void reset() {
    _answeredQuestions.clear();
    _rejectedTeacherNames.clear();
    _possibleTeachers = List<TeacherProfile>.from(_allTeachers);
    _remainingQuestions = _sortQuestionsBySeparationPower(
      _allQuestions,
      _possibleTeachers,
    );
    _currentQuestion = _remainingQuestions.isEmpty ? null : _remainingQuestions.first;
    _finalGuess = null;
    _checkmate = false;
  }

  void submitAnswer(AkinatorAnswer answer) {
    final question = _currentQuestion;
    if (question == null || _finalGuess != null) {
      return;
    }

    _answeredQuestions.add(
      AnsweredQuestion(
        question: question,
        answer: answer,
      ),
    );

    _deriveState();
  }

  bool continueAfterWrongGuess() {
    final guess = _finalGuess;
    if (guess == null) {
      return false;
    }

    _rejectedTeacherNames.add(guess.name);
    _finalGuess = null;
    _checkmate = false;
    _deriveState();
    return _currentQuestion != null || _finalGuess != null;
  }

  List<TeacherProfile> get _activeTeachers {
    return _allTeachers
        .where((teacher) => !_rejectedTeacherNames.contains(teacher.name))
        .toList(growable: false);
  }

  void _deriveState() {
    final activeTeachers = _activeTeachers;
    _possibleTeachers = activeTeachers
        .where(_matchesAnsweredQuestions)
        .toList(growable: false);

    _remainingQuestions = _buildRemainingQuestions(
      _possibleTeachers,
      _allQuestions,
    );

    if (_possibleTeachers.length == 1 && _checkmate) {
      _currentQuestion = null;
      _finalGuess = _possibleTeachers.first;
      return;
    }

    if (_possibleTeachers.length == 1 && !_checkmate) {
      final unansweredUniqueQuestions = _uniqueQuestionsForTeacher(
        _possibleTeachers.first,
        activeTeachers,
        _allQuestions,
      ).where(_isQuestionPending).toList(growable: false);

      if (unansweredUniqueQuestions.isNotEmpty) {
        _checkmate = true;
        _currentQuestion = unansweredUniqueQuestions.first;
        _finalGuess = null;
        return;
      }
    }

    if (_remainingQuestions.isEmpty) {
      _currentQuestion = null;
      _finalGuess = _bestTeacherGuess(activeTeachers);
      return;
    }

    _currentQuestion = _remainingQuestions.first;
    _finalGuess = null;
  }

  bool _matchesAnsweredQuestions(TeacherProfile teacher) {
    for (final answered in _answeredQuestions) {
      final teacherAnswer = teacher.answerFor(answered.question.id);
      if (teacherAnswer == null) {
        return false;
      }

      if (answered.answer == AkinatorAnswer.naoSei) {
        continue;
      }

      if (answered.answer == AkinatorAnswer.provavelmenteSim) {
        if (teacherAnswer != AkinatorAnswer.sim.engineValue) {
          return false;
        }
        continue;
      }

      if (answered.answer == AkinatorAnswer.provavelmenteNao) {
        if (teacherAnswer != AkinatorAnswer.nao.engineValue) {
          return false;
        }
        continue;
      }

      if (teacherAnswer != answered.answer.engineValue) {
        return false;
      }
    }

    return true;
  }

  bool _isQuestionPending(AkinatorQuestion question) {
    for (final answered in _answeredQuestions) {
      if (answered.question.id == question.id) {
        return false;
      }
    }

    return true;
  }

  List<AkinatorQuestion> _buildRemainingQuestions(
    List<TeacherProfile> teachers,
    List<AkinatorQuestion> questions,
  ) {
    if (teachers.isEmpty) {
      return const [];
    }

    final pendingQuestions = <AkinatorQuestion>[];

    for (final question in questions) {
      if (!_isQuestionPending(question)) {
        continue;
      }

      final responses = <String>{};
      for (final teacher in teachers) {
        final teacherAnswer = teacher.answerFor(question.id);
        if (teacherAnswer != null) {
          responses.add(teacherAnswer);
        }
      }

      if (responses.length > 1) {
        pendingQuestions.add(question);
      }
    }

    return _sortQuestionsBySeparationPower(pendingQuestions, teachers);
  }

  List<AkinatorQuestion> _sortQuestionsBySeparationPower(
    List<AkinatorQuestion> questions,
    List<TeacherProfile> teachers,
  ) {
    final ranked = questions.map((question) {
      var yesCount = 0;
      for (final teacher in teachers) {
        final answer = teacher.answerFor(question.id);
        if (answer == AkinatorAnswer.sim.engineValue) {
          yesCount++;
        }
      }

      final noCount = teachers.length - yesCount;
      final difference = (yesCount - noCount).abs();
      return _RankedQuestion(
        question: question,
        difference: difference,
      );
    }).toList(growable: false);

    ranked.sort((left, right) => left.difference.compareTo(right.difference));
    return ranked.map((item) => item.question).toList(growable: false);
  }

  List<AkinatorQuestion> _uniqueQuestionsForTeacher(
    TeacherProfile teacher,
    List<TeacherProfile> teachers,
    List<AkinatorQuestion> questions,
  ) {
    final uniqueQuestions = <AkinatorQuestion>[];

    for (final teacherAnswer in teacher.answers) {
      if (teacherAnswer.answer != AkinatorAnswer.sim.engineValue) {
        continue;
      }

      var yesCount = 0;
      for (final item in teachers) {
        if (item.answerFor(teacherAnswer.questionId) == AkinatorAnswer.sim.engineValue) {
          yesCount++;
        }
      }

      if (yesCount != 1) {
        continue;
      }

      for (final question in questions) {
        if (question.id == teacherAnswer.questionId) {
          uniqueQuestions.add(question);
          break;
        }
      }
    }

    return uniqueQuestions;
  }

  TeacherProfile? _bestTeacherGuess(List<TeacherProfile> teachers) {
    if (teachers.isEmpty) {
      return null;
    }

    TeacherProfile? bestTeacher;
    var bestScore = -1;

    for (final teacher in teachers) {
      var score = 0;

      for (final answered in _answeredQuestions) {
        final teacherAnswer = teacher.answerFor(answered.question.id);
        if (teacherAnswer == null) {
          continue;
        }

        if (teacherAnswer == answered.answer.engineValue) {
          score += 2;
          continue;
        }

        if (answered.answer == AkinatorAnswer.naoSei) {
          continue;
        }

        if (teacherAnswer == AkinatorAnswer.sim.engineValue &&
            answered.answer == AkinatorAnswer.provavelmenteSim) {
          score += 1;
          continue;
        }

        if (teacherAnswer == AkinatorAnswer.nao.engineValue &&
            answered.answer == AkinatorAnswer.provavelmenteNao) {
          score += 1;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestTeacher = teacher;
      }
    }

    return bestTeacher;
  }
}

class _RankedQuestion {
  const _RankedQuestion({
    required this.question,
    required this.difference,
  });

  final AkinatorQuestion question;
  final int difference;
}
