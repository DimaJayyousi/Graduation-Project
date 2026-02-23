import 'package:flutter/material.dart';
import '../app_theme.dart';

const Color _goldColor  = Color(0xFFD4A017);
const Color _creamLight = Color(0xFFFFF8DC);

class ReviewTripScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final String date;
  final String time;
  final int seats;
  final Future<void> Function() onConfirm;

  const ReviewTripScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
    required this.time,
    required this.seats,
    required this.onConfirm,
  });

  @override
  State<ReviewTripScreen> createState() => _ReviewTripScreenState();
}

class _ReviewTripScreenState extends State<ReviewTripScreen> {
  bool _loading = false;

  Future<void> _onYes() async {
    setState(() => _loading = true);
    await widget.onConfirm();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Back arrow ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left,
                      size: 30, color: AppColors.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // ── Logo ─────────────────────────────────────────
                    const Text(
                      'Tal3',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Title ─────────────────────────────────────────
                    const Text(
                      'Review Trip',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Date & Time ───────────────────────────────────
                    Text(
                      '${widget.date}  ${widget.time}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Info card ─────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _creamLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Origin
                          Row(
                            children: [
                              const Text('Origin:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                              const Spacer(),
                              const Icon(Icons.location_on,
                                  size: 16, color: AppColors.textDark),
                              const SizedBox(width: 4),
                              Text(widget.origin,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Destination
                          Row(
                            children: [
                              const Text('Destination:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                              const Spacer(),
                              const Icon(Icons.location_on,
                                  size: 16, color: AppColors.textDark),
                              const SizedBox(width: 4),
                              Text(widget.destination,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Seats
                          Row(
                            children: [
                              const Text('Seats:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                              const Spacer(),
                              Text('${widget.seats} seats offered',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                                color: AppColors.textDark,
                                thickness: 0.5),
                          ),

                          const Center(
                            child: Text(
                              'Your trip is ready to be posted!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Confirmation question ─────────────────────────
                    const Text(
                      'Are you sure you want to post this trip?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Yes / Cancel buttons ──────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _onYes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _goldColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5))
                                  : const Text('Yes',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _loading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: _goldColor, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: AppColors.textDark)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}