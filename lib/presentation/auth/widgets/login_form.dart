import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../common/widgets/app_button.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String username, String password) onSubmit;

  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'mor_2314');
  final _passwordController = TextEditingController(text: '83r5^_');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _usernameController,
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Username is required' : null,
            decoration: InputDecoration(
              hintText: 'Enter username',
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
              fillColor: AppColors.background.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Password',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Password is required' : null,
            decoration: InputDecoration(
              hintText: 'Enter password',
              fillColor: AppColors.background.withOpacity(0.5),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 30),
          AppButton(
            label: 'Login',
            isLoading: widget.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _usernameController.text.trim(),
                  _passwordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}