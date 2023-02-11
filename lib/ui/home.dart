import 'package:flutter/material.dart';

import 'notodo_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoToDo"),
        backgroundColor: Colors.black54,
      ),
      body: const NoToDoScreen(),
    );
  }
}
