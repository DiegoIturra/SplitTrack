import 'package:flutter/material.dart';

class EditTrackScreen extends StatefulWidget {
  const EditTrackScreen({super.key});


  @override
  State<StatefulWidget> createState() => _EditTrackScreenState();
  
}

class _EditTrackScreenState extends State<EditTrackScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Track', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Text("Edit Track"),
      ),
    );
  }
}