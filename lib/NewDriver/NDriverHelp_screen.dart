import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../bottom_nav.dart';

class DriverHelpScreen extends StatelessWidget {
  const DriverHelpScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 4) return;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Scrollable content ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'For\nDrivers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Start a ride and get paid when you're driving from A to B!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        fontFamily: 'Roboto',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Steps card ───────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          _Step(
                            number: '1',
                            title: 'Search',
                            description:
                                'Use the Search page to view ongoing and upcoming trips. Drivers can compare destinations and see where trips are already active to decide whether to start a trip to a different location.',
                          ),
                          SizedBox(height: 28),
                          _Step(
                            number: '2',
                            title: 'Post a trip',
                            description:
                                'Enter your origin, destination, schedule, price and additional information regarding your trip.',
                          ),
                          SizedBox(height: 28),
                          _Step(
                            number: '3',
                            title: 'Receive bookings',
                            description:
                                'You will receive bookings from passengers in your trip',
                          ),
                          SizedBox(height: 28),
                          _Step(
                            number: '4',
                            title: 'Pickup Passengers',
                            description:
                                'Once the driver is fully booked, passengers are picked up from their start locations.',
                          ),
                          SizedBox(height: 28),
                          _Step(
                            number: '5',
                            title: 'Enjoy the drive',
                            description:
                                'Meet the passengers at their pickup locations and start a comfortable, shared ride.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Seats order ──────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Seats order',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'This is the order of the seats so in the which seat you want field the number represent the same seat from the image, passengers can choose the seat they want in your car.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                          fontFamily: 'Roboto',
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Seat diagram ─────────────────────────────
                    Image.asset(
                      'Images/seatNumber.jpg',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 32),

                    // ── Legal section ────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Yes, it's legal and safe!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tal3 operates under provincial carpooling regulations in Jordan.',
                        style: TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto', height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _BulletItem('Provide your vehicle information and personal information.'),
                    const _BulletItem('Report and block other members directly in our app'),
                    const _BulletItem('Cover your gas costs and carpool with your car insurance'),

                    const SizedBox(height: 32),

                    // ── Get paid section ─────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Get paid after every trip',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'receive money after each and every trip.',
                        style: TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _BulletItem('Get paid in cash or cliq.'),

                    const SizedBox(height: 32),

                    // ── Please note card ─────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Please note the following',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Center(
                            child: Text(
                              'For a smooth ride without any conflict',
                              style: TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          _BulletItem('Make sure to specify your vehicle details and preferences accurately.'),
                          SizedBox(height: 6),
                          _BulletItem("Try not to cancel the trip unless it's an emergency"),
                          SizedBox(height: 6),
                          _BulletItem("If you didn't like a passenger and you want to block this passenger tell us the reason so we can make an action if necessary"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 4,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

// ── Step widget ───────────────────────────────────────────────────────────────
class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _Step({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textDark,
            fontFamily: 'Roboto',
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Bullet item ───────────────────────────────────────────────────────────────
class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.textDark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontFamily: 'Roboto', height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}