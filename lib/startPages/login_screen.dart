import 'package:flutter/material.dart';
import '../app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // role passed from RoleScreen ('driver' or 'passenger')
    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'passenger';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
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
                    'Log in',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email
                const Text('Email',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'Enter your email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                const Text('Password',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                const SizedBox(height: 6),
                AppTextField(
                  hint: '············',
                  controller: _passwordCtrl,
                  obscure: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const SizedBox(height: 6),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/reset-password'),
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Log in button
                AppButton(
                  label: 'Log in',
                  onPressed: () {
                    // TODO: Firebase Auth sign in
                  },
                ),
                const SizedBox(height: 16),

                // Sign up link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      '/signup',
                      arguments: role,
                    ),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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