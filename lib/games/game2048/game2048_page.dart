import 'package:brain_games/core/abstract_game_page.dart';
import 'package:brain_games/games/game2048/game2048.dart';
import 'package:brain_games/games/game2048/game2048_tile.dart';
import 'package:flutter/material.dart';

class Game2048Page extends GamePage {
  const Game2048Page({super.key});

  @override
  Game2048PageState createState() => Game2048PageState();
  
}

class Game2048PageState extends GamePageState{
  @override
  void initGame() {
    setGameTitle = "2048";
    setGame = Game2048();
  }

  @override
  Game2048Page gameBuilder() {
    return const Game2048Page();
  }

  @override
  Widget gameBoard() {
    return _gameBoardExpanded();
  }

  Expanded _gameBoardExpanded() {
    return Expanded(
        child: GestureDetector(
          key: const Key('swipe_detector'),
          onVerticalDragEnd: _verticalDrag,
          onHorizontalDragEnd: _horizontalDrag,
          child: gameBoardDisplay(),
        ),
      );
  }

  void _horizontalDrag(details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      _handleSwipe('right');
    } else {
      _handleSwipe('left');
    }
  }

  void _verticalDrag(details) {
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
    if (!getGame.isGameEnded()) {
      setState(() {
        (getGame as Game2048).move(direction);
        if (getGame.isGameEnded()) handleGameEnd();
      });
    }
  }

  Widget _buildGameBoard() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: (getGame as Game2048).getGridSize * (getGame as Game2048).getGridSize,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (getGame as Game2048).getGridSize,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ (getGame as Game2048).getGridSize;
        int col = index % (getGame as Game2048).getGridSize;
        return Game2048Tile(value: (getGame as Game2048).gridVal(row, col));
      },
    );
  }

}