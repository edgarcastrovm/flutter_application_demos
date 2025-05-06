import 'package:flutter/material.dart';

class DropdownCiudad extends StatelessWidget {
  final List<String> paises;
  final Map<String, List<String>> ciudadesPorPais;
  final String paisSeleccionado;
  final String ciudadSeleccionada;
  final Function(String) onPaisChanged;
  final Function(String) onCiudadChanged;

  const DropdownCiudad({
    required this.paises,
    required this.ciudadesPorPais,
    required this.paisSeleccionado,
    required this.ciudadSeleccionada,
    required this.onPaisChanged,
    required this.onCiudadChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: paisSeleccionado,
          onChanged: (valor) {
            if (valor != null) {
              onPaisChanged(valor);
            }
          },
          items: paises.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
        ),
        DropdownButton<String>(
          value: ciudadSeleccionada,
          onChanged: (valor) {
            if (valor != null) {
              onCiudadChanged(valor);
            }
          },
          items: ciudadesPorPais[paisSeleccionado]!
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
        ),
      ],
    );
  }
}
