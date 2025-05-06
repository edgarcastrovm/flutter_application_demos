import 'package:evaluacion/db/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../widgets/dropdown_ciudad.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fechaSeleccionada;
  String _pais = 'Ecuador';
  String _ciudad = 'Quito';
  final List<String> _paises = ['Ecuador', 'Perú', 'Colombia'];
  final Map<String, List<String>> _ciudadesPorPais = {
    'Ecuador': ['Quito', 'Guayaquil'],
    'Perú': ['Lima', 'Cusco'],
    'Colombia': ['Bogotá', 'Medellín'],
  };

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _cuotaInicialController = TextEditingController();
  double _cuotaMensual = 0.0;

  // Variable para controlar la actualización de la lista
  bool _needsRefresh = false;

  void _calcularCuotaMensual() {
    final double cuotaInicial =
        double.tryParse(_cuotaInicialController.text) ?? 0.0;
    final double restante = 1500 - cuotaInicial;
    setState(() {
      _cuotaMensual = (restante / 4) * 1.05;
    });
  }

  void _guardarRegistro() async {
    if (_formKey.currentState!.validate() && _fechaSeleccionada != null) {
      try {
        final estudiante = Estudiante(
          nombres: _nombreController.text,
          edad: int.parse(_edadController.text),
          fecha: _fechaSeleccionada!,
          pais: _pais,
          ciudad: _ciudad,
          cuotaInicial: double.parse(_cuotaInicialController.text),
          cuotaMensual: _cuotaMensual,
        );

        final dbHelper = DatabaseHelper();
        final id = await dbHelper.insertarEstudiante(estudiante);

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estudiante registrado con ID: $id')),
        );

        // Mostrar el diálogo de resumen
        await _mostrarResumen(estudiante);

        // Limpiar el formulario
        _limpiarFormulario();

        // Actualizar la lista
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _mostrarResumen(Estudiante estudiante) async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Resumen"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nombres: ${estudiante.nombres}"),
                  Text("Edad: ${estudiante.edad}"),
                  Text(
                    "Fecha: ${estudiante.fecha.toLocal().toString().split(' ')[0]}",
                  ),
                  Text("País: ${estudiante.pais}"),
                  Text("Ciudad: ${estudiante.ciudad}"),
                  Text(
                    "Cuota inicial: \$${estudiante.cuotaInicial.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Cuota mensual: \$${estudiante.cuotaMensual.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Valor final: \$${(estudiante.cuotaInicial + estudiante.cuotaMensual * 4).toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cerrar"),
              ),
            ],
          ),
    );
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _edadController.clear();
    _cuotaInicialController.clear();
    setState(() {
      _fechaSeleccionada = null;
      _cuotaMensual = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de estudiantes',
          style: TextStyle(color: Colors.blue, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (fecha != null) {
                    setState(() => _fechaSeleccionada = fecha);
                  }
                },
                child: Text(
                  _fechaSeleccionada == null
                      ? 'Seleccionar fecha'
                      : _fechaSeleccionada!.toLocal().toString().split(' ')[0],
                ),
              ),
              DropdownCiudad(
                paises: _paises,
                ciudadesPorPais: _ciudadesPorPais,
                paisSeleccionado: _pais,
                ciudadSeleccionada: _ciudad,
                onPaisChanged: (nuevoPais) {
                  setState(() {
                    _pais = nuevoPais;
                    _ciudad = _ciudadesPorPais[nuevoPais]!.first;
                  });
                },
                onCiudadChanged: (nuevaCiudad) {
                  setState(() => _ciudad = nuevaCiudad);
                },
              ),
              Text("Valor del curso: \$1500"),
              TextFormField(
                controller: _cuotaInicialController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cuota inicial'),
                onChanged: (_) => _calcularCuotaMensual(),
                validator: (value) {
                  final val = double.tryParse(value ?? '') ?? 0.0;
                  if (val <= 0 || val >= 1500) return 'Valor inválido';
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text("Cuota mensual: \$${_cuotaMensual.toStringAsFixed(2)}"),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombres'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
              ),
              TextFormField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Edad'),
                validator: (value) {
                  final edad = int.tryParse(value ?? '') ?? 0;
                  if (edad < 5 || edad > 120) return 'Edad inválida';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarRegistro,
                child: Text("Registrar"),
              ),
              SizedBox(height: 30),
              Text(
                "Estudiantes registrados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Estudiante>>(
                // Usamos _needsRefresh para forzar la actualización
                future: DatabaseHelper().obtenerEstudiantes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error al cargar los estudiantes");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No hay estudiantes registrados");
                  } else {
                    final estudiantes = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: estudiantes.length,
                      itemBuilder: (context, index) {
                        final e = estudiantes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(e.nombres),
                            subtitle: Text(
                              "Edad: ${e.edad}, Ciudad: ${e.ciudad}",
                            ),
                            trailing: Text(
                              "\$${e.cuotaMensual.toStringAsFixed(2)} /mes",
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
