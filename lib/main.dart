import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/screens/login.dart';
import 'package:green_aplication/screens/recoverPassword.dart';
import 'package:green_aplication/screens/welcome.dart';
import 'package:green_aplication/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavBarState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/login': (context) => const Login(),
        '/recoverPassword': (context) => const RecoverPassword(),
        '/welcome': (context) => NavBar(child: const Welcome()),
      },
    );
  }
}
