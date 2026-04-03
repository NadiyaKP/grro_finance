import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import 'login_state.dart';

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authService = ref.read(authServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return LoginViewModel(authService, storageService);
});

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;
  final StorageService _storageService;

  LoginViewModel(this._authService, this._storageService) : super(LoginState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleMode() {
    state = state.copyWith(isSignUp: !state.isSignUp, errorMessage: null);
  }

  Future<bool> authenticate(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (state.isSignUp) {
        await _authService.signUpWithEmailAndPassword(email, password);
      } else {
        await _authService.signInWithEmailAndPassword(email, password);
      }
      
      // Save login state to SharedPreferences
      await _storageService.setLoggedIn(true);

      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: e.message ?? 'An unknown error occurred',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
