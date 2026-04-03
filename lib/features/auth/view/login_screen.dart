import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/login_view_model.dart';
import '../view_model/login_state.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final size = MediaQuery.of(context).size;

    // Listen for errors to show a snackbar
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to Grro',
                      style: AppTextStyles.displayLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/login_illustration.png',
                    fit: BoxFit.contain,
                    width: size.width * 0.85,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // White Card Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.inputBorder.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loginState.isSignUp ? 'Sign Up' : 'Login',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Username/Email Field
                    _CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 22),
                    // Password Field
                    _CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_open_rounded,
                      isPassword: true,
                      isPasswordVisible: loginState.isPasswordVisible,
                      onTogglePassword: viewModel.togglePasswordVisibility,
                    ),
                    const SizedBox(height: 36),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: loginState.isLoading 
                          ? null 
                          : () async {
                              final success = await viewModel.authenticate(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              if (success && mounted) {
                                context.go('/home');
                              }
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loginState.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(loginState.isSignUp ? 'Sign Up' : 'Login'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Toggle Mode Button
                    Center(
                      child: TextButton(
                        onPressed: viewModel.toggleMode,
                        child: Text(
                          loginState.isSignUp
                              ? 'Already have an account? Login'
                              : 'Don\'t have an account? Sign Up',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with line (custom implementation based on image)
        Row(
          children: [
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.hintText,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: AppColors.divider.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon, 
              color: AppColors.primary,
              size: 24,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}