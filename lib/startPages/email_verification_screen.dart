import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    // Poll every 3 seconds to check if user clicked the link in their email
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final verified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      if (verified && mounted) {
        _timer?.cancel();
        final role = ModalRoute.of(context)?.settings.arguments as String? ??
            'passenger';
        Navigator.pushReplacementNamed(context, '/verification-done',
            arguments: role);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email resent!',
              style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to resend. Please try again.',
              style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Check your Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We sent a verification link to:\n$email\n\nOpen your email and tap the link to verify your account.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontFamily: 'Roboto',
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This screen will continue automatically once verified.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Resend button
                _resending
                    ? const CircularProgressIndicator(
                        color: AppColors.primary)
                    : AppButton(
                        label: 'Resend Email',
                        onPressed: _resend,
                      ),
                const SizedBox(height: 12),

                // Wrong email? go back to signup
                TextButton(
                  onPressed: () {
                    _timer?.cancel();
                    FirebaseAuth.instance.currentUser?.delete();
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text(
                    'Wrong email? Sign up again',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      fontFamily: 'Roboto',
                    ),
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