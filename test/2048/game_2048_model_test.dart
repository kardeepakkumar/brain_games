import 'package:flutter_test/flutter_test.dart';
import 'package:brain_games/models/2048/game.dart';

void main() {
  group('Game2048', () {
    test('Initial grid is empty except for two cells', () {
      final game = Game2048(gridSize: 4);

      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );

      expect(nonZeroCount, 2);
    });

    test('Move merges tiles correctly', () {
      final game = Game2048(gridSize: 4);

      game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];

      game.move('left');

      expect(game.grid[0][0], 4);
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );

      expect(nonZeroCount, 2);
    });

    test('Game detects game over correctly', () {
      final game = Game2048(gridSize: 4);

      game.grid = [
        [2, 4, 8, 16],
        [16, 8, 4, 2],
        [2, 4, 8, 16],
        [16, 8, 4, 2],
      ];

      expect(game.isGameOver(), true);
    });

    test('Game detects game won correctly', () {
      final game = Game2048(gridSize: 4);

      game.grid = [
        [2, 4, 8, 16],
        [16, 128, 4, 2],
        [2, 4, 8, 2048],
        [16, 8, 4, 2],
      ];

      expect(game.isGameOver(), true);
    });
  });
}
