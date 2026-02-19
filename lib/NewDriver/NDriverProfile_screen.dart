import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final int _navIndex = 3;
  String _name = '';
  String _bio = '';
  String _photoUrl = '';
  double _rating = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        setState(() {
          _name     = data['name']     ?? '';
          _bio      = data['bio']      ?? '';
          _photoUrl = data['photoUrl'] ?? '';
          _rating   = (data['rating'] as num?)?.toDouble() ?? 0.0;
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
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
      case 4:
        Navigator.pushReplacementNamed(context, '/driver-help');
        break;
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Gold header ─────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
              left: 20,
            ),
            child: const Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.textDark),
            ),
          ),

          const SizedBox(height: 28),

          // ── Avatar + info ───────────────────────────────────────
          _loading
              ? const CircularProgressIndicator(color: AppColors.primary)
              : Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
                        color: const Color(0xFFEEEEEE),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _photoUrl.isNotEmpty
                          ? Image.network(_photoUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 48, color: Color(0xFFBBBBBB)))
                          : const Icon(Icons.person, size: 48, color: Color(0xFFBBBBBB)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _name.isNotEmpty ? _name : "Driver's name",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.textDark),
                        ),
                        const SizedBox(width: 8),
                        Text(_rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textDark)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: AppColors.primary, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _bio.isNotEmpty ? _bio : 'Bio',
                      style: const TextStyle(fontSize: 13, color: AppColors.textGrey, fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/driver-edit-profile');
                        if (mounted) _loadProfile();
                      },
                      child: const Text(
                        'Edit profile',
                        style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontFamily: 'Roboto', decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),

          const SizedBox(height: 32),

          // ── Menu items ──────────────────────────────────────────
          _MenuItem(
            icon: Icons.history,
            label: 'My Rides',
            onTap: () => Navigator.pushNamed(context, '/driver-my-rides'),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _MenuItem(
            icon: Icons.star_border,
            label: 'Ratings',
            onTap: () => Navigator.pushNamed(context, '/driver-ratings'),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _MenuItem(
            icon: Icons.logout,
            label: 'Logout',
            iconColor: AppColors.errorRed,
            onTap: _logout,
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),

          const Spacer(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor ?? AppColors.textDark),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: iconColor ?? AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}