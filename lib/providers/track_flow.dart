import 'package:flutter/material.dart';
import 'package:split_track/providers/track_scope.dart';
import 'package:split_track/routes/route_names.dart';
import 'package:split_track/screens/expense_list_screen.dart';
import 'package:split_track/screens/new_expense.dart';

class TrackFlow extends StatelessWidget {
  final int trackId;

  const TrackFlow({super.key, required this.trackId});

  @override
  Widget build(BuildContext context) {
    return TrackScope(
      trackId: trackId,
      child: Navigator(
        initialRoute: RouteNames.expenseList,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteNames.newExpense:
              return MaterialPageRoute(
                builder: (_) => const NewExpenseScreen(),
              );

            case RouteNames.expenseList:
              return MaterialPageRoute(
                builder: (_) => const ExpenseListScreen(),
              );
          }
        },
      ),
    );
  }
}