import 'package:flutter/material.dart';
import '../app_theme.dart';

class UploadPhotoScreen extends StatelessWidget {
  const UploadPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'passenger';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
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
                  'Now you need to upload your personal picture',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Avatar circle
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEEEEEE),
                    border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 64,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                const SizedBox(height: 28),

                // Upload from gallery
                AppButton(
                  label: 'Upload from Gallery',
                  onPressed: () {
                    // TODO: image_picker – gallery
                  },
                ),
                const SizedBox(height: 12),

                // Take a photo
                AppButton(
                  label: 'Take a photo',
                  onPressed: () {
                    // TODO: image_picker – camera
                  },
                ),
                const SizedBox(height: 12),

                // Skip / Continue (after picking photo navigate to done)
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/done',
                    arguments: role,
                  ),
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