import 'package:aknaitor/features/game/domain/models/akinator_models.dart';
import 'package:aknaitor/features/game/domain/services/akinator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AkinatorEngine', () {
    test('gera um palpite quando resta apenas um professor compativel', () {
      final engine = AkinatorEngine(
        teachers: [
          const TeacherProfile(
            name: 'Ana',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'SIM'),
              TeacherAnswer(questionId: '2', answer: 'NAO'),
            ],
          ),
          const TeacherProfile(
            name: 'Bia',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'NAO'),
              TeacherAnswer(questionId: '2', answer: 'SIM'),
            ],
          ),
          const TeacherProfile(
            name: 'Caio',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'NAO'),
              TeacherAnswer(questionId: '2', answer: 'NAO'),
            ],
          ),
        ],
        questions: const [
          AkinatorQuestion(id: '1', text: 'Pergunta 1'),
          AkinatorQuestion(id: '2', text: 'Pergunta 2'),
        ],
      );

      expect(engine.currentQuestion?.id, '1');

      engine.submitAnswer(AkinatorAnswer.sim);

      expect(engine.finalGuess?.name, 'Ana');
      expect(engine.hasGuess, isTrue);
    });

    test('usa pontuacao para responder quando a resposta e aproximada', () {
      final engine = AkinatorEngine(
        teachers: [
          const TeacherProfile(
            name: 'Ana',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'SIM'),
            ],
          ),
          const TeacherProfile(
            name: 'Bia',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'NAO'),
            ],
          ),
        ],
        questions: const [
          AkinatorQuestion(id: '1', text: 'Pergunta 1'),
        ],
      );

      engine.submitAnswer(AkinatorAnswer.provavelmenteSim);

      expect(engine.finalGuess?.name, 'Ana');
      expect(engine.possibleTeachersCount, 1);
    });

    test('elimina o palpite errado e continua investigando', () {
      final engine = AkinatorEngine(
        teachers: [
          const TeacherProfile(
            name: 'Ana',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'SIM'),
            ],
          ),
          const TeacherProfile(
            name: 'Bia',
            answers: [
              TeacherAnswer(questionId: '1', answer: 'NAO'),
            ],
          ),
        ],
        questions: const [
          AkinatorQuestion(id: '1', text: 'Pergunta 1'),
        ],
      );

      engine.submitAnswer(AkinatorAnswer.provavelmenteSim);

      expect(engine.finalGuess?.name, 'Ana');
      expect(engine.canContinueAfterWrongGuess, isTrue);

      final hasMoreContent = engine.continueAfterWrongGuess();

      expect(hasMoreContent, isTrue);
      expect(engine.finalGuess?.name, 'Bia');
    });
  });
}
