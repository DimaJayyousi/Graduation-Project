import 'package:flutter/material.dart';

class PassengerHelpScreen extends StatefulWidget {
  const PassengerHelpScreen({super.key});

  @override
  State<PassengerHelpScreen> createState() => _PassengerHelpScreenState();
}

class _PassengerHelpScreenState extends State<PassengerHelpScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double>   _fadeAnim;

  // ── colours ─────────────────────────────────
  static const Color _amber       = Color(0xFFF39E21);
  static const Color _lightYellow = Color(0xFFF9CD46);
  static const Color _stepBg      = Color(0xFFFFF8E1);
  static const Color _stepBorder  = Color(0xFFF9CD46);
  static const Color _noteBg      = Color(0xFFFFF3CD);
  static const Color _noteBorder  = Color(0xFFF9CD46);
  static const Color _textDark    = Color(0xFF1A1A1A);
  static const Color _textGrey    = Color(0xFF555555);
  static const Color _red         = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.forward());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── 5 steps data ────────────────────────────
  static const List<_StepData> _steps = [
    _StepData(
      number: '1',
      title:  'Search',
      body:   "Choose where you're traveling from and to either from your Governorate to Amman or from Amman to another Governorate. Prices may vary depending on the route.",
    ),
    _StepData(
      number: '2',
      title:  'Choose your seat',
      body:   "Pick the seat you're most comfortable with. Each seat has a different price.\nYou can also reserve the entire back row for yourself by selecting the Back Row option, which has a different cost.",
    ),
    _StepData(
      number: '3',
      title:  'Find a ride',
      body:   "Browse available rides and choose the car that works best for you.\nYou'll be able to see details about the driver and other passengers who booked the ride.",
    ),
    _StepData(
      number: '4',
      title:  'Book the ride',
      body:   "Once you find a ride that suits you, book it and confirm your order.\nThe driver will receive a notification with your booking details.",
    ),
    _StepData(
      number: '5',
      title:  'Enjoy the drive',
      body:   'Meet the driver at the pickup location and enjoy a comfortable, shared ride.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── TOP BAR ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: top + 8, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size:  22,
                      color: _textDark,
                    ),
                  ),
                ),
              ),
            ),

            // ── HEADER ────────────────────────
            const SliverToBoxAdapter(
              child: _PageHeader(),
            ),

            // ── 5 STEPS ───────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _StepCard(step: _steps[i]),
                  ),
                  childCount: _steps.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── SECTION: SEATS ORDER ──────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:   _SeatsOrderSection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── SECTION: TRAVEL SAFELY ────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:   _TravelSafelySection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── SECTION: BOOK AND PAY ─────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:   _BookAndPaySection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── SECTION: PLEASE NOTE ──────────
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 32),
              sliver: const SliverToBoxAdapter(
                child: _PleaseNoteSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _PageHeader
// ─────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        children: const [
          Text(
            'For\nPassengers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily:    'Roboto',
              fontSize:      32,
              fontWeight:    FontWeight.w900,
              color:         Color(0xFF1A1A1A),
              height:        1.2,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Get a ride with someone in their car, it's\naffordable and convenient",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize:   13.5,
              color:      Color(0xFF666666),
              height:     1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _StepData  — immutable step model
// ─────────────────────────────────────────────
class _StepData {
  const _StepData({
    required this.number,
    required this.title,
    required this.body,
  });
  final String number;
  final String title;
  final String body;
}

// ─────────────────────────────────────────────
//  _StepCard
// ─────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});
  final _StepData step;

  static const Color _bg     = Color(0xFFFFF8E1);
  static const Color _border = Color(0xFFF9CD46);
  static const Color _amber  = Color(0xFFF39E21);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:        _bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border, width: 1.5),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          // Circle number badge
          Container(
            width:  44,
            height: 44,
            decoration: const BoxDecoration(
              color: _amber,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.number,
                style: const TextStyle(
                  fontFamily:  'Roboto',
                  fontSize:    20,
                  fontWeight:  FontWeight.w800,
                  color:       Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily:  'Roboto',
              fontSize:    17,
              fontWeight:  FontWeight.w700,
              color:       Color(0xFF1A1A1A),
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 8),

          // Body
          Text(
            step.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize:   13.5,
              color:      Color(0xFF444444),
              height:     1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _SeatsOrderSection
// ─────────────────────────────────────────────
class _SeatsOrderSection extends StatelessWidget {
  const _SeatsOrderSection();

  static const Color _red   = Color(0xFFE53935);
  static const Color _amber = Color(0xFFF39E21);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Real seat diagram image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'Images/seatNumber.jpg',
            width:  double.infinity,
            fit:    BoxFit.contain,
          ),
        ),

        const SizedBox(height: 18),

        // Section title
        const Text(
          'Seats order',
          style: TextStyle(
            fontFamily:  'Roboto',
            fontSize:    22,
            fontWeight:  FontWeight.w800,
            color:       Color(0xFF1A1A1A),
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 10),

        // Description
        const Text(
          'This is the order of the seats so in the which seat you want field the number represent  the same seat from the image .',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize:   14,
            color:      Color(0xFF444444),
            height:     1.6,
          ),
        ),

        const SizedBox(height: 10),

        // Back Row bullet
        _RichBullet(
          prefix: 'If you choose the ',
          highlight: 'Back row',
          suffix:  ' option that mean you reserve all the 3 seats in the back.',
          highlightColor: _amber,
        ),

        const SizedBox(height: 6),

        // All bullet
        _RichBullet(
          prefix: 'If you choose the ',
          highlight: 'All',
          suffix:  ' option that mean you reserve all the 4 seats .',
          highlightColor: _amber,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  _TravelSafelySection
// ─────────────────────────────────────────────
class _TravelSafelySection extends StatelessWidget {
  const _TravelSafelySection();

  static const List<String> _bullets = [
    'You choose who you\'re carpooling with',
    'Report and block other members directly in our app',
    'we provide customer service 7 days a week',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Real travel safely image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'Images/drivesafenote.png',
            width:  double.infinity,
            fit:    BoxFit.contain,
          ),
        ),

        const SizedBox(height: 18),

        // Section title
        const Text(
          'Travel safely',
          style: TextStyle(
            fontFamily:  'Roboto',
            fontSize:    22,
            fontWeight:  FontWeight.w800,
            color:       Color(0xFF1A1A1A),
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'we verify every driver\'s license and monitor activity closely',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize:   14,
            color:      Color(0xFF444444),
            height:     1.55,
          ),
        ),

        const SizedBox(height: 12),

        // Bullet list
        ..._bullets.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _SimpleBullet(text: b),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  _BookAndPaySection
// ─────────────────────────────────────────────
class _BookAndPaySection extends StatelessWidget {
  const _BookAndPaySection();

  static const List<String> _bullets = [
    'We accept Click or Cash',
    'The driver is paid after the trip is complete',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Real payment image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'Images/payment-note.png',
            width:  double.infinity,
            fit:    BoxFit.contain,
          ),
        ),

        const SizedBox(height: 18),

        // Section title
        const Text(
          'Book and pay',
          style: TextStyle(
            fontFamily:  'Roboto',
            fontSize:    22,
            fontWeight:  FontWeight.w800,
            color:       Color(0xFF1A1A1A),
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'reserve your seats, meet the driver and go.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize:   14,
            color:      Color(0xFF444444),
            height:     1.55,
          ),
        ),

        const SizedBox(height: 12),

        // Bullet list
        ..._bullets.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _SimpleBullet(text: b),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  _PleaseNoteSection  — amber bordered card
// ─────────────────────────────────────────────
class _PleaseNoteSection extends StatelessWidget {
  const _PleaseNoteSection();

  static const List<String> _bullets = [
    'Be ready before 10 minute from the driver expected time to arrive',
    "Try not to cancel the trip unless it's an emergency",
    "If you didn't like a driver and you want to block him tell us the reason so we can make an action if necessary",
  ];

  static const Color _bg     = Color(0xFFFFF8E1);
  static const Color _border = Color(0xFFF9CD46);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:        _bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border, width: 1.5),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            'Please note the following',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily:  'Roboto',
              fontSize:    17,
              fontWeight:  FontWeight.w800,
              color:       Color(0xFF1A1A1A),
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'For a smooth ride without any conflict',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize:   13,
              color:      Color(0xFF666666),
              height:     1.5,
            ),
          ),

          const SizedBox(height: 14),

          // Bullet list — left aligned
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SimpleBullet(text: b),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  _SimpleBullet  — • text
// ─────────────────────────────────────────────
class _SimpleBullet extends StatelessWidget {
  const _SimpleBullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6, right: 8),
          child: CircleAvatar(
            radius:          3,
            backgroundColor: Color(0xFF1A1A1A),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize:   13.5,
              color:      Color(0xFF444444),
              height:     1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  _RichBullet  — • text with highlighted word
// ─────────────────────────────────────────────
class _RichBullet extends StatelessWidget {
  const _RichBullet({
    required this.prefix,
    required this.highlight,
    required this.suffix,
    required this.highlightColor,
  });

  final String prefix;
  final String highlight;
  final String suffix;
  final Color  highlightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6, right: 8),
          child: CircleAvatar(
            radius:          3,
            backgroundColor: Color(0xFF1A1A1A),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize:   13.5,
                color:      Color(0xFF444444),
                height:     1.6,
              ),
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: highlight,
                  style: TextStyle(
                    color:      highlightColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: suffix),
              ],
            ),
          ),
        ),
      ],
    );
  }
}