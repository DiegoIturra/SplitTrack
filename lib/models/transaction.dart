class Transaction {
  final int fromId;
  final int toId;
  final double amount;

  Transaction({required this.fromId, required this.toId, required this.amount});

  @override
  String toString() {
    return 'Transaction(fromId: $fromId, toId: $toId, amount: $amount)';
  }
  
}