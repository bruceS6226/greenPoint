import 'package:flutter/material.dart';
import 'package:green_aplication/services/auth_service.dart';

class RecuperarContrasenia extends StatefulWidget {
  const RecuperarContrasenia({super.key});

  @override
  State<RecuperarContrasenia> createState() => _RecuperarContraseniaState();
}

class _RecuperarContraseniaState extends State<RecuperarContrasenia> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _submitted = false;
  bool _sent = false;
  bool _help = false;
  String? _error;

  Future<void> _onSubmit() async {
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

  void _requestHelp() {
    setState(() {
      _help = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _submitted && _sent
                ? _help
                    ? _buildHelpMessage()
                    : _buildSentMessage()
                : _buildEmailForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Por favor ingrese su correo electrónico registrado en Punto Green",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text(
          "Correo",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: "ejemplo@correo.com",
          ),
        ),
        if (_submitted && _error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E910E),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _submitted && !_sent ? "Enviando Correo..." : "Recuperar contraseña",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Volver a inicio de sesión",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage() {
    return Column(
      children: [
        const Text(
          "Se ha enviado un correo electrónico, por favor revisa tu Bandeja de Entrada o tu Bandeja de No Deseados (spam).",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E910E),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "VOLVER A INICIO DE SESIÓN",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _requestHelp,
          child: const Text(
            "¿Necesitas ayuda?",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpMessage() {
    return Column(
      children: [
        const Text(
          "Por favor, envíenos un correo electrónico con su requerimiento, duda o una breve explicación de por qué necesita ayuda.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        const Text(
          "Estaremos encantados de brindarle una solución personalizada lo antes posible.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            // Este link debería abrir el formulario de contacto en navegador
            // Puedes usar url_launcher si quieres que funcione realmente
          },
          child: const Text(
            "Formulario de contacto",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Volver al inicio de sesión",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
