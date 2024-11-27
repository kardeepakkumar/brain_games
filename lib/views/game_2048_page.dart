import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/2048/game.dart';
import '../widgets/2048/tile.dart';
import '../../utils/game_timer.dart';


class Game2048Page extends StatefulWidget {
  const Game2048Page({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<Game2048Page> {
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

  void _handleSwipe(String direction) {
    setState(() {
      _game.move(direction);
      _checkGameStatus();
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: const Text("No more moves available!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Game2048Page(), // Creates a fresh GamePage
                ),
              );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  void _showGameWonDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("You won!!"),
        content: const Text("2048 is achieved!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Game2048Page(), // Creates a fresh GamePage
                ),
              );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  void _checkGameStatus() {
    if (_game.isGameWon()) {
        final statsBox = Hive.box('stats');
        statsBox.add({
          'game': '2048',
          'time': gameTimer.formatTime(),
          'date': gameTimer.formatDate(),
        });
        _showGameWonDialog();
      }
    if (_game.isGameOver()) {
      gameTimer.stopTimer();
      _showGameOverDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2048"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Game2048Page(), // Creates a fresh GamePage
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time: ${gameTimer.formatTime()}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GestureDetector(
              key: const Key('swipe_detector'),
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy > 0) {
                  _handleSwipe('down');
                } else {
                  _handleSwipe('up');
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  _handleSwipe('right');
                } else {
                  _handleSwipe('left');
                }
              },
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: _buildGameBoard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),      
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
