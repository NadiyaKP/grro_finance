import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/splash_view_model.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Gentle scale-in with a soft fade — keeps it classy
    _scaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(splashViewModelProvider, (previous, next) {
      if (next.hasValue) {
        final isLoggedIn = next.value ?? false;
        if (isLoggedIn) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTop,
              AppColors.gradientBottom,
            ],
            stops: [0.0, 0.72],
          ),
        ),
        child: Center(
          child: _LogoCard(controller: _controller, scaleAnim: _scaleAnim, fadeAnim: _fadeAnim),
        ),
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard({
    required this.controller,
    required this.scaleAnim,
    required this.fadeAnim,
  });

  final AnimationController controller;
  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardSize = size.width * 0.58;

    return FadeTransition(
      opacity: fadeAnim,
      child: ScaleTransition(
        scale: scaleAnim,
        child: Container(
          width: cardSize,
          height: cardSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A00D4D8),
                blurRadius: 40,
                spreadRadius: 8,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/grro_logo.png',
              width: cardSize * 0.62,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}