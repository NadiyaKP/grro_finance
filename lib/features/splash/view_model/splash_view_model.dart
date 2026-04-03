import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';

// Checks if a user session already exists when the app opens
final splashViewModelProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(milliseconds: 3000));
  final storageService = ref.read(storageServiceProvider);
  return await storageService.isLoggedIn();
});