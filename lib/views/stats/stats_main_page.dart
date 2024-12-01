import 'package:flutter/material.dart';

import 'package:brain_games/views/stats/game_2048_stats_page.dart';

class StatsMainPage extends StatelessWidget {
  const StatsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return statsMainPageBuilder(context);
  }

  Scaffold statsMainPageBuilder(BuildContext context) {
    return Scaffold(
    appBar: statsMainPageAppBar(),
    body: statsMainPageBody(context),
  );
  }

  AppBar statsMainPageAppBar() {
    return AppBar(
      title: const Text('Stats'),
      centerTitle: true,
      );
  }

  ListView statsMainPageBody(BuildContext context) {
    return ListView(
    children: [
      game2048StatsTile(context),
      gameMemoryMatchStatsTile(),
    ],
  );
  }

  ListTile game2048StatsTile(BuildContext context) {
    return ListTile(
      title: const Text('2048'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Game2048StatsPage(),
          ),
        );
      },
    );
  }
  
  ListTile gameMemoryMatchStatsTile() {
    return const ListTile(
      title: Text('Memory Match (Coming Soon)'),
    );
  }
}
