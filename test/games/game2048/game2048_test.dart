import 'package:brain_games/games/game2048/game2048.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Game2048 initialisation: ', () {
    test('Initial grid is empty except for two cells', () {
      final game = Game2048();
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );
      expect(nonZeroCount, 2);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });
  });

  group('Game2048 moves: ', () {
    test('Move left merges tiles correctly', () {
      final game = Game2048();
      game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      game.move('left');
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );
      expect(game.grid[0][0], 4);
      expect(nonZeroCount, 2);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Move right merges tiles correctly', () {
      final game = Game2048();
      game.grid = [
        [2, 2, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      game.move('right');
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );
      expect(game.grid[0][3], 4);
      expect(nonZeroCount, 2);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Move up merges tiles correctly', () {
      final game = Game2048();
      game.grid = [
        [2, 0, 0, 0],
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      game.move('up');
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );
      expect(game.grid[0][0], 4);
      expect(nonZeroCount, 2);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Move down merges tiles correctly', () {
      final game = Game2048();
      game.grid = [
        [2, 0, 0, 0],
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      game.move('down');
      int nonZeroCount = game.grid.fold(
        0,
        (sum, row) => sum + row.where((cell) => cell != 0).length,
      );
      expect(game.grid[3][0], 4);
      expect(nonZeroCount, 2);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

  });

  group('Game2048 states: ', () {

    test('Game detects game over correctly case A', () {
      final game = Game2048();
      game.grid = [
        [2, 4, 8, 16],
        [16, 8, 4, 2],
        [2, 4, 8, 16],
        [16, 8, 4, 2],
      ];
      expect(game.isGameOver(), true);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Game detects game over correctly case B', () {
      final game = Game2048();
      game.grid = [
        [4, 4, 8, 16],
        [16, 8, 4, 2],
        [2, 4, 8, 16],
        [16, 8, 4, 2],
      ];
      expect(game.isGameOver(), false);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Game detects game won correctly case A', () {
      final game = Game2048();
      game.grid = [
        [2, 4, 8, 16],
        [16, 128, 4, 2],
        [32, 4, 8, 2048],
        [16, 8, 4, 2],
      ];
      expect(game.isGameWon(), true);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });

    test('Game detects game won correctly case B', () {
      final game = Game2048();
      game.grid = [
        [4, 4, 8, 16],
        [16, 8, 4, 2],
        [2, 4, 8, 16],
        [16, 8, 4, 2],
      ];
      expect(game.isGameWon(), false);
      expect((game.isGameWon() || game.isGameOver()) == game.isGameEnded(), true);
    });
  });
}
