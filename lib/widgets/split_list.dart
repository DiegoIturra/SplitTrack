import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';

class SplitList extends StatelessWidget {
  final Expense expense;

  final splits = [
    {'paid_by': 'Diego', 'amount': 30},
    {'paid_by': 'Juan', 'amount': 23},
    {'paid_by': 'Anibal', 'amount': 1000}
  ];


  SplitList({super.key, required this.expense});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: splits.map((split) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${split['paid_by']}"),
            Text('- \$${split['amount']}'),
          ],
        );
      }).toList(),
    );
  }
}