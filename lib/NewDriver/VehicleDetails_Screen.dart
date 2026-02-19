import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';

class DriverVehicleDetailsScreen extends StatefulWidget {
  const DriverVehicleDetailsScreen({super.key});

  @override
  State<DriverVehicleDetailsScreen> createState() => _DriverVehicleDetailsScreenState();
}

class _DriverVehicleDetailsScreenState extends State<DriverVehicleDetailsScreen> {
  final _modelCtrl = TextEditingController();
  final _yearCtrl  = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _typeCtrl  = TextEditingController();
  final _plateCtrl = TextEditingController();
  bool _loading    = false;
  bool _saving     = false;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  @override
  void dispose() {
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _colorCtrl.dispose();
    _typeCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadVehicle() async {
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        final vehicle = data['vehicle'] as Map<String, dynamic>? ?? {};
        setState(() {
          _modelCtrl.text = vehicle['model'] ?? '';
          _yearCtrl.text  = vehicle['year']  ?? '';
          _colorCtrl.text = vehicle['color'] ?? '';
          _typeCtrl.text  = vehicle['type']  ?? '';
          _plateCtrl.text = vehicle['plate'] ?? '';
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'vehicle': {
          'model': _modelCtrl.text.trim(),
          'year':  _yearCtrl.text.trim(),
          'color': _colorCtrl.text.trim(),
          'type':  _typeCtrl.text.trim(),
          'plate': _plateCtrl.text.trim(),
        },
      });
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save. Please try again.', style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ──────────────────────────────────
                        const Center(
                          child: Text(
                            'Vehicle Details',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This Details is so important you need to make sure all the information is correct',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textGrey,
                            fontFamily: 'Roboto',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Fields ─────────────────────────────────
                        _label('Car Model'),
                        _field(_modelCtrl, 'Enter your car model'),
                        const SizedBox(height: 16),

                        _label('Year'),
                        _field(_yearCtrl, 'Enter car year', type: TextInputType.number),
                        const SizedBox(height: 16),

                        _label('Color'),
                        _field(_colorCtrl, 'Enter your car color'),
                        const SizedBox(height: 16),

                        _label('Type'),
                        _field(_typeCtrl, 'Enter your car type'),
                        const SizedBox(height: 16),

                        _label('Plate'),
                        _field(_plateCtrl, '#######'),
                        const SizedBox(height: 32),

                        // ── Done button ────────────────────────────
                        _saving
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                            : AppButton(label: 'Done', onPressed: _save),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 13, fontFamily: 'Roboto', color: AppColors.textDark)),
      );

  Widget _field(TextEditingController ctrl, String hint, {TextInputType? type}) =>
      TextField(
        controller: ctrl,
        keyboardType: type,
        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      );
}