import 'package:flutter/material.dart';

import 'games/game_2048_page.dart';
import 'games/game_memory_match_page.dart';
import 'stats/stats_main_page.dart';

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
      gameListTile(context, '2048', const Game2048Page()),
      gameListTile(context, 'Memory Match', const GameMemoryMatchPage()),
    ],
  );
  }

  ElevatedButton viewStatsPageButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('View Stats'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatsMainPage()),
        );
      },
    );
  }

  ListTile gameListTile(BuildContext context, String text, Widget page) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
