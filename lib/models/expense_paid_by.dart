class ExpensePaidBy {
  final int? id;
  final int expenseId;
  final int participantId;
  final double amount;

  ExpensePaidBy({
    this.id,
    required this.expenseId,
    required this.participantId,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expense_id': expenseId,
      'participant_id': participantId,
      'amount': amount,
    };
  }

  factory ExpensePaidBy.fromMap(Map<String, dynamic> map) {
    return ExpensePaidBy(
      id: map['id'] as int?,
      expenseId: map['expense_id'] as int,
      participantId: map['participant_id'] as int,
      amount: (map['amount'] as num).toDouble(),
    );
  }
}