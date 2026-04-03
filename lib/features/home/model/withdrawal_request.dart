enum WithdrawalStatus { pending, accepted, declined }

class WithdrawalRequest {
  final String id;
  final String userName;
  final String timeAgo;
  final double amount;
  final double balance;
  final WithdrawalStatus status;

  WithdrawalRequest({
    required this.id,
    required this.userName,
    required this.timeAgo,
    required this.amount,
    required this.balance,
    this.status = WithdrawalStatus.pending,
  });
}
