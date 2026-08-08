import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_theme.dart';
import 'data/datasources/local/storage_service.dart';
import 'presentation/auth/providers/auth_provider.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/common/widgets/loading_widget.dart';
import 'presentation/common/widgets/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

/// Decides which screen to show based on current auth state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return switch (authState) {
      AuthInitial() || AuthLoading() => const Scaffold(body: LoadingWidget()),
      AuthAuthenticated() => const MainNavigationShell(),
      AuthUnauthenticated() || AuthError() => const LoginScreen(),
    };
  }
}