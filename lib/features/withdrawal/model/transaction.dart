class Transaction {
  final String date;
  final String type; // 'Withdrawn' or 'Credited'
  final double amount;
  final bool isCredit;

  Transaction({
    required this.date,
    required this.type,
    required this.amount,
    required this.isCredit,
  });
}
