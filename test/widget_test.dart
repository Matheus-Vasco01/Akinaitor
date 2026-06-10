import 'package:flutter_test/flutter_test.dart';
import 'package:aknaitor/main.dart';

void main() {
  testWidgets('Akanitor app loads and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AkanitorApp());

    // Verify that the home screen details are present.
    expect(find.text('Genio Professor'), findsOneWidget);
    expect(find.text('Comecar!'), findsOneWidget);
  });
}
