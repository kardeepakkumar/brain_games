import 'dart:async';

import 'package:brain_games/utils/format_time.dart';
import 'package:flutter/material.dart';

import 'package:brain_games/games/sudoku/game.dart';

class GameSudokuPage extends StatefulWidget {
  const GameSudokuPage({super.key});

  @override
  GameSudokuPageState createState() => GameSudokuPageState();

}

class GameSudokuPageState extends State<GameSudokuPage> {
  final SudokuGenerator generator = SudokuGenerator();
  List<List<int>> puzzle = [];
  List<List<int>> solution = [];
  int _elapsedSeconds = 0;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
    _generatePuzzle();
    _startTimer();
  }
  
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generatePuzzle() {
    solution = generator.generateFullGrid();
    puzzle = generator.generatePuzzle(10);
    setState(() {});
  }

  void _onCellChanged(int row, int col, String value) {
    int? input = int.tryParse(value);
    if (input != null && input > 0 && input <= 9) {
      setState(() {
        puzzle[row][col] = input;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gameSudokuAppBar(),
      body: puzzle.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [displayTimer(), Flexible(child: sudokuBody(),)],
          ),
    );
  }

  Padding displayTimer() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          key: const Key('timer_display'),
          'Time: ${FormatDateTime.formatTime(_elapsedSeconds)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
  }

  AppBar gameSudokuAppBar() {
    return AppBar(
      title: const Text("Sudoku"),
      actions: restartAction(context),
    );
  }

  List<Widget> restartAction(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => refreshPage(context),
      ),
    ];
  }

  Future<dynamic> refreshPage(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const GameSudokuPage(),
      ),
    );
  }


  Padding sudokuBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
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

          ),
        ],
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: puzzle[row][col] == 0 ? Colors.white : Colors.grey.shade300,
      ),
      child: puzzle[row][col] == 0
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
                puzzle[row][col].toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
