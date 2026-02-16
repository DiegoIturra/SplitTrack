import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';

class SplitBar extends StatelessWidget {
  final Expense expense;


  final splits = [
    {'paid_by': 'Diego', 'amount': 30, 'percentage': 30},
    {'paid_by': 'Juan', 'amount': 23, 'percentage': 30},
    {'paid_by': 'Anibal', 'amount': 1000, 'percentage': 30}
  ];

  SplitBar({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: splits.map((split) {
        return Expanded(
          flex: (0.3 * 100).round(),
          child: Container(
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.indigo.withValues(),
          ),
        );
      }).toList(),
    );
  }
}