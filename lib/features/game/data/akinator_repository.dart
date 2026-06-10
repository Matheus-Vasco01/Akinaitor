import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/akinator_models.dart';

class AkinatorRepository {
  const AkinatorRepository();

  Future<AkinatorData> load() async {
    final teachersJson = await rootBundle.loadString(
      'assets/json/professores.json',
    );
    final questionsJson = await rootBundle.loadString(
      'assets/json/perguntas.json',
    );

    final teachers = (jsonDecode(teachersJson) as List<dynamic>)
        .map((item) => _normalizeTeacher(item as Map<String, dynamic>))
        .map(TeacherProfile.fromJson)
        .toList(growable: false);

    final questions = (jsonDecode(questionsJson) as List<dynamic>)
        .map((item) => _normalizeQuestion(item as Map<String, dynamic>))
        .map(AkinatorQuestion.fromJson)
        .toList(growable: false);

    return AkinatorData(
      teachers: teachers,
      questions: questions,
    );
  }

  Map<String, dynamic> _normalizeTeacher(Map<String, dynamic> json) {
    final answers = (json['perguntas'] as List<dynamic>)
        .map((item) => item as Map<String, dynamic>)
        .map(
          (item) => {
            'id': item['id'] as String,
            'resposta': _normalizeText(item['resposta'] as String),
          },
        )
        .toList(growable: false);

    return {
      'nome': _normalizeText(json['nome'] as String),
      'perguntas': answers,
    };
  }

  Map<String, dynamic> _normalizeQuestion(Map<String, dynamic> json) {
    return {
      'id': json['id'] as String,
      'pergunta': _normalizeText(json['pergunta'] as String),
    };
  }

  String _normalizeText(String value) {
    if (!value.contains('Ã') && !value.contains('Â')) {
      return value;
    }

    try {
      return utf8.decode(latin1.encode(value));
    } on FormatException {
      return value;
    }
  }
}
