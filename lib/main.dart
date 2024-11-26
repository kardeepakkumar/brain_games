import 'package:flutter/material.dart';
import 'views/main_page.dart';

void main() {
  runApp(const BrainGamesApp());
}

class BrainGamesApp extends StatelessWidget {
  const BrainGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainPage(),
    );
  }
}
