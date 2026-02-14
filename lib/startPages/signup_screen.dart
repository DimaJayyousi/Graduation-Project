import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _dobCtrl      = TextEditingController();
  bool _obscure   = true;
  bool _loading   = false;
  String _gender  = 'Male';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp(String role) async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _dobCtrl.text.trim().isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    setState(() => _loading = true);

    try {
      // 1. Create user + save to Firestore
      final cred = await AuthService.signUp(
        email:    _emailCtrl.text,
        password: _passwordCtrl.text,
        name:     _nameCtrl.text,
        phone:    _phoneCtrl.text,
        dob:      _dobCtrl.text,
        gender:   _gender,
        role:     role,
      );

      // 2. Send verification email in the background — don't await it
      //    so it never blocks navigation even if it's slow
      cred.user?.sendEmailVerification().catchError((_) {});

      // 3. Navigate immediately
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/upload-photo', arguments: role);

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
      case 'email-already-in-use': return 'This email is already registered.';
      case 'invalid-email':        return 'Please enter a valid email address.';
      case 'weak-password':        return 'Password must be at least 6 characters.';
      default:                     return 'Sign up failed. Please try again.';
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
                    'Sign up',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _label('Full Name'),
                AppTextField(hint: 'Enter full name', controller: _nameCtrl),
                const SizedBox(height: 12),

                _label('Email'),
                AppTextField(
                  hint: 'Enter your email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                _label('Phone number'),
                AppTextField(
                  hint: 'Enter phone number',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                _label('Password'),
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
                const SizedBox(height: 12),

                _label('Day of Birth'),
                AppTextField(
                  hint: 'DD/MM/YY',
                  controller: _dobCtrl,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 12),

                _label('Gender'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _RadioOption('Male'),
                    const SizedBox(width: 24),
                    _RadioOption('Female'),
                  ],
                ),
                const SizedBox(height: 24),

                _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : AppButton(
                        label: 'Sign up',
                        onPressed: () => _signUp(role),
                      ),
                const SizedBox(height: 12),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      '/login',
                      arguments: role,
                    ),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontFamily: 'Roboto'),
        ),
      );

  Widget _RadioOption(String value) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: _gender,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (v) => setState(() => _gender = v!),
          ),
          Text(value,
              style: const TextStyle(fontSize: 13, fontFamily: 'Roboto')),
        ],
      );
}