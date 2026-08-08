import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFor(user);

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary,
          child: Text(
            initials,
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.textOnPrimary),
          ),
        ),
        const SizedBox(height: 12),
        Text(user.fullName.isEmpty ? user.username : user.fullName.toUpperCase(),
            style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        Text(user.email, style: AppTextStyles.bodyText),
      ],
    );
  }

  String _initialsFor(UserModel user) {
    final first = user.name.firstname.isNotEmpty ? user.name.firstname[0] : '';
    final last = user.name.lastname.isNotEmpty ? user.name.lastname[0] : '';
    final combined = (first + last).toUpperCase();
    return combined.isNotEmpty ? combined : user.username.substring(0, 1).toUpperCase();
  }
}