
import 'package:flutter/material.dart';
import '../models/pais.dart';
import '../models/ciudad.dart';
import '../services/pais_service.dart';
import 'ciudad_detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pais> paises = [];
  Pais? paisSeleccionado;
  Ciudad? ciudadSeleccionada;

  @override
  void initState() {
    super.initState();
    PaisService().cargarPaises().then((lista) {
      setState(() {
        paises = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Ciudad> ciudadesDisponibles =
        paisSeleccionado?.ciudades ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona País y Ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<Pais>(
              hint: const Text('Elige un país'),
              value: paisSeleccionado,
              isExpanded: true,
              onChanged: (Pais? nuevoPais) {
                setState(() {
                  paisSeleccionado = nuevoPais;
                  ciudadSeleccionada = null;
                });
              },
              items: paises.map((Pais pais) {
                return DropdownMenuItem<Pais>(
                  value: pais,
                  child: Text(pais.nombre),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButton<Ciudad>(
              hint: const Text('Elige una ciudad'),
              value: ciudadSeleccionada,
              isExpanded: true,
              onChanged: (Ciudad? nuevaCiudad) {
                setState(() {
                  ciudadSeleccionada = nuevaCiudad;
                });
                if (nuevaCiudad != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CiudadDetalleScreen(ciudad: nuevaCiudad),
                    ),
                  );
                }
              },
              items: ciudadesDisponibles.map((Ciudad ciudad) {
                return DropdownMenuItem<Ciudad>(
                  value: ciudad,
                  child: Text(ciudad.nombre),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}