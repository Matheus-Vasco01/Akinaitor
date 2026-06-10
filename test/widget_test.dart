import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:aknaitor/main.dart';

void main() {
  testWidgets('Akanitor app loads and shows home screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(const AkanitorApp());
    await tester.pumpAndSettle();

    expect(find.text('Genio Professor'), findsOneWidget);
    expect(find.text('Comecar!'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
