import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/withdrawal_request.dart';
import 'home_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Simulated data based on Figma
    final list = [
      WithdrawalRequest(
        id: '1',
        userName: 'Akash',
        timeAgo: '2d ago',
        amount: 100,
        balance: 50,
      ),
      WithdrawalRequest(
        id: '2',
        userName: 'Arun Kumar',
        timeAgo: '3d ago',
        amount: 100,
        balance: 50,
        status: WithdrawalStatus.accepted,
      ),
      WithdrawalRequest(
        id: '3',
        userName: 'Muhammed Anshad',
        timeAgo: 'Mar 15',
        amount: 100,
        balance: 50,
        status: WithdrawalStatus.declined,
      ),
      WithdrawalRequest(
        id: '4',
        userName: 'Akash',
        timeAgo: '2d ago',
        amount: 100,
        balance: 50,
      ),
    ];

    state = state.copyWith(withdrawals: list);
  }

  void updateRequestStatus(String id, WithdrawalStatus status) {
    final updatedList = state.withdrawals.map((req) {
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

    state = state.copyWith(withdrawals: updatedList);
  }
}
