import 'package:brain_games/core/abstract_game_page.dart';
import 'package:flutter/material.dart';

import 'package:brain_games/games/sudoku/sudoku.dart';

class SudokuPage extends GamePage {
  final String level;

  const SudokuPage({super.key, required this.level});

  @override
  SudokuPageState createState() => SudokuPageState();

}

class SudokuPageState extends GamePageState {
  late final String level;
  late int selectedRow;
  late int selectedCol;
  late List<List<bool>> affectedCells;

  @override
  void initGame() {
    setGameTitle = "sudoku";
    setGame = Sudoku((widget as SudokuPage).level);
    _setSelectedAndAffectedCells(-1, -1);
  }

  void _setSelectedAndAffectedCells(int row, int col) {
    selectedRow = row;
    selectedCol = col;
    affectedCells = List.generate(9, (_) => List.generate(9, (_) => false));
    if ((row == -1) || (col == -1)) return;
    for (int i = 0; i < 9; i++) {
      affectedCells[i][col] = true;
      affectedCells[row][i] = true;
      int subGridRowIdx = 3*(row~/3) + i~/3;
      int subGridColIdx = 3*(col~/3) + i%3;
      affectedCells[subGridRowIdx][subGridColIdx] = true;
    }
    affectedCells[row][col] = false;
  }


  @override
  SudokuPage gameBuilder() {
    return SudokuPage(level: (widget as SudokuPage).level);
  }

  @override
  Widget gameBoard() {
    return _gameBoard();
  }

  Widget _gameBoard() {
    if ((getGame as Sudoku).getPuzzleGrid.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    else {
      return _sudokuBody();
    }
  }

  Widget _sudokuBody() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [_sudokuGridDisplay(), _sudokuKeypadDisplay()],),
      ),
    );
  }

  Expanded _sudokuGridDisplay() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1.0,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;
          double mainSpacing = (row % 3 == 2) ? 0 : 0;
          double crossSpacing = (col % 3 == 2) ? 0 : 0;

          return Container(
            margin: EdgeInsets.only(
              bottom: mainSpacing,
              right: crossSpacing,
            ),
            child: _buildCell(row, col),
          );
        },
      ),
    );
  }

Widget _buildCell(int row, int col) {
  return GestureDetector(
    onTap: () {
      if ((getGame as Sudoku).getPuzzleGrid[row][col] == 0) {
        setState(() {
          _setSelectedAndAffectedCells(row, col);
        });
      }
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: row % 3 == 0 ? 2.0 : 1.0,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: row % 3 == 2 ? 2.0 : 1.0,
          ),
          left: BorderSide(
            color: Colors.black,
            width: col % 3 == 0 ? 2.0 : 1.0,
          ),
          right: BorderSide(
            color: Colors.black,
            width: col % 3 == 2 ? 2.0 : 1.0,
          ),
        ),
        color: selectedRow == row && selectedCol == col
            ? Colors.blue.shade100
            : affectedCells[row][col]
                ? Colors.orange
                : const Color.fromARGB(255, 244, 244, 244),
      ),
      child: Center(
        child: Text(
          (getGame as Sudoku).currentGrid[row][col] == 0
              ? ''
              : (getGame as Sudoku).currentGrid[row][col].toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

  Widget _sudokuKeypadDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          alignment: WrapAlignment.center,
          children: [
            ...List.generate(
              9,
              (index) => ElevatedButton(
                onPressed: () {
                  _onInputClick(index + 1);
                },
                child: Text('${index + 1}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _onInputClick(0);
              },
              child: const Icon(Icons.backspace),
            ),
          ],
        ),
      ],
    );
  }

  void _onInputClick(int value) {
    if (selectedCol != -1 && selectedRow != -1 && !isGameEnded()) {
      setState(() {
        (getGame as Sudoku).setCurrentGridVal(value, selectedRow, selectedCol);
        if (isGameEnded()) {
          handleGameEnd();
        }
      });
    }
  }
}
