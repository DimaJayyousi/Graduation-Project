import 'package:flutter/material.dart';
import 'role_screen.dart';
import '../app_theme.dart';

class SeatOrderNoteScreen extends StatefulWidget {
  const SeatOrderNoteScreen({super.key});

  @override
  State<SeatOrderNoteScreen> createState() => _SeatOrderNoteScreenState();
}

class _SeatOrderNoteScreenState extends State<SeatOrderNoteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.forward());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ matches card so no gap visible
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, bottom + 24),
        child: AppButton(
          label: 'Next',
          onPressed: _goNext,
          color: const Color(0xFFD4A017),
          textColor: const Color(0xFF3A2E0A),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const _NoteHeader(),

              // White area fills everything below header, full width
              Expanded(
                child: const _ScrollableContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Header container
class _NoteHeader extends StatelessWidget {
  const _NoteHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(78, 69, 32, 1),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: const Text(
        'Note',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

// White full-width content area
class _ScrollableContent extends StatelessWidget {
  const _ScrollableContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white, // ✅ no BorderRadius, no shadow, full width
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            _SeatNumberImage(),
            SizedBox(height: 24),
            _DescriptionText(),
          ],
        ),
      ),
    );
  }
}

// Seat image
class _SeatNumberImage extends StatelessWidget {
  const _SeatNumberImage();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Image.asset(
      'Images/seatNumber.jpg',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

// Description text under the image
class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  static const TextStyle _normal = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15.5,
    height: 1.65,
    color: Color(0xFF1A1A1A),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _red = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15.5,
    height: 1.65,
    color: Color(0xFFE53935),
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: _normal,
        children: [
          TextSpan(
            text:
                'The image shows the seat layout. The numbers in the "Which seat do you want?" field match the seats shown.\n\n',
          ),
          TextSpan(text: '- Choose '),
          TextSpan(text: '"Back Row"', style: _red),
          TextSpan(text: ' to reserve all three back seats.\n'),
          TextSpan(text: '- Choose '),
          TextSpan(text: '"All"', style: _red),
          TextSpan(text: ' to reserve all four seats.'),
        ],
      ),
    );
  }
}