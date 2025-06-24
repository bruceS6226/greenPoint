import 'package:flutter/material.dart';
import 'package:green_aplication/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

class MiniEncabezado extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String textoBoton;
  final String ruta;

  const MiniEncabezado({
    super.key,
    required this.titulo,
    required this.icono,
    required this.textoBoton,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título con máximo ancho disponible sin truncamiento innecesario
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                );
              },
              child: navBarState.isExpanded
                  ? IconButton(
                      key: const ValueKey('iconOnly'),
                      onPressed: () {
                        Navigator.pushNamed(context, ruta);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 145, 14, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(6),
                      ),
                      icon: Icon(icono, color: Colors.white, size: 30),
                    )
                  : ElevatedButton.icon(
                      key: const ValueKey('iconWithText'),
                      onPressed: () {
                        Navigator.pushNamed(context, ruta);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icono,
                          color: const Color.fromRGBO(14, 145, 14, 1),
                          size: 22,
                        ),
                      ),
                      label: Text(
                        textoBoton,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 145, 14, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
