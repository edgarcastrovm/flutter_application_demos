import 'package:flutter/material.dart';
import '../models/ciudad.dart';

class CiudadDetalleScreen extends StatelessWidget {
  final Ciudad ciudad;

  const CiudadDetalleScreen({super.key, required this.ciudad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ciudad.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(ciudad.descripcion, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}