import 'package:flutter/material.dart';
import 'package:navigation/pages/OnePage.dart';
import 'package:navigation/pages/widgets/MainScaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  _title() => 'Home';
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: widget._title(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Aquí se navega a la otra página
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnePage()),
            );
          },
          child: const Text('Ir a la Página 1'),
        ),
      ),
    );
  }
}
