import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.headingMedium)),
      body: Center(
        child: Text('Profile coming soon', style: AppTextStyles.bodyText),
      ),
    );
  }
}