import 'package:flutter/material.dart';
import '../app_theme.dart';

class NoteScreen1 extends StatelessWidget {
  const NoteScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color.fromRGBO(78, 69, 32, 1),
      body: Column(
        children: [
          // ── Olive top section with title ──────────────────────
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Note',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),

          // ── White rounded card bottom section ─────────────────
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Bullet('Tal3 is a shared carpool community — not a private car. Ride together, not alone.'),
                  const SizedBox(height: 24),
                  const _Bullet('Share rides, split costs, and travel smarter together.'),
                  const SizedBox(height: 24),
                  const _Bullet('Arrive a little early to keep things smooth. Showing up a few minutes before your driver arrives helps ensure a stress-free ride.'),
                  const SizedBox(height: 24),
                  const _Bullet('Carpooling helps keep travel affordable while building a friendly, trust-based community.'),
                  const Spacer(),
                  AppButton(
                    label: 'Next',
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/note2'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 8, color: AppColors.textDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontFamily: 'Roboto',
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}