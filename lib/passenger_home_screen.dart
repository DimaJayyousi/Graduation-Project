import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _currentIndex = 0;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user's display name if available
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── App title ──────────────────────────────────────────
                    const Center(
                      child: Text(
                        'Tal3',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Welcome card ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Text side
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Ready to book your first trip?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Roboto',
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: navigate to search/book trip
                                  },
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Icon side
                          const Icon(
                            Icons.car_rental,
                            size: 56,
                            color: AppColors.textDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Search bar ─────────────────────────────────────────
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'Roboto'),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                          ),
                          prefixIcon: Icon(Icons.search,
                              color: AppColors.textDark, size: 22),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    // ── Trip results will go here ──────────────────────────
                    // (empty for now, trips list to be added later)
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // ── Bottom nav ────────────────────────────────────────────────
            AppBottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}