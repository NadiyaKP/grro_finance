import '../model/transaction.dart';
import '../../home/model/withdrawal_request.dart';

class WithdrawalState {
  final String userName;
  final String location;
  final double totalBalance;
  final double totalCredited;
  final double totalWithdrawn;
  final List<WithdrawalRequest> pendingRequests;
  final List<Transaction> history;
  final bool isLoading;

  WithdrawalState({
    this.userName = 'AKASH',
    this.location = 'Dubai',
    this.totalBalance = 2000,
    this.totalCredited = 1500,
    this.totalWithdrawn = 2000,
    this.pendingRequests = const [],
    this.history = const [],
    this.isLoading = false,
  });

  WithdrawalState copyWith({
    String? userName,
    String? location,
    double? totalBalance,
    double? totalCredited,
    double? totalWithdrawn,
    List<WithdrawalRequest>? pendingRequests,
    List<Transaction>? history,
    bool? isLoading,
  }) {
    return WithdrawalState(
      userName: userName ?? this.userName,
      location: location ?? this.location,
      totalBalance: totalBalance ?? this.totalBalance,
      totalCredited: totalCredited ?? this.totalCredited,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
