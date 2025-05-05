import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pais.dart';

class PaisService {
  Future<List<Pais>> cargarPaises() async {
    final String jsonString = await rootBundle.loadString('assets/paises_ciudades.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Pais.fromJson(json)).toList();
  }
}