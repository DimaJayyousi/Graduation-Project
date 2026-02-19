import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class TripsScreen extends StatefulWidget {
  final int initialTab; // 0=Active, 1=Recent, 2=Canceled
  const TripsScreen({super.key, this.initialTab = 0});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  late int _selectedTab;
  final int _navIndex = 1; // trips is index 1 in bottom nav

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Tab bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  _Tab(label: 'Active',   index: 0, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                  const SizedBox(width: 24),
                  _Tab(label: 'Recent',   index: 1, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                  const SizedBox(width: 24),
                  _Tab(label: 'Canceled', index: 2, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: _buildContent(),
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

  Widget _buildContent() {
    // Cancel  & Recent: "Nothing here right now" with location pin
    // Active: "No Trips" with different text
    if (_selectedTab == 0) {
      return _EmptyState(
        icon: Icons.location_on,
        title: 'No Trips',
        subtitle: 'Once you join a trip it will appear here.',
      );
    }
    return _EmptyState(
      icon: Icons.location_on,
      title: '',
      subtitle: 'Nothing here right now',
    );
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/passenger-home');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat');
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

// ── Tab widget ────────────────────────────────────────────────────────────────
class _Tab extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _Tab({
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          // Underline for selected tab
          Container(
            height: 2,
            width: label.length * 8.5,
            color: isSelected ? AppColors.textDark : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// ── Empty state widget ────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textDark),
            const SizedBox(height: 16),
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}