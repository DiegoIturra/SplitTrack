import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/providers/participant_provider.dart';
import 'package:split_track/providers/track_list_provider.dart';
import 'package:split_track/routes/route_names.dart';
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.expenseList:
            final trackId = settings.arguments as int;

            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => ExpenseProvider(trackId: trackId)..loadExpenses(),
                child: ExpenseListScreen(trackId: trackId),
              ),
            );
          case RouteNames.newExpense:
            final trackId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) =>
                    ParticipantProvider(trackId: trackId)..loadParticipants(),
                child: NewExpenseScreen(trackId: trackId),
              ),
            );
          case RouteNames.iconSelector:
            return MaterialPageRoute(
              builder: (_) => const IconSelectorScreen()
            );
          case RouteNames.newtrack:
            return MaterialPageRoute(
              builder: (_) => const NewTrackScreen()
            );
          default:
            return null;
        }
      },
    );
  }
}
