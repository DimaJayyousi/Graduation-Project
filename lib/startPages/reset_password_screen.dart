import 'package:flutter/material.dart';
import '../app_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPassCtrl     = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNew     = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
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
            child: Column(
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
                const SizedBox(height: 28),

                // New Password
                const Text('New Password',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                const SizedBox(height: 6),
                AppTextField(
                  hint: '············',
                  controller: _newPassCtrl,
                  obscure: _obscureNew,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm New Password
                const Text('Confirm New Password',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                const SizedBox(height: 6),
                AppTextField(
                  hint: '············',
                  controller: _confirmPassCtrl,
                  obscure: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: 28),

                AppButton(
                  label: 'Reset Password',
                  onPressed: () {
                    // TODO: Firebase confirm password reset
                    Navigator.pushReplacementNamed(context, '/login');
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