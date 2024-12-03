import 'package:brain_games/views/stats_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    final statsBox = await Hive.openBox('stats');
    statsBox.add({
      'game': '2048',
      'time': '00:01:02',
      'date': '2025-01-02',
    });
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('Game2048StatsPage ', () {
    testWidgets('displays stats for 2048', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StatsGamePage(gameTitle: '2048')));
      expect(find.textContaining('00:01:02').hitTestable(), findsOneWidget);
      expect(find.textContaining('2025-01-02').hitTestable(), findsOneWidget);
    });

    testWidgets('displays "No stats available" when no stats are present', (WidgetTester tester) async {
      final statsBox = Hive.box('stats');
      await tester.runAsync(() => statsBox.clear());
      await tester.pumpWidget(const MaterialApp(home: StatsGamePage(gameTitle: '2048')));
      expect(find.text('No stats available.'), findsOneWidget);
    });
  });
}