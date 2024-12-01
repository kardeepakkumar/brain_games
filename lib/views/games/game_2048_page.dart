import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/2048/game.dart';
import '../../widgets/2048/tile.dart';
import '../../../utils/game_timer.dart';


class Game2048Page extends StatefulWidget {
  const Game2048Page({super.key});

  @override
  Game2048PageState createState() => Game2048PageState();
}

class Game2048PageState extends State<Game2048Page> {
  late Game2048 _game;
  final GameTimer gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    _game = Game2048(gridSize: 4);
    gameTimer.startTimer();
  }

  @override
  void dispose() {
    gameTimer.stopTimer();
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
          'Time: ${gameTimer.formatTime()}',
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
    setState(() {
      _game.move(direction);
      _modifyGameStatus();
    });
  }

  void _modifyGameStatus() {
    if (_game.isGameWon()) {
      addScore();
      _showGameWonDialog();
    }
    else if (_game.isGameOver()) {
      gameTimer.stopTimer();
      _showGameOverDialog();
    }
  }

  void addScore() {
    final statsBox = Hive.box('stats');
    statsBox.add({
      'game': '2048',
      'time': gameTimer.formatTime(),
      'date': gameTimer.formatDate(),
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
      actions: restartAction(context),
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
      actions: restartAction(context),
    );
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
        return GameTile(value: _game.grid[row][col]);
      },
    );
  }
}
