import 'package:brain_games/core/abstract_game_page.dart';
import 'package:flutter/material.dart';

import 'package:brain_games/games/sudoku/sudoku.dart';

class SudokuPage extends GamePage {
  const SudokuPage({super.key});

  @override
  SudokuPageState createState() => SudokuPageState();

}

class SudokuPageState extends GamePageState {

  late int selectedRow;
  late int selectedCol;

  @override
  void initGame() {
    setGameTitle = "sudoku";
    setGame = Sudoku();
    selectedRow = -1;
    selectedCol = -1;
  }

  @override
  SudokuPage gameBuilder() {
    return const SudokuPage();
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
          selectedRow = row;
          selectedCol = col;
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
            : (getGame as Sudoku).getPuzzleGrid[row][col] == 0
                ? Colors.white
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
