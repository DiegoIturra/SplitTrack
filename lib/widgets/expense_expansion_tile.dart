import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/widgets/expense_details.dart';

class ExpenseExpansionTile extends StatelessWidget{
  final Expense expense;

  const ExpenseExpansionTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(
          expense.description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('\$${expense.totalAmount.toStringAsFixed(0)}'),
        children: [
          ExpenseDetails(expense: expense)
        ],
      ),
    );
  }

}