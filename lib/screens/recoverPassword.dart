import 'package:flutter/material.dart';
import 'package:green_aplication/screens/login.dart';
import 'package:green_aplication/services/auth_service.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _submitted = false;
  bool _sent = false;
  bool _help = false;
  String? _error;

  Future<void> _handleRecover() async {
    final email = _emailController.text.trim();
    setState(() {
      _submitted = true;
      _error = null;
    });

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _error = 'Correo inválido';
      });
      return;
    }

    try {
      await _authService.requestPasswordChange(email);
      setState(() {
        _sent = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/punto-green-fondo.webp"),
                fit: BoxFit.cover,
                alignment: Alignment(-0.8, -0.8),
              ),
            ),
          ),

          // Contenedor blanco encima, centrado
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                child: _sent
                    ? _help
                        ? _buildHelpMessage()
                        : _buildSentMessage()
                    : _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/logo-horizontal-03.webp',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 2, color: Color.fromRGBO(8, 85, 8, 1)),
        const SizedBox(height: 18),
        const Text(
          "Por favor ingrese su correo electrónico registrado en Punto Green",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: const Text(
            "Correo electrónico:",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Ingrese su correo electrónico",
            hintStyle: const TextStyle(fontSize: 16, color: Colors.black38),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(fontSize: 16),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        if (_submitted && _error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleRecover,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(14, 145, 14, 1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _submitted && !_sent ? "Enviando Correo..." : "RECUPERAR CONTRASEÑA",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: const Text(
            "Volver a Iniciar Sesión",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSentMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Se ha enviado un correo electrónico. Por favor revisa tu Bandeja de Entrada o tu Bandeja de No Deseados (spam).",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(14, 145, 14, 1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "VOLVER A INICIO DE SESIÓN",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => setState(() => _help = true),
          child: const Text(
            "¿Necesitas ayuda?",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Por favor, envíanos un correo electrónico con tu requerimiento o duda. Estaremos encantados de ayudarte.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // Aquí podrías abrir el formulario real con url_launcher
          },
          child: const Text(
            "Formulario de contacto",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.blueAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: const Text(
            "Volver al inicio de sesión",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
