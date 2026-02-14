import 'package:flutter/material.dart';
import '../app_theme.dart';

class EmailErrorScreen extends StatelessWidget {
  const EmailErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'passenger';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red X circle
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.errorRed,
                  ),
                  child: const Icon(Icons.close, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),

                const Text(
                  'The code you entered is wrong.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Resend button
                AppButton(
                  label: 'Resend',
                  onPressed: () {
                    // TODO: resend Firebase email verification
                    Navigator.pushReplacementNamed(
                      context,
                      '/email-verification',
                      arguments: role,
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Change Email button
                AppButton(
                  label: 'Change Email',
                  color: Colors.white,
                  textColor: AppColors.primary,
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/signup',
                    arguments: role,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}