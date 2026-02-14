import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (_emailCtrl.text.trim().isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.sendPasswordReset(_emailCtrl.text);
      if (!mounted) return;
      setState(() => _emailSent = true);

    } on FirebaseAuthException catch (e) {
      _showError(e.code == 'user-not-found'
          ? 'No account found with this email.'
          : 'Failed to send reset email. Please try again.');
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Roboto')),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _emailSent ? _sentView() : _formView(),
          ),
        ),
      ),
    );
  }

  // ── Form: enter email ──────────────────────────────────────────────────────
  Widget _formView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
          child: Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Enter your email and we\'ll send you a reset link.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 28),

        const Text('Email',
            style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
        const SizedBox(height: 6),
        AppTextField(
          hint: 'Enter your email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 28),

        _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary))
            : AppButton(
                label: 'Send Reset Link',
                onPressed: _sendReset,
              ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Back to Log in',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Success: email sent confirmation ──────────────────────────────────────
  Widget _sentView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.mark_email_read_outlined,
            size: 64, color: AppColors.primary),
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
        const SizedBox(height: 8),
        const Text(
          'A password reset link has been sent to your email address.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
            fontFamily: 'Roboto',
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        AppButton(
          label: 'Back to Log in',
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ],
    );
  }
}