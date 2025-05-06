import 'package:evaluacion/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  bool _isLoading = false;

  void _validarCredenciales() async {
    final usuario = _usuarioController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarError("Por favor, ingrese usuario y contraseña.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verificar usuario en la base de datos
      final dbHelper = DatabaseHelper();
      final exist = await dbHelper.login(usuario, contrasena);

      setState(() {
        _isLoading = false;
      });

      if (exist) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RegistroScreen()),
        );
      } else {
        _mostrarError("Usuario o contraseña incorrectos");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarError("Error al verificar las credenciales. Intente nuevamente.");
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Aceptar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 120,
            ),
            SizedBox(height: 20),
            Text(
              'Autenticación',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _validarCredenciales,
                    child: Text('Ingresar'),
                  ),
          ],
        ),
      ),
    );
  }
}
