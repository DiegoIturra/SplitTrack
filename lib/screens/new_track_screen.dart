import 'package:flutter/material.dart';

class NewTrackScreen extends StatelessWidget {
  const NewTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Track", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
