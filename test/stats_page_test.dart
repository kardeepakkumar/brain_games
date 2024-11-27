import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:brain_games/views/stats_page.dart';

void main() {
  setUp(() async {
  // Initialize Hive in a test environment
    await setUpTestHive();

    // Open a mock Hive box for stats
    final statsBox = await Hive.openBox('stats');

    // Populate mock data for testing in the correct format
    // Format: List of strings "timeInSeconds:ISO8601Date"
    statsBox.add({
      'game': '2048',
      'time': '00:01:02',
      'date': '2025-01-02',
    });
  });


  tearDown(() async {
    await tearDownTestHive();
  });

  group('Stats Page', () {
    testWidgets('displays stats for 2048', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StatsPage()));

      // Verify stats list is displayed
      expect(find.textContaining('00:01:02').hitTestable(), findsOneWidget); // Adjust '1' to test specific rank, time, or date text
      expect(find.textContaining('2025-01-02').hitTestable(), findsOneWidget); // Adjust '1' to test specific rank, time, or date text
    });

    testWidgets('displays "No stats available" when no stats are present', (WidgetTester tester) async {
      // Clear mock data
      final statsBox = Hive.box('stats');
      statsBox.clear();

      await tester.pumpWidget(const MaterialApp(home: StatsPage()));

      // Verify no stats message is shown
      expect(find.text('No stats available.'), findsOneWidget);
    });
  });
}
