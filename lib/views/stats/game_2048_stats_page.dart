import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:brain_games/utils/stats_style.dart';

class Game2048StatsPage extends StatelessWidget {

  const Game2048StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('stats');
    final gameStats = statsBox.values
        .where((stat) => stat['game'] == '2048')
        .toList()
        .cast<Map>();
    gameStats.sort((a, b) => a['time'].compareTo(b['time']));
    return gameStatsPageBuilder(gameStats, '2048 stats');
  }

}