import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';
import 'ReviewTripScreen.dart';

const Color _goldColor    = Color(0xFFD4A017);
const Color _creamLight   = Color(0xFFFFF8DC);
const Color _dividerColor = Color(0xFFD4A017);

class PostATripScreen extends StatefulWidget {
  const PostATripScreen({super.key});

  @override
  State<PostATripScreen> createState() => _PostATripScreenState();
}

class _PostATripScreenState extends State<PostATripScreen> {
  final _originCtrl      = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _stopsCtrl       = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _departureDate = '';
  String _departureTime = '';

  int _luggage  = -1;
  int _pets     = -1;
  int _smoking  = -1;
  int _chatting = -1;
  int _seats    = -1;

  bool _agreed     = false;
  bool _publishing = false;

  @override
  void dispose() {
    _originCtrl.dispose();
    _destinationCtrl.dispose();
    _stopsCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _goldColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _departureDate =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _goldColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _departureTime = picked.format(context));
    }
  }

  void _goToReview() {
    if (_originCtrl.text.trim().isEmpty ||
        _destinationCtrl.text.trim().isEmpty) {
      _snack('Please enter origin and destination.');
      return;
    }
    if (_departureDate.isEmpty || _departureTime.isEmpty) {
      _snack('Please select departure date and time.');
      return;
    }
    if (_luggage == -1 || _pets == -1 ||
        _smoking == -1 || _chatting == -1) {
      _snack('Please select all trip preferences.');
      return;
    }
    if (_seats == -1) {
      _snack('Please select number of seats.');
      return;
    }
    if (!_agreed) {
      _snack('Please agree to the Terms of Service.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewTripScreen(
          origin:      _originCtrl.text.trim(),
          destination: _destinationCtrl.text.trim(),
          date:        _departureDate,
          time:        _departureTime,
          seats:       _seats,
          onConfirm:   _postTrip,
        ),
      ),
    );
  }

  Future<void> _postTrip() async {
    setState(() => _publishing = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Not logged in');

      final driverDoc  = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final driverData = driverDoc.data() ?? {};

      await FirebaseFirestore.instance.collection('rides').add({
        'driverId':       uid,
        'driverName':     driverData['fullName']  ?? '',
        'driverPhoto':    driverData['photoUrl']  ?? '',
        'driverRating':   driverData['rating']    ?? 0.0,
        'vehicle':        driverData['vehicle']   ?? {},
        'origin':         _originCtrl.text.trim(),
        'destination':    _destinationCtrl.text.trim(),
        'stops':          _stopsCtrl.text.trim(),
        'departureDate':  _departureDate,
        'departureTime':  _departureTime,
        'preferences': {
          'luggage':  _luggage,
          'pets':     _pets,
          'smoking':  _smoking,
          'chatting': _chatting,
        },
        'seats':          _seats,
        'availableSeats': _seats,
        'description':    _descriptionCtrl.text.trim(),
        'status':         'active',
        'createdAt':      FieldValue.serverTimestamp(),
        'bookings':       [],
      });

      if (!mounted) return;
      _showSuccess();
    } catch (_) {
      if (!mounted) return;
      _snack('Failed to post trip. Please try again.');
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'Roboto')),
      backgroundColor: AppColors.errorRed,
    ));
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    color: _creamLight, shape: BoxShape.circle),
                child: const Icon(Icons.check,
                    size: 40, color: _goldColor),
              ),
              const SizedBox(height: 18),
              const Text('Trip Posted!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto')),
              const SizedBox(height: 8),
              const Text(
                'Your trip is now visible to passengers.\nThey can view it on their trips screen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontFamily: 'Roboto',
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _goldColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Done',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

            // ── Scrollable content ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Title
                    const Center(
                      child: Text('Post a trip',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: AppColors.textDark)),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        "Cover your driving costs by filling your seats when\nyou're driving from A to B",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textGrey,
                            fontFamily: 'Roboto',
                            height: 1.4),
                      ),
                    ),

                    _dividerLine(),

                    // ── ITINERARY ─────────────────────────────────────
                    _sectionTitle('Itinerary'),
                    const SizedBox(height: 4),
                    const Text(
                      "Your origin, destination, and stops you're willing to\nmake along the way.",
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontFamily: 'Roboto',
                          height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    _itineraryRow('Origin', _originCtrl, 'Enter an origin'),
                    const SizedBox(height: 10),
                    _itineraryRow('Destination', _destinationCtrl,
                        'Enter a destination'),
                    const SizedBox(height: 10),
                    _itineraryRow('Stops', _stopsCtrl, 'Enter stops'),

                    _dividerLine(),

                    // ── RIDE SCHEDULE ─────────────────────────────────
                    _sectionTitle('Ride Schedule'),
                    const SizedBox(height: 4),
                    const Text('Enter a precise date and time.',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                            fontFamily: 'Roboto')),
                    const SizedBox(height: 16),
                    _scheduleRow(
                        'Leaving',
                        _departureDate.isEmpty
                            ? 'Departure date'
                            : _departureDate,
                        _pickDate),
                    const SizedBox(height: 10),
                    _scheduleRow(
                        'At',
                        _departureTime.isEmpty ? 'Time' : _departureTime,
                        _pickTime),

                    _dividerLine(),

                    // ── TRIP PREFERENCES ──────────────────────────────
                    _sectionTitle('Trip preferences'),
                    const SizedBox(height: 4),
                    const Text(
                      'This informs passengers of how much space you have\nfor their luggage and extras before they book.',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontFamily: 'Roboto',
                          height: 1.4),
                    ),
                    const SizedBox(height: 16),

                    _prefRow(
                      label: 'Luggage',
                      child: _LuggageSML(
                        value: _luggage,
                        onChanged: (v) => setState(() => _luggage = v),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _prefRow(
                      label: 'Pets',
                      child: _IconToggle2(
                        value: _pets,
                        icon1: Icons.pets,
                        icon2: Icons.pets,
                        crossed2: true,
                        onChanged: (v) => setState(() => _pets = v),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _prefRow(
                      label: 'Smoking',
                      child: _IconToggle2(
                        value: _smoking,
                        icon1: Icons.smoking_rooms,
                        icon2: Icons.smoke_free,
                        crossed2: false,
                        onChanged: (v) => setState(() => _smoking = v),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _prefRow(
                      label: 'chatting',
                      child: _IconToggle2(
                        value: _chatting,
                        icon1: Icons.chat_bubble_outline,
                        icon2: Icons.chat_bubble_outline,
                        crossed2: true,
                        onChanged: (v) => setState(() => _chatting = v),
                      ),
                    ),

                    _dividerLine(),

                    // ── NUMBER OF SEATS ───────────────────────────────
                    _sectionTitle('Number of empty seats'),
                    const SizedBox(height: 14),
                    _SeatsSelector(
                      value: _seats,
                      onChanged: (v) => setState(() => _seats = v),
                    ),

                    _dividerLine(),

                    // ── TRIP DESCRIPTION ──────────────────────────────
                    _sectionTitle('Trip description'),
                    const SizedBox(height: 4),
                    const Text(
                      'Add any details relevant to your trip for passengers\nbefore they book.',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontFamily: 'Roboto',
                          height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text('Description',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Roboto',
                                    color: AppColors.textDark)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _creamLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _descriptionCtrl,
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  color: AppColors.textDark),
                              decoration: const InputDecoration(
                                hintText:
                                    'We recommend writing the exact pick-up and drop-off locations.',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                    fontFamily: 'Roboto',
                                    height: 1.4),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    _dividerLine(),

                    // ── RULES ─────────────────────────────────────────
                    _sectionTitle('Rules when posting a trip'),
                    const SizedBox(height: 10),
                    _ruleText('Be reliable:',
                        " Only post a trip if you're sure you're driving and show up on time."),
                    const SizedBox(height: 6),
                    _ruleText('Drive safely:',
                        ' Stick to the speed limit and do not use your phone while driving.'),
                    const SizedBox(height: 16),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _agreed,
                            onChanged: (v) =>
                                setState(() => _agreed = v ?? false),
                            activeColor: _goldColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(
                                color: Color(0xFFCCCCCC)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Roboto',
                                  color: AppColors.textDark,
                                  height: 1.5),
                              children: [
                                TextSpan(
                                    text: 'I agree to these rules, to the '),
                                TextSpan(
                                    text: 'Terms Of Service',
                                    style: TextStyle(
                                        decoration:
                                            TextDecoration.underline,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(text: ', and the '),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        decoration:
                                            TextDecoration.underline,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(text: ', and '),
                                TextSpan(
                                    text:
                                        'I understand that my account could be suspended if I break the rules.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── POST TRIP BUTTON ──────────────────────────────
                    _publishing
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: _goldColor))
                        : SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _goToReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _goldColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14)),
                              ),
                              child: const Text('Post Trip',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: Colors.white)),
                            ),
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

  Widget _dividerLine() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Container(
            height: 1.5, color: _dividerColor.withOpacity(0.35)),
      );

  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: AppColors.textDark));

  Widget _itineraryRow(
      String label, TextEditingController ctrl, String hint) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  color: AppColors.textDark)),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
                color: _creamLight,
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: ctrl,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppColors.textGrey, fontSize: 12),
                prefixIcon: const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.textGrey),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scheduleRow(
      String label, String value, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  color: AppColors.textDark)),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: _creamLight,
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    color: value.contains('/') || value.contains('M')
                        ? AppColors.textDark
                        : AppColors.textGrey,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _prefRow({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  color: AppColors.textDark)),
        ),
        child,
      ],
    );
  }

  Widget _ruleText(String bold, String normal) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 11,
            fontFamily: 'Roboto',
            color: AppColors.textDark,
            height: 1.4),
        children: [
          TextSpan(
              text: bold,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: normal),
        ],
      ),
    );
  }
}

// ── Luggage S / M / L ────────────────────────────────────────────────────────
class _LuggageSML extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _LuggageSML({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const labels = ['S', 'M', 'L'];
    return Row(
      children: List.generate(3, (i) {
        final selected = value == i;
        final color =
            selected ? Colors.white : const Color(0xFF8B7355);
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 60,
            height: 38,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFD4A017)
                  : const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.luggage, size: 18 + (i * 3.0), color: color),
                Positioned(
                  bottom: 3,
                  right: 5,
                  child: Text(labels[i],
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: color)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── 2-option toggle with optional cross ──────────────────────────────────────
class _IconToggle2 extends StatelessWidget {
  final int value;
  final IconData icon1;
  final IconData icon2;
  final bool crossed2;
  final ValueChanged<int> onChanged;

  const _IconToggle2({
    required this.value,
    required this.icon1,
    required this.icon2,
    required this.crossed2,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (i) {
        final selected = value == i;
        final color =
            selected ? Colors.white : const Color(0xFF8B7355);
        final isCrossed = i == 1 && crossed2;

        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 60,
            height: 38,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFD4A017)
                  : const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isCrossed
                ? CustomPaint(
                    painter: _CrossPainter(color),
                    child: Icon(i == 0 ? icon1 : icon2,
                        size: 20, color: color),
                  )
                : Icon(i == 0 ? icon1 : icon2, size: 20, color: color),
          ),
        );
      }),
    );
  }
}

// ── Cross painter ─────────────────────────────────────────────────────────────
class _CrossPainter extends CustomPainter {
  final Color color;
  _CrossPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CrossPainter old) => old.color != color;
}

// ── Seats selector 1–4 ───────────────────────────────────────────────────────
class _SeatsSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _SeatsSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final num = i + 1;
        final selected = value == num;
        return GestureDetector(
          onTap: () => onChanged(num),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 52,
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFD4A017)
                  : const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? const Color(0xFFD4A017)
                    : const Color(0xFFE0D5B0),
              ),
            ),
            alignment: Alignment.center,
            child: Text('$num',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: selected
                      ? Colors.white
                      : const Color(0xFF8B7355),
                )),
          ),
        );
      }),
    );
  }
}