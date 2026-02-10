class Expense {
  final int? id;
  final int trackId;
  final String description;
  final double totalAmount;
  final int createdAt;

  Expense({
    this.id,
    required this.trackId,
    required this.description,
    required this.totalAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'track_id': trackId,
      'description': description,
      'total_amount': totalAmount,
      'created_at': createdAt,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      trackId: map['track_id'] as int,
      description: map['description'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      createdAt: map['created_at'] as int,
    );
  }
}