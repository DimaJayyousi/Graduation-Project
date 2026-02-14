import 'package:flutter/material.dart';
import '../app_theme.dart';

class VerificationDoneScreen extends StatelessWidget {
  const VerificationDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'passenger';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gold checkmark circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.check, size: 56, color: Colors.white),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Go to Home',
                  onPressed: () {
                    if (role == 'driver') {
                      // TODO: navigate to driver home (coming later)
                      Navigator.pushReplacementNamed(context, '/driver-home');
                    } else {
                      // TODO: navigate to passenger home (coming later)
                      Navigator.pushReplacementNamed(context, '/passenger-home');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}