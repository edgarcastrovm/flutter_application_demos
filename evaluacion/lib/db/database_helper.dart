import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estudiante.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'estudiantes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Creamos estructura de datos basica para el app
        await db.execute('''
          CREATE TABLE estudiantes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombres TEXT,
            edad INTEGER,
            fecha TEXT,
            pais TEXT,
            ciudad TEXT,
            cuotaInicial REAL,
            cuotaMensual REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nick TEXT,
            clave TEXT
          )
        ''');

        await db.insert('usuarios', {'nick': 'admin', 'clave': 'admin'});
        await db.insert('usuarios', {'nick': 'user', 'clave': 'user'});
        await db.insert('usuarios', {'nick': 'admin2', 'clave': 'admin2'});
        await db.insert('usuarios', {'nick': 'user2', 'clave': 'user2'});
        await db.insert('usuarios', {'nick': 'admin3', 'clave': 'admin3'});
      },
    );
  }

Future<int> insertarEstudiante(Estudiante estudiante) async {
  try {
    final db = await database;
    
    // Validar que el estudiante no esté duplicado (opcional)
    final estudiantesExistentes = await db.query(
      'estudiantes',
      where: 'nombres = ? AND fecha = ?',
      whereArgs: [estudiante.nombres, estudiante.fecha.toIso8601String()],
    );
    
    if (estudiantesExistentes.isNotEmpty) {
      throw Exception('Estudiante ya registrado con la misma fecha');
    }

    // Insertar el nuevo estudiante
    final id = await db.insert(
      'estudiantes',
      estudiante.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return id; // Retornamos el ID generado
  } catch (e) {
    print('Error al insertar estudiante: $e');
    throw Exception('No se pudo guardar el estudiante: ${e.toString()}');
  }
}

  Future<List<Estudiante>> obtenerEstudiantes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('estudiantes');

    return List.generate(maps.length, (i) => Estudiante.fromMap(maps[i]));
  }

  Future<bool> login(String nick, String clave) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'nick = ? AND clave = ?',
      whereArgs: [nick, clave],
    );

    return maps.isNotEmpty;
  }
}
