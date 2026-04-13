import 'package:flutter/material.dart';
import 'app.dart';
import 'config.dart';

void main() async {
  // 1. Inicialización necesaria para plugins como SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cargamos la configuración guardada antes de lanzar la interfaz
  final config = await Config.loadConfig();

  // 3. Ejecutamos la App y le enviamos la configuracion inicial
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final Config config;
  const MyApp({super.key, required this.config});
  @override
  Widget build(BuildContext context) {
    return Aplicacion(config: config);
  }
}