import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverMyRidesScreen extends StatelessWidget {
  const DriverMyRidesScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/driver-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/driver-trips');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/driver-chat');
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 28, color: AppColors.textDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'My Rides',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Empty state card ─────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 90, color: AppColors.textDark),
                      SizedBox(height: 12),
                      Text(
                        'Nothing here right now',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                          fontFamily: 'Roboto',
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
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}