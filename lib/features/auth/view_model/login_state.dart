import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isSignUp;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isSignUp = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isSignUp,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSignUp: isSignUp ?? this.isSignUp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
