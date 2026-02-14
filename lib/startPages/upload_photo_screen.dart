import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_theme.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final _urlCtrl  = TextEditingController();
  bool _loading   = false;
  String? _previewUrl;

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  // Preview the image when user finishes typing the URL
  void _onUrlChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('http')) {
      setState(() => _previewUrl = trimmed);
    } else {
      setState(() => _previewUrl = null);
    }
  }

  Future<void> _saveUrl(String role) async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      _showError('Please enter an image URL.');
      return;
    }
    if (!url.startsWith('http')) {
      _showError('Please enter a valid URL starting with http.');
      return;
    }

    setState(() => _loading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'photoUrl': url});

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/done', arguments: role);

    } catch (e) {
      _showError('Failed to save. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _skip(String role) async {
    // Save empty string and move on
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'photoUrl': ''});
    } catch (_) {}

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/done', arguments: role);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Roboto')),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'passenger';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload your Pic',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Paste a direct image URL (e.g. Google Drive)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // ── Image preview circle ───────────────────────────────
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEEEEEE),
                    border: Border.all(
                        color: const Color(0xFFCCCCCC), width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _previewUrl != null
                      ? Image.network(
                          _previewUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Color(0xFFBBBBBB),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 64,
                          color: Color(0xFFBBBBBB),
                        ),
                ),
                const SizedBox(height: 24),

                // ── URL input ──────────────────────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Image URL',
                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'https://...',
                  controller: _urlCtrl,
                  keyboardType: TextInputType.url,
                  suffixIcon: _urlCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              size: 18, color: AppColors.textGrey),
                          onPressed: () {
                            _urlCtrl.clear();
                            setState(() => _previewUrl = null);
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tip: In Google Drive, click Share → Anyone with link → Copy link,\nthen replace "/view" with "/uc?export=view"',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                      fontFamily: 'Roboto',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Save button ────────────────────────────────────────
                _loading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : AppButton(
                        label: 'Save Photo',
                        onPressed: () => _saveUrl(role),
                      ),
                const SizedBox(height: 12),

                // ── Skip ──────────────────────────────────────────────
                TextButton(
                  onPressed: () => _skip(role),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}