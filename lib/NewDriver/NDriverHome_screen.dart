import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final int _navIndex = 0;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
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
          children: [
            // ── Top bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to create trip screen
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textDark, width: 1.5),
                      ),
                      child: const Icon(Icons.add, size: 22, color: AppColors.textDark),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Tal3',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Welcome card ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // TODO: navigate to create trip screen
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                  decoration: BoxDecoration(
                    color: AppColors.creamBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Roboto')),
                            SizedBox(height: 4),
                            Text('Ready to plan your first trip?',
                                style: TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto')),
                            SizedBox(height: 2),
                            Text('Start',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Roboto')),
                          ],
                        ),
                      ),
                      Icon(Icons.car_rental, size: 52, color: AppColors.textDark),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Search bar ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14, fontFamily: 'Roboto'),
                    prefixIcon: Icon(Icons.search, color: AppColors.textGrey, size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const Expanded(child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

























