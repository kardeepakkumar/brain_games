import 'dart:math';

class Game2048 {
  final int gridSize;
  late List<List<int>> _grid;

  Game2048({this.gridSize = 4}) {
    _initializeGrid();
  }

  List<List<int>> get grid => _grid;

  set grid(List<List<int>> newGrid) {
    if (newGrid.length == gridSize &&
        newGrid.every((row) => row.length == gridSize)) {
      _grid = newGrid;
    } else {
      throw ArgumentError('Grid dimensions must match gridSize ($gridSize x $gridSize).');
    }
  }


  void _initializeGrid() {
    _grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    final emptyTiles = <Map<String, int>>[];
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c] == 0) {
          emptyTiles.add({'row': r, 'col': c});
        }
      }
    }

    if (emptyTiles.isNotEmpty) {
      final randomTile = emptyTiles[Random().nextInt(emptyTiles.length)];
      _grid[randomTile['row']!][randomTile['col']!] = Random().nextBool() ? 2 : 4;
    }
  }

  void move(String direction) {
    List<List<int>> oldGrid = _cloneGrid(_grid);

    switch (direction) {
      case 'up':
        _moveUp();
        break;
      case 'down':
        _moveDown();
        break;
      case 'left':
        _moveLeft();
        break;
      case 'right':
        _moveRight();
        break;
    }

    if (!_areGridsEqual(oldGrid, _grid)) {
      _addRandomTile();
    }
  }

  void _moveUp() {
    for (int col = 0; col < gridSize; col++) {
      List<int> column = List.generate(gridSize, (row) => _grid[row][col]);
      column = _mergeLine(column);
      for (int row = 0; row < gridSize; row++) {
        _grid[row][col] = column[row];
      }
    }
  }

  void _moveDown() {
    for (int col = 0; col < gridSize; col++) {
      List<int> column = List.generate(gridSize, (row) => _grid[row][col]);
      column = _mergeLine(column.reversed.toList()).reversed.toList();
      for (int row = 0; row < gridSize; row++) {
        _grid[row][col] = column[row];
      }
    }
  }

  void _moveLeft() {
    for (int row = 0; row < gridSize; row++) {
      _grid[row] = _mergeLine(_grid[row]);
    }
  }

  void _moveRight() {
    for (int row = 0; row < gridSize; row++) {
      _grid[row] = _mergeLine(_grid[row].reversed.toList()).reversed.toList();
    }
  }

  List<int> _mergeLine(List<int> line) {
    List<int> newLine = List.filled(gridSize, 0);
    int insertPosition = 0;

    for (int i = 0; i < line.length; i++) {
      if (line[i] != 0) {
        if (insertPosition > 0 && newLine[insertPosition - 1] == line[i]) {
          newLine[insertPosition - 1] *= 2;
        } else {
          newLine[insertPosition] = line[i];
          insertPosition++;
        }
      }
    }
    return newLine;
  }

  List<List<int>> _cloneGrid(List<List<int>> grid) {
    return grid.map<List<int>>((row) => List<int>.from(row)).toList();
  }

  bool _areGridsEqual(List<List<int>> grid1, List<List<int>> grid2) {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid1[i][j] != grid2[i][j]) return false;
      }
    }
    return true;
  }

  bool isGameOver() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c] == 0) return false;
        if (r < gridSize - 1 && _grid[r][c] == _grid[r + 1][c]) return false;
        if (c < gridSize - 1 && _grid[r][c] == _grid[r][c + 1]) return false;
      }
    }
    return true;
  }

  bool isGameWon() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c] == 128) return true;
      }
    }
    return false;
  }
}
