import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'views/main_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('stats');
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
