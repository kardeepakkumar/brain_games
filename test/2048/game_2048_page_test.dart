import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:brain_games/views/games/game_2048_page.dart';

void main() {

  group('Game2048Page loads: ', () {
    testWidgets('GamePage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      expect(find.text('2048'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('Game2048Page timer works: ', () {
    testWidgets('GamePage counts time correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final timerDisplay = find.byKey(const Key('timer_display'));
      var timerText = (tester.widget<Text>(timerDisplay)).data!;
      expect(timerText, "Time: 00:00:00");
      await tester.pump(const Duration(seconds: 2));
      timerText = (tester.widget<Text>(timerDisplay)).data!;
      expect(["Time: 00:00:01", "Time: 00:00:02"], contains(timerText));
      final refreshButton = find.byIcon(Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();
      timerText = (tester.widget<Text>(timerDisplay)).data!;
      expect(timerText, "Time: 00:00:00");
    });
  });

  group('Game2048Page refreshes: ', () {
    testWidgets('refresh button replaces the current Game2048Page with a new one', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final state = tester.state(find.byType(Game2048Page)) as Game2048PageState;
      state.game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      await tester.pump();
      await tester.fling(
        find.byKey(const Key('swipe_detector')),
        const Offset(-100, 0),
        500
      );

      expect(find.byType(Game2048Page), findsOneWidget);

      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      expect(find.byType(Game2048Page), findsOneWidget);
      int nonZeroCount = state.game.grid.fold(
          0,
          (sum, row) => sum + row.where((cell) => cell != 0).length,
        );
      expect(nonZeroCount, 2);
    });
  });

  group('Game2048Page swipes correctly: ', () {
    testWidgets('Swipe left triggers move', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final state = tester.state(find.byType(Game2048Page)) as Game2048PageState;
      state.game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      await tester.pump();
      await tester.fling(
        find.byKey(const Key('swipe_detector')),
        const Offset(-100, 0),
        500
      );
      await tester.pumpAndSettle();

      int nonZeroCount = state.game.grid.fold(
          0,
          (sum, row) => sum + row.where((cell) => cell != 0).length,
        );
      expect(state.game.grid[0][0], 4);
      expect(nonZeroCount, 2);
    });

    testWidgets('Swipe up triggers move', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final state = tester.state(find.byType(Game2048Page)) as Game2048PageState;
      state.game.grid = [
        [2, 0, 0, 0],
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      await tester.pump();
      await tester.fling(
        find.byKey(const Key('swipe_detector')),
        const Offset(0, -100),
        500
      );
      await tester.pumpAndSettle();

      int nonZeroCount = state.game.grid.fold(
          0,
          (sum, row) => sum + row.where((cell) => cell != 0).length,
        );
      expect(state.game.grid[0][0], 4);
      expect(nonZeroCount, 2);
    });

    testWidgets('Swipe right triggers move', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final state = tester.state(find.byType(Game2048Page)) as Game2048PageState;
      state.game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      await tester.pump();
      await tester.fling(
        find.byKey(const Key('swipe_detector')),
        const Offset(100, 0),
        500
      );
      await tester.pumpAndSettle();

      int nonZeroCount = state.game.grid.fold(
          0,
          (sum, row) => sum + row.where((cell) => cell != 0).length,
        );
      expect(state.game.grid[0][3], 4);
      expect(nonZeroCount, 2);
    });

    testWidgets('Swipe down triggers move', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Game2048Page()));
      final state = tester.state(find.byType(Game2048Page)) as Game2048PageState;
      state.game.grid = [
        [2, 0, 0, 0],
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      await tester.pump();
      await tester.fling(
        find.byKey(const Key('swipe_detector')),
        const Offset(0, 100),
        500
      );
      await tester.pumpAndSettle();

      int nonZeroCount = state.game.grid.fold(
          0,
          (sum, row) => sum + row.where((cell) => cell != 0).length,
        );
      expect(state.game.grid[3][0], 4);
      expect(nonZeroCount, 2);
    });

  });
}
