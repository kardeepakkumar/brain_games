import 'package:brain_games/games/game2048/game2048_utils.dart';
import 'package:flutter/material.dart';

class Game2048Tile extends StatelessWidget {
  
  final int value;
  const Game2048Tile({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: 70.0,
      height: 70.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getTileColor(value),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        value == 0 ? "" : "$value",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: value > 4 ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}