import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure  = true;
  bool _loading  = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _logIn(String role) async {
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.logIn(
        email:    _emailCtrl.text,
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      // Get the actual role from Firestore (in case they switch roles later)
      final userRole = await AuthService.getUserRole();

      if (userRole == 'driver') {
        Navigator.pushReplacementNamed(context, '/driver-home');
      } else {
        Navigator.pushReplacementNamed(context, '/passenger-home');
      }

    } on FirebaseAuthException catch (e) {
      _showError(_authError(e.code));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':   return 'No account found with this email.';
      case 'wrong-password':   return 'Incorrect password. Please try again.';
      case 'invalid-email':    return 'Please enter a valid email address.';
      case 'user-disabled':    return 'This account has been disabled.';
      case 'invalid-credential': return 'Incorrect email or password.';
      default:                 return 'Login failed. Please try again.';
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

                const Text('Email',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'Enter your email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

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

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context, '/reset-password', arguments: role),
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

                _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : AppButton(
                        label: 'Log in',
                        onPressed: () => _logIn(role),
                      ),
                const SizedBox(height: 16),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context, '/signup', arguments: role),
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