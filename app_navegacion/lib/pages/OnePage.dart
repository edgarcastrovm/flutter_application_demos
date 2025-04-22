import 'package:flutter/material.dart';
import 'package:navigation/pages/HomePage.dart';
import 'package:navigation/pages/widgets/MainScaffold.dart';

class OnePage extends StatelessWidget {
  const OnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "Página 1",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/running.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí se navega a la otra página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('Ir a la Página de Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
