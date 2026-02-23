import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverTripsScreen extends StatefulWidget {
  const DriverTripsScreen({super.key});

  @override
  State<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends State<DriverTripsScreen>
    with SingleTickerProviderStateMixin {
  final int _navIndex = 1;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/driver-home');
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

  void _openPostTrip() {
    Navigator.pushNamed(context, '/post-ride');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.textDark,
                    unselectedLabelColor: AppColors.textGrey,
                    indicator: const UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: AppColors.textDark, width: 2.5),
                    ),
                    tabs: const [
                      Tab(text: 'Active'),
                      Tab(text: 'Recent'),
                      Tab(text: 'Canceled'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      _EmptyTripsCard(
                          message: 'No Trips',
                          subtitle:
                              'Once you post a trip it will appear here.'),
                      _EmptyTripsCard(message: 'Nothing here right now'),
                      _EmptyTripsCard(message: 'Nothing here right now'),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              right: 20,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: AppColors.textDark,
                onPressed: _openPostTrip,
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
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

class _EmptyTripsCard extends StatelessWidget {
  final String message;
  final String? subtitle;

  const _EmptyTripsCard({required this.message, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subtitle != null) ...[
              Text(message,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                      fontFamily: 'Roboto'),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
            ],
            Icon(Icons.location_on,
                size: subtitle != null ? 90 : 110,
                color: AppColors.textDark),
          ],
        ),
      ),
    );
  }
}