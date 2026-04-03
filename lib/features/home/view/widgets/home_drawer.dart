import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.surface,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Nizam',
                    style: AppTextStyles.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.textDark),
            title: const Text('Withdrawal Request', style: AppTextStyles.bodyLarge),
            onTap: () {
              context.pop(); // Close drawer
              context.push('/withdrawal-request');
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () async {
              final storage = ref.read(storageServiceProvider);
              await storage.clear();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
