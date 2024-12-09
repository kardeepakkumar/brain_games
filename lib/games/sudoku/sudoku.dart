import 'dart:math';

import 'package:brain_games/core/abstract_game.dart';
import 'package:brain_games/utils/grid.dart';

class Sudoku extends Game{
  late List<List<int>> solutionGrid;
  late List<List<int>> puzzleGrid;
  late List<List<int>> currentGrid;
  late String level;

  Sudoku(String level) {
    _generateFullGrid();
    if (level == "Easy") {
      _generatePuzzleGrid(25);
    } else if (level == "Medium") {
      _generatePuzzleGrid(35);
    } else if (level == "Hard") {
      _generatePuzzleGrid(45);
    } else if (level == "Ultra") {
      _generatePuzzleGrid(81);
    }
    currentGrid = Grid.cloneGrid(puzzleGrid);
  }

  List<List<int>> get getPuzzleGrid => puzzleGrid;
  void setPuzzleGridVal(int val, int row, int col) {
    puzzleGrid[row][col] = val;
  }

  void setCurrentGridVal(int val, int row, int col) {
    currentGrid[row][col] = val;
  }

  void _generateFullGrid() {
    solutionGrid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(solutionGrid, 0);
  }

  void _generatePuzzleGrid(int emptyCells) {
    if (emptyCells < 0 || emptyCells > 81) {
      throw ArgumentError("Invalid number of empty cells: $emptyCells");
    }

    puzzleGrid = solutionGrid.map((row) => List<int>.from(row)).toList();

    Random rand = Random();
    int removedCells = 0;

    Set<String> visited = {};

    while (removedCells < emptyCells) {
      int row = rand.nextInt(9);
      int col = rand.nextInt(9);

      String key = '$row,$col';
      if (visited.contains(key)) continue;

      visited.add(key);

      if (visited.length == 81) break;

      if (puzzleGrid[row][col] != 0) {
        int temp = puzzleGrid[row][col];
        puzzleGrid[row][col] = 0;

        if (_hasUniqueSolution(puzzleGrid)) {
          removedCells++;
        } else {
          puzzleGrid[row][col] = temp;
        }
      }
    }


    if (_hasUniqueSolution(puzzleGrid)) {
      return;
    } else {
      _generateFullGrid();
      throw Exception("Unable to generate a uniquely solvable Sudoku puzzle with $emptyCells empty cells.");
    }


  }

  bool _fillGrid(List<List<int>> grid, int cur) {
    while (cur < 81 && grid[cur~/9][cur%9] != 0) {
      cur++;
    }
    if (cur == 81) return true;
    int row = cur~/9;
    int col = cur%9;
    List<int> numbers = List.generate(9, (index) => index + 1)..shuffle();
    for (int num in numbers) {
      if (_isValidPoint(grid, row, col, num)) {
        grid[row][col] = num;
        if (_fillGrid(grid, cur + 1)) {
          return true;
        }
        grid[row][col] = 0;
      }
    }
    return false;
  }

  bool _hasUniqueSolution(List<List<int>> grid) {
    int solutionCount = 0;

    bool solve(List<List<int>> grid) {
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (grid[row][col] == 0) {
            for (int num = 1; num <= 9; num++) {
              if (_isValidPoint(grid, row, col, num)) {
                grid[row][col] = num;
                if (solve(grid)) solutionCount++;
                grid[row][col] = 0;
              }
              if (solutionCount > 1) return false;
            }
            return false;
          }
        }
      }
      return true;
    }

    solve(grid);
    return solutionCount == 1;
  }

  bool _isValidPoint(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num || grid[i][col] == num || 
          grid[row ~/ 3 * 3 + i ~/ 3][col ~/ 3 * 3 + i % 3] == num) {
        return false;
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
    return Grid.areGridsEqual(currentGrid, solutionGrid);
  }

}
