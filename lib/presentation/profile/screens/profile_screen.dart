import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // ProfileScreen only renders while authenticated (AuthGate guarantees
    // this), but guard defensively in case state changes mid-frame.
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.headingMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileHeader(user: user),
            const SizedBox(height: 32),
            ProfileMenuItem(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: user.phone,
            ),
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: user.address.formatted,
            ),
            ProfileMenuItem(
              icon: Icons.alternate_email,
              label: 'Username',
              value: user.username,
            ),
            const SizedBox(height: 20),
            ProfileMenuItem(
              icon: Icons.logout,
              label: 'Log out',
              isDestructive: true,
              onTap: () => _confirmLogout(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: Text('Log out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}