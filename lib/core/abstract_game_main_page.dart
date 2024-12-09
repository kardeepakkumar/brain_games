import 'package:flutter/material.dart';

abstract class GameMainPage extends StatefulWidget {
  const GameMainPage({super.key});

  @override
  GameMainPageState createState();
}

abstract class GameMainPageState<T extends GameMainPage> extends State<T> {

  late String _gameTitle;
  void initGame();

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    return gameMainPageBuilder(context);
  }

  Scaffold gameMainPageBuilder(BuildContext context) {
    return Scaffold(
    appBar: gameMainPageAppBar(),
    body: gameMainPageBody(context),
  );
  }

  AppBar gameMainPageAppBar() {
    return AppBar(
    title: Text(_gameTitle),
    centerTitle: true,
    );
  }

  set setGameTitle(String gameTitle) {
    _gameTitle = gameTitle;
  }

  Widget gameMainPageBody(BuildContext context);

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
