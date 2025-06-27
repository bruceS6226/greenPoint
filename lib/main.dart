import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:green_aplication/guards/auth_guard.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:green_aplication/screens/login.dart';
import 'package:green_aplication/screens/maquinas/add_machine.dart';
import 'package:green_aplication/screens/maquinas/created_machines.dart';
import 'package:green_aplication/screens/maquinas/update_machine.dart';
import 'package:green_aplication/screens/maquinas/user_selection.dart';
import 'package:green_aplication/screens/recoverPassword.dart';
import 'package:green_aplication/screens/tanques/information/daySales.dart';
import 'package:green_aplication/screens/tanques/tank_information.dart';
import 'package:green_aplication/screens/tanques/tanks.dart';
import 'package:green_aplication/screens/usuarios/add_legal_person.dart';
import 'package:green_aplication/screens/usuarios/add_natural_person.dart';
import 'package:green_aplication/screens/usuarios/select-user-type.dart';
import 'package:green_aplication/screens/usuarios/user_info.dart';
import 'package:green_aplication/screens/usuarios/usuariosCreados.dart';
import 'package:green_aplication/screens/welcome.dart';
import 'package:green_aplication/services/auth_service.dart';
import 'package:green_aplication/widgets/navbar.dart';
import 'package:green_aplication/widgets/navbar_maquina.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

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
      navigatorObservers: [routeObserver],

      // ✅ Soporte para localizaciones
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/welcome',
      routes: {
        '/login': (context) => const Login(),
        '/recoverPassword': (context) => const RecoverPassword(),

        // RUTAS PROTEGIDAS
        '/welcome': (context) => AuthGuard(child: NavBar(child: const Welcome())),
        '/createdUsers': (context) => AuthGuard(child: NavBar(child: const UsuariosCreados())),
        '/naturalUser': (context) => AuthGuard(child: NavBar(child: const PersonaNatural())),
        '/legalUser': (context) => AuthGuard(child: NavBar(child: const PersonaLegal())),
        '/selectUserType': (context) => AuthGuard(child: NavBar(child: const SeleccionarTipoUsuario())),
        '/userInfo': (context) => AuthGuard(child: NavBar(child: const UserInformacion())),
        '/userSelection': (context) => AuthGuard(child: NavBar(child: const SeleccionarUsuario())),
        '/createdMachines': (context) => AuthGuard(child: NavBar(child: const MaquinasCreadas())),
        '/addMachine': (context) => AuthGuard(child: NavBar(child: const RegistrarMaquina())),
        '/tanks': (context) => AuthGuard(child: NavBarMaquina(child: const Tanques())),
        '/tankInformation': (context) => AuthGuard(child: NavBarMaquina(child: const InformacionTanque())),
        '/updateMachine': (context) => AuthGuard(child: NavBarMaquina(child: const ActualizarMaquina())),
        '/daySales': (context) => AuthGuard(child: NavBarMaquina(child: const VentasDiarias())),
      },
    );
  }
}
