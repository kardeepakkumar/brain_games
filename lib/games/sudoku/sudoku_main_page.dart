import 'package:brain_games/core/abstract_game_main_page.dart';
import 'package:brain_games/games/sudoku/sudoku_page.dart';
import 'package:flutter/material.dart';

class SudokuMainPage extends GameMainPage{

  const SudokuMainPage({super.key});

  @override
  SudokuMainPageState createState() => SudokuMainPageState();
}

class SudokuMainPageState extends GameMainPageState{

  @override
  void initGame() {
    setGameTitle = "sudoku";
  }

  @override
  Widget gameMainPageBody(BuildContext context) {
    return ListView(
    children: [
      gameListTile(context, 'Easy', const SudokuPage(level: 'Easy')),
      gameListTile(context, 'Medium', const SudokuPage(level: 'Medium')),
      gameListTile(context, 'Hard', const SudokuPage(level: 'Hard')),
    ],
  );
  }

}