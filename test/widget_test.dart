import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets(
    'Muestra la pantalla de bienvenida de ExploraEC',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ExploraEcApp());

      expect(find.text('ExploraEC'), findsOneWidget);
      expect(
        find.text('Descubre y guarda lugares cerca de ti'),
        findsOneWidget,
      );
      expect(find.text('Empezar'), findsOneWidget);
    },
  );
}