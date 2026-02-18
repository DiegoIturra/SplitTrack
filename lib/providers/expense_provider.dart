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

    final splitAmount = double.parse((amount / participants.length).toStringAsFixed(2));
    final percentage = 100 / participants.length;

    final splits = participants.map((p) {
      return split_model.Split(
        expenseId: 0,
        participantId: p.id!,
        percentage: percentage,
        amount: splitAmount
      );
    }).toList();

    await DbProvider.db.insertFullExpense(
      expense: expense,
      paidBy: paidBy,
      splits: splits,
    );

    await loadExpenses();
  }


  List<Transaction> calculateSettlements(List<Expense> expenses) {
    Map<int, double> balances = {};

    for (var expense in expenses) {
      if (expense.paidBy != null) {
        int payerId = expense.paidBy!.participantId;
        balances[payerId] = (balances[payerId] ?? 0) + expense.totalAmount;
      }

      for (var split in expense.splits) {
        int debtorId = split.participantId;
        balances[debtorId] = (balances[debtorId] ?? 0) - split.amount;
      }
    }

    debugPrint("Mapa de balances final: $balances");

    List<Map<String, dynamic>> debtors = [];
    List<Map<String, dynamic>> creditors = [];

    balances.forEach((id, amount) {
      double roundedAmount = double.parse(amount.toStringAsFixed(2));
      
      if (roundedAmount < 0) {
        debtors.add({'id': id, 'amount': roundedAmount.abs()});
      } else if (roundedAmount > 0) {
        creditors.add({'id': id, 'amount': roundedAmount});
      }
    });

    List<Transaction> settlements = [];
    int d = 0; int c = 0;

    while (d < debtors.length && c < creditors.length) {
      double dAmount = debtors[d]['amount'];
      double cAmount = creditors[c]['amount'];
      double settledAmount = (dAmount < cAmount) ? dAmount : cAmount;

      settlements.add(Transaction(
        fromId: debtors[d]['id'],
        toId: creditors[c]['id'],
        amount: settledAmount,
      ));

      debtors[d]['amount'] -= settledAmount;
      creditors[c]['amount'] -= settledAmount;

      if (debtors[d]['amount'] < 0.01) d++;
      if (creditors[c]['amount'] < 0.01) c++;
    }

    return settlements;
  }


}