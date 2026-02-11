import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/providers/db_provider.dart';

class ExpenseProvider extends ChangeNotifier {

  bool isLoading = false;
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> loadExpenses() async {
    if(isLoading) return;
    isLoading = true;
    notifyListeners();
    final data = await DbProvider.db.getAllExpenses();

    _expenses
      ..clear()
      ..addAll(data);

    isLoading = false;
    notifyListeners();
  }
}