import 'package:flutter/material.dart';
import 'package:split_track/screens/track_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TrackListScreen();
  }
}
