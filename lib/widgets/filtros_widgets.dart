import 'package:flutter/material.dart';

class FiltrosWidget extends StatelessWidget {
  final String filtroSeleccionado;
  final Function(String) onFiltroCambiado;

  const FiltrosWidget({
    super.key,
    required this.filtroSeleccionado,
    required this.onFiltroCambiado,
  });

  final filtros = const ['Todos', 'Estaciones', 'Agencias', 'Tienda', 'Baños'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtros.map((f) {
          final activo = filtroSeleccionado == f;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activo ? Colors.deepPurple : Colors.white,
                foregroundColor: activo ? Colors.white : Colors.deepPurple,
                side: const BorderSide(color: Colors.deepPurple),
              ),
              onPressed: () => onFiltroCambiado(f),
              child: Text(f),
            ),
          );
        }).toList(),
      ),
    );
  }
}
