import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../model/withdrawal_request.dart';
import '../view_model/home_view_model.dart';
import 'widgets/home_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nizam', style: AppTextStyles.headlineMedium),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 16.0),
          //   child: Icon(Icons.menu),
          // ),
        ],
      ),
      endDrawer: const HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _DashboardCard(
                    title: 'Lead Processing Fee',
                    amount: '₹ ${homeState.leadProcessingFee.toStringAsFixed(0)}',
                    color: AppColors.cardGreen,
                  ),
                  _DashboardCard(
                    title: 'Hiring Commission',
                    amount: '₹ ${homeState.hiringCommission.toStringAsFixed(0)}',
                    color: AppColors.cardBlue,
                  ),
                  _DashboardCard(
                    title: 'Referral Commission',
                    amount: '₹ ${homeState.referralCommission.toStringAsFixed(0)}',
                    color: AppColors.cardRed,
                  ),
                  _DashboardCard(
                    title: 'Revenue',
                    amount: '₹ ${homeState.revenue.toStringAsFixed(0)}',
                    color: AppColors.cardPurple,
                  ),
                ],
              ),
            ),
            
            // Withdrawals Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Withdrawals', style: AppTextStyles.titleLarge),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
            
            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _FilterChip(label: 'All', isActive: true),
                  const SizedBox(width: 10),
                  _FilterChip(label: 'Period'),
                  const SizedBox(width: 10),
                  _FilterChip(label: 'Status'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Withdrawal List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: homeState.withdrawals.length,
              itemBuilder: (context, index) {
                final request = homeState.withdrawals[index];
                return _WithdrawalCard(
                  request: request,
                  onAccept: () => viewModel.updateRequestStatus(request.id, WithdrawalStatus.accepted),
                  onReject: () => viewModel.updateRequestStatus(request.id, WithdrawalStatus.declined),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _FilterChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.black : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  final WithdrawalRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _WithdrawalCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.userName, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(request.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Account Details', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              const Spacer(),
              const Text('Remarks', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹ ${request.amount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.cardBlue, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Balance : ₹ ${request.balance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const Spacer(),
              if (request.status == WithdrawalStatus.pending) ...[
                TextButton(
                  onPressed: onReject,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.red, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onAccept,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: AppColors.cardGreen, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Accept', style: TextStyle(fontSize: 12)),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: request.status == WithdrawalStatus.accepted ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status == WithdrawalStatus.accepted ? 'Accepted' : 'Declined',
                    style: TextStyle(
                      color: request.status == WithdrawalStatus.accepted ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}