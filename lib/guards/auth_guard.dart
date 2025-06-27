import 'package:flutter/material.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:green_aplication/screens/login.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    if (authService.isLoggedIn) {
      return child;
    } else {
      return const Login();
    }
  }
}
