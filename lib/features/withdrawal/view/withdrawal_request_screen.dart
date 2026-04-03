import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/model/withdrawal_request.dart';
import '../view_model/withdrawal_view_model.dart';

class WithdrawalRequestScreen extends ConsumerStatefulWidget {
  const WithdrawalRequestScreen({super.key});

  @override
  ConsumerState<WithdrawalRequestScreen> createState() => _WithdrawalRequestScreenState();
}

class _WithdrawalRequestScreenState extends ConsumerState<WithdrawalRequestScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalViewModelProvider);
    final viewModel = ref.read(withdrawalViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Marketer', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            _UserInfoCard(state: state),
            
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Pending Withdrawal Requests', style: AppTextStyles.headlineMedium),
            ),
            const SizedBox(height: 16),
            
            // Horizontal Pending Requests
            SizedBox(
              height: 175,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: state.pendingRequests.length,
                itemBuilder: (context, index) {
                  final request = state.pendingRequests[index];
                  return _PendingRequestCard(
                    request: request,
                    onAccept: () => viewModel.updatePendingStatus(request.id, WithdrawalStatus.accepted),
                    onReject: () => viewModel.updatePendingStatus(request.id, WithdrawalStatus.declined),
                  );
                },
              ),
            ),
            
            // Dot Indicator Placeholder
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.pendingRequests.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: CircleAvatar(
                      radius: 4, 
                      backgroundColor: _currentPage == index ? Colors.black : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('History', style: AppTextStyles.headlineMedium),
            ),
            const SizedBox(height: 16),
            
            // History List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.history.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final tx = state.history[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tx.date, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      Text(tx.type, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '₹ ${tx.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: tx.isCredit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final dynamic state;
  const _UserInfoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.userName, style: AppTextStyles.headlineMedium.copyWith(fontSize: 20)),
                  Text(state.location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              Text('₹ ${state.totalBalance.toStringAsFixed(0)}', style: AppTextStyles.headlineMedium.copyWith(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Money Credited', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 13)),
                    Text('₹ ${state.totalCredited.toStringAsFixed(0)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Money Withdrawn', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
                    Text('₹ ${state.totalWithdrawn.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final WithdrawalRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingRequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('2d ago', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Account Details', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              const Spacer(),
              const Text('Remarks', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹ ${request.amount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.cardBlue, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Balance : ₹ ${request.balance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: onAccept,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: AppColors.cardGreen, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Accept', style: TextStyle(fontSize: 12)),
                ),
              ] else ...[
                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: request.status == WithdrawalStatus.accepted ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
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
