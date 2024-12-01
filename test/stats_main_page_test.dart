import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:brain_games/views/stats/stats_main_page.dart';

void main() {
  group('StatsMainPage loads: ', () {
    testWidgets('StatsMainPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StatsMainPage()));
      expect(find.text('Stats'), findsOneWidget);
      expect(find.text('2048'), findsOneWidget);
      expect(find.text('Memory Match (Coming Soon)'), findsOneWidget);
    });
  });
}