import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/widgets/payer_row.dart';
import 'package:split_track/widgets/split_bar.dart';
import 'package:split_track/widgets/split_list.dart';

class ExpenseDetails extends StatelessWidget{
  final Expense expense;
  const ExpenseDetails({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PayerRow(expense: expense),
          const SizedBox(height: 8),
          SplitList(expense: expense),
          const SizedBox(height: 12),
          SplitBar(expense: expense),
        ],
      ),
    );
  }

}