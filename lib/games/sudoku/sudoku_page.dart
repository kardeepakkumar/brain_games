import 'package:brain_games/core/abstract_game_page.dart';
import 'package:flutter/material.dart';

import 'package:brain_games/games/sudoku/sudoku.dart';

class SudokuPage extends GamePage {
  const SudokuPage({super.key});

  @override
  SudokuPageState createState() => SudokuPageState();

}

class SudokuPageState extends GamePageState {

  @override
  void initGame() {
    setGameTitle = "sudoku";
    setGame = Sudoku();
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
        child: Column(children: [_sudokuGridDisplay()],),
      ),
    );
  }

  Expanded _sudokuGridDisplay() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;
          double mainSpacing = (row % 3 == 2) ? 4.0 : 1.0;
          double crossSpacing = (col % 3 == 2) ? 4.0 : 1.0;

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: (getGame as Sudoku).getPuzzleGrid[row][col] == 0 ? Colors.white : Colors.grey.shade300,
      ),
      child: (getGame as Sudoku).getPuzzleGrid[row][col] == 0
          ? TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) => _onCellChanged(row, col, value),
            )
          : Center(
              child: Text(
                (getGame as Sudoku).getPuzzleGrid[row][col].toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
  
  void _onCellChanged(int row, int col, String value) {
    int? input = int.tryParse(value);
    if (input != null && input > 0 && input <= 9) {
      setState(() {
        (getGame as Sudoku).setPuzzleGridVal(input, row, col);
        if (isGameEnded()) {
          handleGameEnd();
        }
      });
    }
  }
  
}
