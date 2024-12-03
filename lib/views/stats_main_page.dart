import 'package:brain_games/views/stats_game_page.dart';
import 'package:flutter/material.dart';

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
      gameListTile(context, '2048', const StatsGamePage(gameTitle: '2048',)),
      gameListTile(context, 'sudoku', const StatsGamePage(gameTitle: 'sudoku',)),
      gameListTile(context, 'MemoryMatch', const StatsGamePage(gameTitle: 'MemoryMatch',)),
    ],
  );
  }

  ListTile gameListTile(BuildContext context, String gameTitle, Widget page) {
    return ListTile(
      title: Text(gameTitle),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
