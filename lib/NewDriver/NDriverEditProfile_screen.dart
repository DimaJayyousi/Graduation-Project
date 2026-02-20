
   import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tal3/NewDriver/VehicleDetails_Screen.dart';
import '../app_theme.dart';


class DriverEditProfileScreen extends StatefulWidget {
  const DriverEditProfileScreen({super.key});

  @override
  State<DriverEditProfileScreen> createState() => _DriverEditProfileScreenState();
}

class _DriverEditProfileScreenState extends State<DriverEditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl  = TextEditingController();
  String _gender  = 'Male';
  bool _loading   = false;
  bool _saving    = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        setState(() {
          _nameCtrl.text = data['name']   ?? '';
          _bioCtrl.text  = data['bio']    ?? '';
          _gender        = data['gender'] ?? 'Male';
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full name cannot be empty.', style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name':   _nameCtrl.text.trim(),
        'bio':    _bioCtrl.text.trim(),
        'gender': _gender,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!', style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: AppColors.primary,
        ),
      );
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Gold header ──────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(4, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 28, color: AppColors.textDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Avatar with camera icon ────────────────
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
                                color: const Color(0xFFEEEEEE),
                              ),
                              child: const Icon(Icons.person, size: 44, color: Color(0xFFBBBBBB)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.textDark,
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Full Name ──────────────────────────────
                      const Text('Full Name', style: TextStyle(fontSize: 13, fontFamily: 'Roboto', color: AppColors.textDark)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          hintText: 'Enter full name...',
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
                      ),

                      const SizedBox(height: 16),

                      // ── Bio ────────────────────────────────────
                      const Text('Bio', style: TextStyle(fontSize: 13, fontFamily: 'Roboto', color: AppColors.textDark)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _bioCtrl,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          hintText: 'Insert or Change your bio',
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
                      ),

                      const SizedBox(height: 16),

                      // ── Gender ─────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('What is your gender?',
                                style: TextStyle(fontSize: 13, fontFamily: 'Roboto', color: AppColors.textDark)),
                            RadioListTile<String>(
                              value: 'Male',
                              groupValue: _gender,
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Male', style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                              onChanged: (v) => setState(() => _gender = v!),
                            ),
                            RadioListTile<String>(
                              value: 'Female',
                              groupValue: _gender,
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Female', style: TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                              onChanged: (v) => setState(() => _gender = v!),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Edit vehicle details ───────────────────
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DriverVehicleDetailsScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFCCCCCC)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edit vehicle Details',
                                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.textDark)),
                              Icon(Icons.chevron_right, size: 22, color: AppColors.textDark),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Save button ────────────────────────────
                      _saving
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : AppButton(label: 'Save', onPressed: _save),
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