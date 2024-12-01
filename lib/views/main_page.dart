import 'package:flutter/material.dart';

import 'games/game_2048_page.dart';
import 'games/memory_match_page.dart';
import 'stats/stats_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return mainPageBuilder(context);
  }

  Scaffold mainPageBuilder(BuildContext context) {
    return Scaffold(
    appBar: mainPageAppBar(),
    body: mainPageBody(context),
  );
  }

  AppBar mainPageAppBar() {
    return AppBar(
    title: const Text('Brain Games'),
    centerTitle: true,
  );
  }

  ListView mainPageBody(BuildContext context) {
    return ListView(
    children: [
      viewStatsPageButton(context),
      game2048Tile(context),
      gameMemoryMatchTile(context),
    ],
  );
  }

  ElevatedButton viewStatsPageButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('View Stats'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatsPage()),
        );
      },
    );
  }

  ListTile game2048Tile(BuildContext context) {
    return ListTile(
      title: const Text('2048'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Game2048Page()),
        );
      },
    );
  }
  ListTile gameMemoryMatchTile(BuildContext context) {
    return ListTile(
      title: const Text('Memory Match'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MemoryMatchPage()),
        );
      },
    );
  }
}
