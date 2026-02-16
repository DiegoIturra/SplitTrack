import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/models/expense_paid_by.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/models/split.dart' as split_model;
import 'package:split_track/providers/db_provider.dart';

class ExpenseProvider extends ChangeNotifier {
  bool isLoading = false;
  final int trackId;  
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider({required this.trackId});

  Future<void> loadExpenses() async {
    if(isLoading) return;
    isLoading = true;
    notifyListeners();
    final data = await DbProvider.db.getAllExpenses(trackId);

    _expenses
      ..clear()
      ..addAll(data);

    isLoading = false;
    notifyListeners();
  }

  Future<void> createExpense({
    required String description,
    required double amount,
    required Participant payer,
    required IconData? icon,
    required List<Participant> participants,
  }) async {

    //Create expense
    final expense = Expense(
      trackId: trackId, 
      description: description, 
      totalAmount: amount, 
      createdAt: DateTime.now().millisecondsSinceEpoch
    );

    final paidBy = ExpensePaidBy(
      expenseId: 0,
      participantId: payer.id!,
      amount: amount,
    );

    final percentage = 100 / participants.length;

    final splits = participants.map((p) {
      return split_model.Split(
        expenseId: 0,
        participantId: p.id!,
        percentage: percentage,
        amount: amount
      );
    }).toList();

    await DbProvider.db.insertFullExpense(
      expense: expense,
      paidBy: paidBy,
      splits: splits,
    );

    await loadExpenses();
  }
}