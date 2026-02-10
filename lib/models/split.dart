class Split {
  final int? id;
  final int expenseId;
  final int participantId;
  final double percentage;

  Split({
    this.id,
    required this.expenseId,
    required this.participantId,
    required this.percentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expense_id': expenseId,
      'participant_id': participantId,
      'percentage': percentage,
    };
  }

  factory Split.fromMap(Map<String, dynamic> map) {
    return Split(
      id: map['id'] as int?,
      expenseId: map['expense_id'] as int,
      participantId: map['participant_id'] as int,
      percentage: (map['percentage'] as num).toDouble(),
    );
  }
}