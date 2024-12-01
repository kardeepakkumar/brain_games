import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:brain_games/views/games/game_2048_page.dart';

void main() {
  testWidgets('GamePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Game2048Page()));

    expect(find.text('2048'), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });

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

    expect(state.game.grid[0][0], 4);
    int nonZeroCount = state.game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );

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

    expect(state.game.grid[0][0], 4);
    int nonZeroCount = state.game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );

      expect(nonZeroCount, 2);
  });
}
