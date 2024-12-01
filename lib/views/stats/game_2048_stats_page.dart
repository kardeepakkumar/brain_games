import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    return game2048StatsPageBuilder(gameStats);
  }

  Scaffold game2048StatsPageBuilder(List<Map<dynamic, dynamic>> gameStats) {
    return Scaffold(
    appBar: AppBar(title: const Text('2048 Stats')),
    body: gameStats.isEmpty
      ? statsUnavailableBody()
      : game2048StatsViewBuilder(gameStats),
  );
  }

  Center statsUnavailableBody() {
    return const Center(
        child: Text(
          'No stats available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
  }

  ListView game2048StatsViewBuilder(List<Map<dynamic, dynamic>> gameStats) {
    return ListView.builder(
      itemCount: gameStats.length,
      itemBuilder: (context, index) {
        final stat = gameStats[index];
        return statsContainer(index, stat);
      },
    );
  }

  Container statsContainer(int index, Map<dynamic, dynamic> stat) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(stat['time'], style: const TextStyle(fontSize: 16.0)),
            Text(stat['date'], style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
  }

}
