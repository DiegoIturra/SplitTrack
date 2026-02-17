import 'package:flutter/material.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/models/expense_paid_by.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/models/split.dart' as split_model;
import 'package:split_track/models/transaction.dart';
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

  List<Transaction> calculateSettlements(List<Expense> expenses, List<Participant> participants) {
    Map<int, double> balances = {
      for(var participant in participants) participant.id!: 0.0
    };

    for(var expense in expenses) {
      if(expense.paidBy != null) {
        balances[expense.paidBy!.participantId] = (balances[expense.paidBy!.participantId] ?? 0) + expense.totalAmount;
      }

      for (var split in expense.splits) {
        balances[split.participantId] = (balances[split.participantId] ?? 0) - split.amount;
      }
    }

    List<Transaction> settlements = [];

    var debtors = balances.entries
      .where((e) => e.value < -0.01)
      .map((e) => {'id': e.key, 'amount': e.value.abs()})
      .toList();
    
    var creditors = balances.entries
      .where((e) => e.value > 0.01)
      .map((e) => {'id': e.key, 'amount': e.value})
      .toList();

    int d = 0; // puntero deudores
    int c = 0; // puntero acreedores

    while (d < debtors.length && c < creditors.length) {
      double dAmount = debtors[d]['amount'] as double;
      double cAmount = creditors[c]['amount'] as double;
      
      double settledAmount = (dAmount < cAmount) ? dAmount : cAmount;

      settlements.add(Transaction(
        fromId: debtors[d]['id'] as int,
        toId: creditors[c]['id'] as int,
        amount: settledAmount,
      ));

      // Actualizar saldos restantes
      debtors[d]['amount'] = (debtors[d]['amount'] as double) - settledAmount;
      creditors[c]['amount'] = (creditors[c]['amount'] as double) - settledAmount;

      if (debtors[d]['amount']! < 0.01) d++;
      if (creditors[c]['amount']! < 0.01) c++;
    }

    return settlements;
    
  }
}