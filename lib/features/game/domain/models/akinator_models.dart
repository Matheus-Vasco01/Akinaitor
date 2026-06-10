import 'package:flutter/foundation.dart';

enum AkinatorAnswer {
  sim('Sim', 'SIM'),
  provavelmenteSim('Provavelmente sim', 'PROVAVELMENTE SIM'),
  naoSei('Nao sei', 'NAO SEI'),
  nao('Nao', 'NAO'),
  provavelmenteNao('Provavelmente nao', 'PROVAVELMENTE NAO');

  const AkinatorAnswer(this.label, this.engineValue);

  final String label;
  final String engineValue;
}

@immutable
class TeacherAnswer {
  const TeacherAnswer({
    required this.questionId,
    required this.answer,
  });

  factory TeacherAnswer.fromJson(Map<String, dynamic> json) {
    return TeacherAnswer(
      questionId: json['id'] as String,
      answer: json['resposta'] as String,
    );
  }

  final String questionId;
  final String answer;
}

@immutable
class TeacherProfile {
  const TeacherProfile({
    required this.name,
    required this.answers,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    final answers = (json['perguntas'] as List<dynamic>)
        .map((item) => TeacherAnswer.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    return TeacherProfile(
      name: json['nome'] as String,
      answers: answers,
    );
  }

  final String name;
  final List<TeacherAnswer> answers;

  String? answerFor(String questionId) {
    for (final item in answers) {
      if (item.questionId == questionId) {
        return item.answer;
      }
    }

    return null;
  }
}

@immutable
class AkinatorQuestion {
  const AkinatorQuestion({
    required this.id,
    required this.text,
  });

  factory AkinatorQuestion.fromJson(Map<String, dynamic> json) {
    return AkinatorQuestion(
      id: json['id'] as String,
      text: json['pergunta'] as String,
    );
  }

  final String id;
  final String text;
}

@immutable
class AnsweredQuestion {
  const AnsweredQuestion({
    required this.question,
    required this.answer,
  });

  final AkinatorQuestion question;
  final AkinatorAnswer answer;
}

@immutable
class AkinatorData {
  const AkinatorData({
    required this.teachers,
    required this.questions,
  });

  final List<TeacherProfile> teachers;
  final List<AkinatorQuestion> questions;
}
