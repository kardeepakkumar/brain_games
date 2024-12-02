import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/2048/game.dart';
import '../../widgets/2048/tile.dart';
import 'package:brain_games/utils/format_time.dart';


class Game2048Page extends StatefulWidget {
  const Game2048Page({super.key});

  @override
  Game2048PageState createState() => Game2048PageState();
}

class Game2048PageState extends State<Game2048Page> {
  late Game2048 _game;
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _game = Game2048(gridSize: 4);
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

  Game2048 get game => _game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: game2048AppBar(context),
      body: game2048Body(),      
    );
  }

  AppBar game2048AppBar(BuildContext context) {
    return AppBar(
      title: const Text("2048"),
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
    _startTimer();
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Game2048Page(),
      ),
    );
  }

  Column game2048Body() {
    return Column(
      children: [
        displayTimer(),
        gameBoardExpanded(),
      ],
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

  Expanded gameBoardExpanded() {
    return Expanded(
        child: GestureDetector(
          key: const Key('swipe_detector'),
          onVerticalDragEnd: verticalDrag,
          onHorizontalDragEnd: horizontalDrag,
          child: gameBoardDisplay(),
        ),
      );
  }

  void horizontalDrag(details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      _handleSwipe('right');
    } else {
      _handleSwipe('left');
    }
  }

  void verticalDrag(details) {
    if (details.velocity.pixelsPerSecond.dy > 0) {
      _handleSwipe('down');
    } else {
      _handleSwipe('up');
    }
  }

  Column gameBoardDisplay() {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: _buildGameBoard(),
        ),
      ],
    );
  }

  void _handleSwipe(String direction) {
    if (_game.isActive) {
      setState(() {
        _game.move(direction);
        _modifyGameStatus();
      });
    }
  }

  void _modifyGameStatus() {
    if (_game.isGameWon()) {
      _timer?.cancel();
      addScore();
      _showGameWonDialog();
    }
    else if (_game.isGameOver()) {
      _timer?.cancel();
      _showGameOverDialog();
    }
  }

  void addScore() {
    final statsBox = Hive.box('stats');
    statsBox.add({
      'game': '2048',
      'time': FormatDateTime.formatTime(_elapsedSeconds),
      'date': FormatDateTime.getToday(),
    });
  }

  void _showGameWonDialog() {
    showDialog(
      context: context,
      builder: (_) => gameWonAlert(),
    );
  }

  AlertDialog gameWonAlert() {
    return AlertDialog(
      title: const Text("You won!!"),
      content: const Text("2048 is achieved!"),
      actions: playAgainAction(context),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => gameOverAlert(),
    );
  }

  AlertDialog gameOverAlert() {
    return AlertDialog(
      title: const Text("Game Over"),
      content: const Text("No more moves available!"),
      actions: playAgainAction(context),
    );
  }

  List<Widget> playAgainAction(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          Navigator.of(context).pop();
          refreshPage(context);
        },
      ),
    ];
  }

  Widget _buildGameBoard() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _game.gridSize * _game.gridSize,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _game.gridSize,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ _game.gridSize;
        int col = index % _game.gridSize;
        return Game2048Tile(value: _game.grid[row][col]);
      },
    );
  }
}