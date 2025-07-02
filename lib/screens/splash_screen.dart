import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding screen after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Colors.white,
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(delay: 200.ms, duration: 500.ms),
            
            const SizedBox(height: 24),
            
            // App name
            Text(
              'Suivi des Logs',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
