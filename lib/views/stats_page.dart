import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('stats');
    final gameStats = statsBox.values
        .where((stat) => stat['game'] == '2048')
        .toList()
        .cast<Map>();

    gameStats.sort((a, b) => a['time'].compareTo(b['time'])); // Sort by best time

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('2048'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameStatsPage(gameStats: gameStats),
                ),
              );
            },
          ),
          const ListTile(
            title: Text('Memory Match (Coming Soon)'),
          ),
        ],
      ),
    );
  }
}

class GameStatsPage extends StatelessWidget {
  final List<Map> gameStats;

  const GameStatsPage({super.key, required this.gameStats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2048 Stats')),
      body: gameStats.isEmpty
        ? const Center(
            child: Text(
              'No stats available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
          itemCount: gameStats.length < 5 ? gameStats.length : 5,
          itemBuilder: (context, index) {
            final stat = gameStats[index];

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
          },
        ),
    );
  }
}
