import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';

class SplitBar extends StatelessWidget {
  final Expense expense;

  const SplitBar({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {

    final splits = expense.splits;
    final totalBars = '0.${splits.length}';
    double decimalValue = double.parse(totalBars);
    
    return Row(
      children: splits.map((split) {
        return Expanded(
          flex: (decimalValue * 100).round(),
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