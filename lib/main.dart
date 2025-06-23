import 'package:flutter/material.dart';
import 'package:green_aplication/guards/auth_guard.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/screens/login.dart';
import 'package:green_aplication/screens/maquinas/add_machine.dart';
import 'package:green_aplication/screens/maquinas/created_machines.dart';
import 'package:green_aplication/screens/maquinas/user_selection.dart';
import 'package:green_aplication/screens/recoverPassword.dart';
import 'package:green_aplication/screens/usuarios/add_legal_person.dart';
import 'package:green_aplication/screens/usuarios/add_natural_person.dart';
import 'package:green_aplication/screens/usuarios/select-user-type.dart';
import 'package:green_aplication/screens/usuarios/user_info.dart';
import 'package:green_aplication/screens/usuarios/usuariosCreados.dart';
import 'package:green_aplication/screens/welcome.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:green_aplication/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init(); // inicializa cookie desde storage

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
        
        // ✅ RUTAS PROTEGIDAS
        '/welcome': (context) => AuthGuard(child: NavBar(child: const Welcome())),
        '/createdUsers': (context) => AuthGuard(child: NavBar(child: const UsuariosCreados())),
        '/naturalPerson': (context) => AuthGuard(child: NavBar(child: const PersonaNatural())),
        '/legalPerson': (context) => AuthGuard(child: NavBar(child: const PersonaLegal())),
        '/selectUserType': (context) => AuthGuard(child: NavBar(child: const SeleccionarTipoUsuario())),
        '/userInfo': (context) => NavBar(child: const UserInformacion()),
        '/userSelection': (context) => NavBar(child: const SeleccionarUsuario()),
        '/createdMachines': (context) => NavBar(child: const MaquinasCreadas()),
        '/addMachine': (context) => NavBar(child: const RegistrarMaquina()),
      },
    );
  }
}
