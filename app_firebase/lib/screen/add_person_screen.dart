import 'package:flutter/material.dart';
import 'package:app_firebase/service/firebase_service.dart';

class AddPersonScreen extends StatefulWidget {
  final String? initialName;
  final String? initialSurname;
  final String? personId; // útil si estás editando por ID

  const AddPersonScreen({
    super.key,
    this.initialName,
    this.initialSurname,
    this.personId,
  });

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _surnameController = TextEditingController(
      text: widget.initialSurname ?? '',
    );
  }

  // Método para agregar o actualizar persona

  void savePerson() async {
    String name = _nameController.text.trim();
    String surname = _surnameController.text.trim();
    bool isValid = false;
    // Lógica para agregar persona
    if (widget.personId != null) {
      // Actualizar persona
      isValid = await updatePerson(widget.personId!, name, surname);
    } else {
      // Agregar nueva persona
      isValid = await addPerson(name, surname);
    }
    if (isValid) {
      // Si la persona se agregó correctamente, puedes navegar hacia atrás
      Navigator.pop(context);
    } else {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar la persona'),
        ),
      );
    }
    print('Persona agregada: $name $surname');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: savePerson),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de la persona',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
                hintText: 'Ingresa tu nombre',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Apellido',
                hintText: 'Ingresa tu apellido',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
