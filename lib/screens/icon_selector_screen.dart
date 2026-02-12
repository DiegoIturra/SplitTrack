import 'package:flutter/material.dart';

class IconSelectorScreen extends StatelessWidget {
  const IconSelectorScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Selector Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Text('Icon Selector Screen'),
      ),
    );
  }

}