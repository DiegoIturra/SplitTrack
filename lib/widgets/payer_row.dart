import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';

class PayerRow extends StatelessWidget{
  final Expense expense;
  const PayerRow({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final payer = "pagador ${expense.paidBy?.participantName}";
    return Row(
      children: [
        const Icon(Icons.payment, size: 16),
        const SizedBox(width: 8),
        Text('$payer pagó \$${expense.totalAmount}'),
      ],
    );
  }

}