import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StatsGamePage extends StatelessWidget {
  final String gameTitle;
  const StatsGamePage({super.key, required this.gameTitle});
  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('stats');
    final gameStats = statsBox.values
        .where((stat) => stat['game'] == gameTitle)
        .toList()
        .cast<Map>();
    gameStats.sort((a, b) => a['time'].compareTo(b['time']));
    return gameStatsPageBuilder(gameStats, gameTitle);
  }

  Scaffold gameStatsPageBuilder(List<Map<dynamic, dynamic>> gameStats, String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: gameStats.isEmpty
        ? statsUnavailableBody()
        : gameStatsViewBuilder(gameStats),
    );
  }

  ListView gameStatsViewBuilder(List<Map<dynamic, dynamic>> gameStats) {
    return ListView.builder(
      itemCount: gameStats.length,
      itemBuilder: (context, index) {
        final stat = gameStats[index];
        return statsContainer(index, stat);
      },
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

  Container statsContainer(int index, Map<dynamic, dynamic> stat) {
    final bool isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: statsBoxDecor(isEven),
      child: statsRow(index, stat),
    );
  }

  BoxDecoration statsBoxDecor(bool isEven) {
    return BoxDecoration(
      color: statsColor(isEven),
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: statsBox,
    );
  }

  Color statsColor(bool isEven) => isEven ? Colors.blue.shade50 : Colors.white;

  List<BoxShadow> get statsBox {
    return [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 4.0,
          offset: const Offset(0, 2),
        ),
      ];
  }

  Row statsRow(int index, Map<dynamic, dynamic> stat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${index + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          stat['time'],
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          stat['date'],
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}