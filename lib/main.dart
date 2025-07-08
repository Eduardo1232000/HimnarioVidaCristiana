import 'package:flutter/material.dart';
import 'app.dart';
import 'config.dart';

void main() async {   //FUNCION PRINCIPAL
  WidgetsFlutterBinding.ensureInitialized();
  final config = Config();
  await config.loadConfig();
  runApp(MyApp(config: config));    //CORRER APP CON CONFIG
}

class MyApp extends StatefulWidget {
  final Config config;
  const MyApp({super.key, required this.config});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.config.addListener(_onConfigChanged);
  }

  @override
  void dispose() {
    widget.config.removeListener(_onConfigChanged);
    super.dispose();
  }

  void _onConfigChanged() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Aplicacion(config: widget.config);
  }
}