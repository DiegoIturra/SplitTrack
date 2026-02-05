import 'package:flutter/material.dart';
import 'package:split_track/providers/db_provider.dart';
import 'package:split_track/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbProvider.db.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Split Track",
      home: TrackListScreen(),
      routes: {"new_track": (BuildContext context) => const NewTrackScreen()},
    );
  }
}
