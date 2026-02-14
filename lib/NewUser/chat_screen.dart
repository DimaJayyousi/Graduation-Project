import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final int _navIndex = 2; // chat is index 2 in bottom nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chat bubble icon
                      Icon(
                        Icons.chat_bubble,
                        size: 72,
                        color: AppColors.textDark,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No messages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          'Messages will show up here once you booked a trip.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                            fontFamily: 'Roboto',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom nav ────────────────────────────────────────────
            AppBottomNav(
              currentIndex: _navIndex,
              onTap: _onNavTap,
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/passenger-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/trips');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/help');
        break;
    }
  }
}