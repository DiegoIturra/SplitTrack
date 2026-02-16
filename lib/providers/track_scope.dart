import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/providers/participant_provider.dart';

class TrackScope extends StatelessWidget {
  final int trackId;
  final Widget child;

  const TrackScope({super.key, required this.trackId, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(trackId: trackId)..loadExpenses(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ParticipantProvider(trackId: trackId)..loadParticipants(),
        ),
      ],
      child: child,
    );
  }
}