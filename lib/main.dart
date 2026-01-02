import 'package:flutter/material.dart';
import 'app.dart';
import 'config.dart';

void main() async {
  // 1. Inicialización necesaria para plugins como SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cargamos la configuración guardada antes de lanzar la interfaz
  final config = await Config.loadConfig();

  // 3. Ejecutamos la App
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final Config config;

  // Usamos el constructor simple. No necesitamos StatefulWidget aquí
  // porque la reactividad ya está en app.dart
  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // Retornamos directamente tu widget Aplicacion de app.dart
    return Aplicacion(config: config);
  }
}