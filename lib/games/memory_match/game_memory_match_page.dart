import 'package:flutter/material.dart';

class GameMemoryMatchPage extends StatelessWidget {
  const GameMemoryMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Match')),
      body: const Center(
        child: Text('Memory Match Game Here!'),
      ),
    );
  }
}