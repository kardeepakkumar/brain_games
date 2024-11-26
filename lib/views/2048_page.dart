import 'package:flutter/material.dart';
import '../models/2048/game.dart';
import '../widgets/2048/tile.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late Game2048 _game;

  @override
  void initState() {
    super.initState();
    _game = Game2048(gridSize: 4);
  }

  Game2048 get game => _game;

  void _handleSwipe(String direction) {
    setState(() {
      _game.move(direction);
      if (_game.isGameWon()) {
        _showGameWonDialog();
      }
      if (_game.isGameOver()) {
        _showGameOverDialog();
      }
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
              setState(() {
                _game = Game2048(gridSize: 4);
              });
              Navigator.of(context).pop();
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
              setState(() {
                _game = Game2048(gridSize: 4);
              });
              Navigator.of(context).pop();
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
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
              setState(() {
                _game = Game2048(gridSize: 4);
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
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
