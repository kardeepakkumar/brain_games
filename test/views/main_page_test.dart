import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:brain_games/views/main_page.dart';

void main() {
  group('MainPage loads: ', () {
    testWidgets('MainPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainPage()));
      expect(find.text('View Stats'), findsOneWidget);
      expect(find.text('2048'), findsOneWidget);
      expect(find.text('Sudoku'), findsOneWidget);
      expect(find.text('Memory Match'), findsOneWidget);
    });
  });
}