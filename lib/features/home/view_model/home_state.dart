import '../model/withdrawal_request.dart';

class HomeState {
  final double leadProcessingFee;
  final double hiringCommission;
  final double referralCommission;
  final double revenue;
  final List<WithdrawalRequest> withdrawals;
  final bool isLoading;

  HomeState({
    this.leadProcessingFee = 2000,
    this.hiringCommission = 1000,
    this.referralCommission = 4200,
    this.revenue = 560000,
    this.withdrawals = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    double? leadProcessingFee,
    double? hiringCommission,
    double? referralCommission,
    double? revenue,
    List<WithdrawalRequest>? withdrawals,
    bool? isLoading,
  }) {
    return HomeState(
      leadProcessingFee: leadProcessingFee ?? this.leadProcessingFee,
      hiringCommission: hiringCommission ?? this.hiringCommission,
      referralCommission: referralCommission ?? this.referralCommission,
      revenue: revenue ?? this.revenue,
      withdrawals: withdrawals ?? this.withdrawals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
