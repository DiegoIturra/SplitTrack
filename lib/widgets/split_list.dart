import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';

class SplitList extends StatelessWidget {
  final Expense expense;

  const SplitList({super.key, required this.expense});


  @override
  Widget build(BuildContext context) {
    final splits = expense.splits;

    for(var s in splits){
      debugPrint('name: ${s.participantName}, amount: ${s.amount}, percentage: ${s.percentage}');
    }

    return Column(
      children: splits.map((split) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${split.participantName}"),
            Text('\$${split.amount}'),
          ],
        );
      }).toList(),
    );
  }
}