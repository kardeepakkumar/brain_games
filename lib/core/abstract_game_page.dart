import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:brain_games/core/abstract_game.dart';
import 'package:brain_games/utils/format_time.dart';

abstract class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState();
}

abstract class GamePageState<T extends GamePage> extends State<T> {

  late String _gameTitle;
  late Game _game;
  int _elapsedSeconds = 0;
  Timer? _timer;
  final _statsBox = Hive.box('stats');

  void initGame();
  String get getGameTitle => _gameTitle;
  Game get getGame => _game;

  @override
  void initState() {
    super.initState();
    initGame();
    _startTimer();
  }

  set setGameTitle(String gameTitle) {
    _gameTitle = gameTitle;
  }

  set setGame(Game game) {
    _game = game;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gameAppBar(context),
      body: _gameBody(),
    );
  }

  AppBar _gameAppBar(BuildContext context) {
    return AppBar(
      title: Text(_gameTitle),
      actions: _restartAction(context),
    );
  }

  List<Widget> _restartAction(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => _showRestartConfirmationDialog(context),
      ),
    ];
  }

  void _showRestartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Restart'),
          content: const Text('Are you sure you want to restart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _refreshPage(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _refreshPage(BuildContext context) {
    _startTimer();
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => gameBuilder(),
      ),
    );
  }

  GamePage gameBuilder();

  Column _gameBody() {
    return Column(
      children: [
        _displayTimer(),
        gameBoard(),
      ],
    );
  }

  Padding _displayTimer() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          key: const Key('timer_display'),
          'Time: ${FormatDateTime.formatTime(_elapsedSeconds)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
  }

  Widget gameBoard();

  bool isGameEnded() {
    return (_game.isGameEnded());
  }

  void handleGameEnd() {
    if (_game.isGameWon()) {
      _endGameWithWin();
    } else if (_game.isGameOver()) {
      _endGameWithLoss();
    }
  }

  void _endGameWithWin() {
    _timer?.cancel();
    _addScore();
    _showGameWonSnackbar();
  }

  void _endGameWithLoss() {
    _timer?.cancel();
    _showGameOverSnackbar();
  }


  void _addScore() {
    _statsBox.add({
      'game': _gameTitle,
      'time': FormatDateTime.formatTime(_elapsedSeconds),
      'date': FormatDateTime.getToday(),
    });
  }

  void _showGameWonSnackbar() {
    final snackBar = SnackBar(
      content: Text("You won!! $_gameTitle is achieved!"),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showGameOverSnackbar() {
    final snackBar = SnackBar(
      content: Text("You won!! $_gameTitle is over!"),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}