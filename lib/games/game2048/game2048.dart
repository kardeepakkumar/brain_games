import 'dart:core';
import 'dart:math';

import 'package:brain_games/core/abstract_game.dart';

class Game2048 extends Game {
  final int _gridSize = 4;
  late List<List<int>> _grid;

  int get getGridSize => _gridSize;
  int gridVal(int row, int col) => _grid[row][col];

  List<List<int>> get grid => _grid;
  set grid(List<List<int>> newGrid) {
    if (newGrid.length == _gridSize &&
        newGrid.every((row) => row.length == _gridSize)) {
      _grid = newGrid;
    } else {
      throw ArgumentError('Grid dimensions must match gridSize ($_gridSize x $_gridSize).');
    }
  }

  Game2048() {
    _grid = List.generate(_gridSize, (_) => List.filled(_gridSize, 0));
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    final emptyTiles = getEmptyTiles();
    if (emptyTiles.isNotEmpty) {
      final randomTile = emptyTiles[Random().nextInt(emptyTiles.length)];
      _grid[randomTile['row']!][randomTile['col']!] = Random().nextBool() ? 2 : 4;
    }
  }
  
  List<Map<String, int>> getEmptyTiles() {
    final emptyTiles = <Map<String, int>>[];
    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (_grid[r][c] == 0) {
          emptyTiles.add({'row': r, 'col': c});
        }
      }
    }
    return emptyTiles;
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

  List<List<int>> _cloneGrid(List<List<int>> grid) {
    return grid.map<List<int>>((row) => List<int>.from(row)).toList();
  }
  
  void _moveUp() {
    for (int col = 0; col < _gridSize; col++) {
      List<int> column = List.generate(_gridSize, (row) => _grid[row][col]);
      column = _mergeLine(column);
      for (int row = 0; row < _gridSize; row++) {
        _grid[row][col] = column[row];
      }
    }
  }

  void _moveDown() {
    for (int col = 0; col < _gridSize; col++) {
      List<int> column = List.generate(_gridSize, (row) => _grid[row][col]);
      column = _mergeLine(column.reversed.toList()).reversed.toList();
      for (int row = 0; row < _gridSize; row++) {
        _grid[row][col] = column[row];
      }
    }
  }

  void _moveLeft() {
    for (int row = 0; row < _gridSize; row++) {
      _grid[row] = _mergeLine(_grid[row]);
    }
  }

  void _moveRight() {
    for (int row = 0; row < _gridSize; row++) {
      _grid[row] = _mergeLine(_grid[row].reversed.toList()).reversed.toList();
    }
  }

  List<int> _mergeLine(List<int> line) {
    List<int> newLine = List.filled(_gridSize, 0);
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


  bool _areGridsEqual(List<List<int>> grid1, List<List<int>> grid2) {
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (grid1[i][j] != grid2[i][j]) return false;
      }
    }
    return true;
  }

  @override
  bool isGameOver() {
    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (isPlayableAt(r, c)) return false;
      }
    }
    return true;
  }

  bool isPlayableAt(int r, int c) {
    return ((_grid[r][c] == 0) ||
    (r < _gridSize - 1 && _grid[r][c] == _grid[r + 1][c]) ||
    (c < _gridSize - 1 && _grid[r][c] == _grid[r][c + 1]));
  }

  @override
  bool isGameWon() {
    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (_grid[r][c] == 32) {
          return true;
        }
      }
    }
    return false;
  }
  
}