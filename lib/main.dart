import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/providers/track_list_provider.dart';
import 'package:split_track/screens/edit_track.dart';
import 'package:split_track/screens/expense_list_screen.dart';
import 'package:split_track/screens/icon_selector_screen.dart';
import 'package:split_track/screens/new_expense.dart';
import 'package:split_track/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackListProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider())
      ],
      child: const MyApp(),
    ),
  );
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
      routes: {
        "new_track": (BuildContext context) => const NewTrackScreen(),
        "edit_track": (BuildContext context) => const EditTrackScreen(),
        "expense_list": (BuildContext context) => const ExpenseListScreen(),
        "new_expense": (BuildContext context) => const NewExpenseScreen(),
        "icon_selector": (BuildContext context) => const IconSelectorScreen()
      },
    );
  }
}
