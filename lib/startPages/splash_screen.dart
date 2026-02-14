import 'package:flutter/material.dart';
import '../app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary, // gold/yellow background
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/note1'),
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Olive rounded card — starts from ~13% top and 8% left
              // leaving gold visible at top-left corner
              Positioned(
                top: size.height * 0.13,
                left: size.width * 0.08,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              // Logo centered within the olive card area
              Positioned(
                top: size.height * 0.13,
                left: size.width * 0.08,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Image.asset(
                    'Images/logo.png',
                    width: size.width * 0.72,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}