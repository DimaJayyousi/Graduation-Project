import 'package:flutter/material.dart';
import '../app_theme.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('Images/logo.png', height: 200, fit: BoxFit.contain),
              const SizedBox(height: 40),
              AppButton(
                label: 'Driver',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/login',
                  arguments: 'driver',
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Passenger',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/login',
                  arguments: 'passenger',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
