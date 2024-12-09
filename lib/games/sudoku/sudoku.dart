import 'dart:math';

import 'package:brain_games/core/abstract_game.dart';
import 'package:brain_games/utils/grid.dart';

class Sudoku extends Game{
  late List<List<int>> solutionGrid;
  late List<List<int>> puzzleGrid;
  late List<List<int>> currentGrid;
  late String level;

  Sudoku(String level) {
    solutionGrid = _generateFullGrid();
    if (level == "Easy") {
      puzzleGrid = _generatePuzzleGrid(10);
    } else if (level == "Medium") {
      puzzleGrid = _generatePuzzleGrid(20);
    } else if (level == "Hard") {
      puzzleGrid = _generatePuzzleGrid(30);
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

  List<List<int>> _generateFullGrid() {
    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid, 0);
    return grid;
  }

  List<List<int>> _generatePuzzleGrid(int emptyCells) {
    List<List<int>> grid = Grid.cloneGrid(solutionGrid);
    for (int i = 0; i < emptyCells; i++) {
      int row, col;
      do {
        row = Random().nextInt(9);
        col = Random().nextInt(9);
      } while (grid[row][col] == 0);

      grid[row][col] = 0;
    }
    return grid;
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

  bool _isValidPoint(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
        if (grid[i][col] == num) return false;
        if (grid[row][i] == num) return false;
        int subGridRowIdx = 3*(row~/3) + i~/3;
        int subGridColIdx = 3*(col~/3) + i%3;
        if (grid[subGridRowIdx][subGridColIdx] == num) return false;
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
