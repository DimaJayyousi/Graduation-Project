import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverChatScreen extends StatelessWidget {
  const DriverChatScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 2) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/driver-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/driver-trips');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/driver-profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/driver-help');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(20)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No messages',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Roboto', color: AppColors.textDark)),
                SizedBox(height: 12),
                Text(
                  'Messages will show up here once you booked\na trip .',
                  style: TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto', height: 1.5),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28),
                Icon(Icons.chat, size: 100, color: AppColors.textDark),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}