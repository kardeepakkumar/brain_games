import 'package:flutter/material.dart';
import 'game_2048_page.dart';
import 'memory_match_page.dart';
import 'stats_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Games'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsPage()),
              );
            },
            child: const Text('View Stats'),
          ),
          ListTile(
            title: const Text('2048'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Game2048Page()),
              );
            },
          ),
          ListTile(
            title: const Text('Memory Match'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemoryMatchPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
