import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class AddEditPokemonScreen extends StatefulWidget {
  final Pokemon? pokemon;

  const AddEditPokemonScreen({super.key, this.pokemon});

  @override
  State<AddEditPokemonScreen> createState() => _AddEditPokemonScreenState();
}

class _AddEditPokemonScreenState extends State<AddEditPokemonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _hpController;
  late TextEditingController _attackController;
  late TextEditingController _defenseController;
  late TextEditingController _speedController;
  List<String> _types = [];
  List<String> _abilities = [];
  String _currentType = '';
  String _currentAbility = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pokemon?.name ?? '');
    _imageUrlController = TextEditingController(text: widget.pokemon?.imageUrl ?? '');
    _heightController = TextEditingController(text: widget.pokemon?.height.toString() ?? '');
    _weightController = TextEditingController(text: widget.pokemon?.weight.toString() ?? '');
    _hpController = TextEditingController(text: widget.pokemon?.hp.toString() ?? '');
    _attackController = TextEditingController(text: widget.pokemon?.attack.toString() ?? '');
    _defenseController = TextEditingController(text: widget.pokemon?.defense.toString() ?? '');
    _speedController = TextEditingController(text: widget.pokemon?.speed.toString() ?? '');
    _types = widget.pokemon?.types.toList() ?? [];
    _abilities = widget.pokemon?.abilities.toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _hpController.dispose();
    _attackController.dispose();
    _defenseController.dispose();
    _speedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon == null ? 'Añadir Pokémon' : 'Editar Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de la imagen'),
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _hpController,
                decoration: const InputDecoration(labelText: 'HP'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _attackController,
                decoration: const InputDecoration(labelText: 'Ataque'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _defenseController,
                decoration: const InputDecoration(labelText: 'Defensa'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _speedController,
                decoration: const InputDecoration(labelText: 'Velocidad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Tipos:'),
              Wrap(
                spacing: 8,
                children: _types
                    .map((type) => Chip(
                          label: Text(type),
                          onDeleted: () {
                            setState(() {
                              _types.remove(type);
                            });
                          },
                        ))
                    .toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Añadir tipo'),
                      onChanged: (value) {
                        _currentType = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_currentType.isNotEmpty) {
                        setState(() {
                          _types.add(_currentType);
                          _currentType = '';
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Habilidades:'),
              Wrap(
                spacing: 8,
                children: _abilities
                    .map((ability) => Chip(
                          label: Text(ability),
                          onDeleted: () {
                            setState(() {
                              _abilities.remove(ability);
                            });
                          },
                        ))
                    .toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Añadir habilidad'),
                      onChanged: (value) {
                        _currentAbility = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_currentAbility.isNotEmpty) {
                        setState(() {
                          _abilities.add(_currentAbility);
                          _currentAbility = '';
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final pokemon = Pokemon(
                      id: widget.pokemon?.id ?? DateTime.now().millisecondsSinceEpoch,
                      name: _nameController.text,
                      imageUrl: _imageUrlController.text,
                      height: int.tryParse(_heightController.text) ?? 0,
                      weight: int.tryParse(_weightController.text) ?? 0,
                      hp: int.tryParse(_hpController.text) ?? 0,
                      attack: int.tryParse(_attackController.text) ?? 0,
                      defense: int.tryParse(_defenseController.text) ?? 0,
                      speed: int.tryParse(_speedController.text) ?? 0,
                      types: _types,
                      abilities: _abilities,
                    );
                    Navigator.pop(context, pokemon);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}