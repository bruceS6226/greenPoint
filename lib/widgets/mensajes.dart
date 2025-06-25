import 'package:flutter/material.dart';

enum TipoMensaje { success, error }

class Mensajes {
  static void mostrarMensaje(BuildContext context, String message, TipoMensaje type) {
    Color backgroundColor;
    Icon icon;

    switch (type) {
      case TipoMensaje.success:
        backgroundColor = const Color.fromRGBO(14, 145, 14, 1); // verde
        icon = const Icon(Icons.check_circle, color: Colors.white, size: 25);
        break;
      case TipoMensaje.error:
        backgroundColor = const Color.fromRGBO(255, 0, 0, 1); // rojo
        icon = const Icon(Icons.error, color: Colors.white, size: 25);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            icon,
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
