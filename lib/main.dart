import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app_theme.dart';
import 'startPages/splash_screen.dart';
import 'startPages/note_screen1.dart';
import 'startPages/note_screen2.dart';
import 'startPages/role_screen.dart';
import 'startPages/login_screen.dart';
import 'startPages/signup_screen.dart';
import 'startPages/upload_photo_screen.dart';
import 'startPages/done_screen.dart';
import 'startPages/email_verification_screen.dart';
import 'startPages/email_error_screen.dart';
import 'startPages/verification_done_screen.dart';
import 'startPages/reset_password_screen.dart';
import 'passenger_home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TaSApp());
}

class TaSApp extends StatelessWidget {
  const TaSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(primary: AppColors.primary),
      ),
      initialRoute: '/',
      routes: {
        '/':                     (_) => const SplashScreen(),
        '/note1':                (_) => const NoteScreen1(),
        '/note2':                (_) => const SeatOrderNoteScreen(),
        '/role':                 (_) => const RoleScreen(),
        '/login':                (_) => const LoginScreen(),
        '/signup':               (_) => const SignUpScreen(),
        '/upload-photo':         (_) => const UploadPhotoScreen(),
        '/done':                 (_) => const DoneScreen(),
        '/email-verification':   (_) => const EmailVerificationScreen(),
        '/email-error':          (_) => const EmailErrorScreen(),
        '/verification-done':    (_) => const VerificationDoneScreen(),
        '/reset-password':       (_) => const ResetPasswordScreen(),
        '/passenger-home':       (_) => const PassengerHomeScreen(),

        // Placeholders — to be built later
        '/driver-home':          (_) => const _PlaceholderPage('Driver Home'),
      },
    );
  }
}

// Temporary placeholder for screens not built yet
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}