import 'package:flutter/material.dart';
import '2048_page.dart';
import 'memory_match_page.dart';

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
          ListTile(
            title: const Text('2048'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage()),
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
