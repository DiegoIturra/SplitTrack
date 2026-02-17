class Split {
  final int? id;
  final int expenseId;
  final int participantId;
  final double percentage;
  final double amount;
  final String? participantName;

  Split({
    this.id,
    required this.expenseId,
    required this.participantId,
    required this.percentage,
    required this.amount,
    this.participantName
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expense_id': expenseId,
      'participant_id': participantId,
      'percentage': percentage,
      'amount': amount
    };
  }

  factory Split.fromMap(Map<String, dynamic> map) {
    return Split(
      id: map['id'] as int?,
      expenseId: map['expense_id'] as int,
      participantId: map['participant_id'] as int,
      percentage: (map['percentage'] as num).toDouble(),
      amount: (map['amount'] as num).toDouble(),
      participantName: map['participant_name'] as String?,
    );
  }

  Split copyWith({
    int? id,
    int? expenseId,
    int? participantId,
    double? percentage,
    double? amount
  }) {
    return Split(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      participantId: participantId ?? this.participantId,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      participantName: participantName
    );
  }
}