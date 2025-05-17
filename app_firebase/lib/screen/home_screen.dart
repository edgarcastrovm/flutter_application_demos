import 'package:app_firebase/model/person_model.dart';
import 'package:app_firebase/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:app_firebase/screen/add_person_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<PersonWithId>> _getPerson() async {
    List<PersonWithId> personList = [];
    try {
      personList = await getPerson();
    } catch (e) {
      print("Error getting Persons: $e");
    }
    return personList;
  }

  Future<List<PersonWithId>>? _listaPersonas;

  @override
  void initState() {
    super.initState();
    _listaPersonas = _getPerson();
  }

  void _refrescarDatos() {
    setState(() {
      _listaPersonas = _getPerson(); // Volver a llamar a la función asíncrona
    });
  }

  void _eliminarPersona(String id) async {
    bool? isConfirmed = await dialogConfirmDelete(context);
    if (isConfirmed == null || !isConfirmed) {
      return; // Si el usuario cancela, no hacer nada
    }
    bool isDeleted = await deletePerson(id);
    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro eliminado'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // opcional: para que flote
          duration: const Duration(seconds: 2), // opcional: duración
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el registro'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // opcional: para que flote
          duration: const Duration(seconds: 2), // opcional: duración
        ),
      );
    }
  }

 Future<bool> dialogConfirmDelete(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Evita que se cierre tocando fuera del diálogo
    builder: (context) {
      return AlertDialog(
        title: const Text('Eliminar Persona'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // El usuario canceló
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // El usuario confirmó
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // En caso de que sea null, retorna false
}

  @override
  Widget build(BuildContext context) {
    void changeScreenAddPerson(PersonWithId person) async {
      print(person);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AddPersonScreen(
                initialName: person.name,
                initialSurname: person.surname,
                personId: person.id,
              ),
        ),
      );
      _refrescarDatos(); // Refrescar la lista después de volver
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refrescarDatos,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _listaPersonas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron personas'));
          } else {
            List<PersonWithId> personList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: personList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          personList[index].name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          personList[index].surname,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            changeScreenAddPerson(personList[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                              _eliminarPersona(personList[index].id);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPersonScreen()),
          );
          _refrescarDatos(); // Refrescar la lista después de volver
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
