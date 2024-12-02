import 'dart:math';

class SudokuGenerator {
  final int gridSize = 9;
  final int subGridSize = 3;

  List<List<int>> generateFullGrid() {
    List<List<int>> grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    _fillGrid(grid);
    return grid;
  }

  List<List<int>> generatePuzzle(int emptyCells) {
    List<List<int>> grid = generateFullGrid();

    for (int i = 0; i < emptyCells; i++) {
      int row, col;
      do {
        row = Random().nextInt(gridSize);
        col = Random().nextInt(gridSize);
      } while (grid[row][col] == 0);

      grid[row][col] = 0;
    }

    return grid;
  }

  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col] == 0) {
          List<int> numbers = List.generate(gridSize, (index) => index + 1)..shuffle();

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
    for (int i = 0; i < gridSize; i++) {
      if (grid[row][i] == num || grid[i][col] == num) return false;
    }

    int startRow = row - row % subGridSize;
    int startCol = col - col % subGridSize;

    for (int i = 0; i < subGridSize; i++) {
      for (int j = 0; j < subGridSize; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }

    return true;
  }
}
