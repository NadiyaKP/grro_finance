import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/model/withdrawal_request.dart';
import '../model/transaction.dart';
import 'withdrawal_state.dart';

final withdrawalViewModelProvider = StateNotifierProvider<WithdrawalViewModel, WithdrawalState>((ref) {
  return WithdrawalViewModel();
});

class WithdrawalViewModel extends StateNotifier<WithdrawalState> {
  WithdrawalViewModel() : super(WithdrawalState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Simulated data based on Figma
    final pending = [
      WithdrawalRequest(
        id: '1',
        userName: 'Akash',
        timeAgo: '2d ago',
        amount: 189,
        balance: 50,
      ),
      WithdrawalRequest(
        id: '2',
        userName: 'Akash',
        timeAgo: '2d ago',
        amount: 250,
        balance: 100,
      ),
    ];

    final history = [
      Transaction(date: '30-05-2025', type: 'Withdrawn', amount: 250, isCredit: false),
      Transaction(date: '25-05-2025', type: 'Credited', amount: 250, isCredit: true),
      Transaction(date: '24-05-2025', type: 'Credited', amount: 100, isCredit: true),
      Transaction(date: '18-05-2025', type: 'Credited', amount: 300, isCredit: true),
      Transaction(date: '12-05-2025', type: 'Withdrawn', amount: 100, isCredit: false),
      Transaction(date: '07-05-2025', type: 'Credited', amount: 170, isCredit: true),
      Transaction(date: '06-05-2025', type: 'Credited', amount: 300, isCredit: true),
    ];

    state = state.copyWith(
      pendingRequests: pending,
      history: history,
    );
  }

  void updatePendingStatus(String id, WithdrawalStatus status) {
    final updatedList = state.pendingRequests.map((req) {
      if (req.id == id) {
        return WithdrawalRequest(
          id: req.id,
          userName: req.userName,
          timeAgo: req.timeAgo,
          amount: req.amount,
          balance: req.balance,
          status: status,
        );
      }
      return req;
    }).toList();

    state = state.copyWith(pendingRequests: updatedList);
  }
}
