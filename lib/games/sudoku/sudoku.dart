import 'dart:math';

import 'package:brain_games/core/abstract_game.dart';

class Sudoku extends Game{
  final int _gridSize = 9;
  final int _subGridSize = 3;
  late List<List<int>> solutionGrid;
  late List<List<int>> puzzleGrid;

  Sudoku() {
    solutionGrid = _generateFullGrid();
    puzzleGrid = _generatePuzzleGrid(1);
  }

  List<List<int>> get getPuzzleGrid => puzzleGrid;
  void setPuzzleGridVal(int val, int row, int col) {
    puzzleGrid[row][col] = val;
  }

  List<List<int>> _generateFullGrid() {
    List<List<int>> grid = List.generate(_gridSize, (_) => List.filled(_gridSize, 0));
    _fillGrid(grid);
    return grid;
  }

  List<List<int>> _generatePuzzleGrid(int emptyCells) {
    List<List<int>> grid = _cloneGrid(solutionGrid);

    for (int i = 0; i < emptyCells; i++) {
      int row, col;
      do {
        row = Random().nextInt(_gridSize);
        col = Random().nextInt(_gridSize);
      } while (grid[row][col] == 0);

      grid[row][col] = 0;
    }

    return grid;
  }

  List<List<int>> _cloneGrid(List<List<int>> grid) {
    return grid.map<List<int>>((row) => List<int>.from(row)).toList();
  }

  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < _gridSize; row++) {
      for (int col = 0; col < _gridSize; col++) {
        if (grid[row][col] == 0) {
          List<int> numbers = List.generate(_gridSize, (index) => index + 1)..shuffle();

          for (int num in numbers) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;

              if (_fillGrid(grid)) {
                return true;
              }

              grid[row][col] = 0;
            }
          }

          return false;
        }
      }
    }

    return true;
  }

  bool _isValid(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < _gridSize; i++) {
      if (grid[row][i] == num || grid[i][col] == num) return false;
    }

    int startRow = row - row % _subGridSize;
    int startCol = col - col % _subGridSize;

    for (int i = 0; i < _subGridSize; i++) {
      for (int j = 0; j < _subGridSize; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }

    return true;
  }
  
  @override
  bool isGameOver() {
    return false;
  }
  
  @override
  bool isGameWon() {
    return _areGridsEqual(puzzleGrid, solutionGrid);
  }

  bool _areGridsEqual(List<List<int>> grid1, List<List<int>> grid2) {
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (grid1[i][j] != grid2[i][j]) return false;
      }
    }
    return true;
  }

}
