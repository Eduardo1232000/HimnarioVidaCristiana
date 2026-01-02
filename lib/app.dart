import 'package:flutter/material.dart';
import 'app_themes.dart'; // Importamos tu nueva biblioteca de colores
import 'config.dart';
import 'pages/home_page.dart';

class Aplicacion extends StatelessWidget {
  final Config config;
  const Aplicacion({super.key, required this.config});

  // Esta función traduce tus variables de app_themes.dart a algo que Flutter entiende
  ThemeData _buildTheme(Config config, int currentTab) {
    // 1. Buscamos el tema seleccionado (claro u oscuro)
    final temaSeleccionado = AppThemes.biblioteca[config.themeName] ?? AppThemes.biblioteca['oscuro']!;

    // 2. Buscamos los colores de la pestaña donde está el usuario (0, 1 o 2)
    final seccion = temaSeleccionado.pestanas[currentTab] ?? temaSeleccionado.pestanas[0]!;

    return ThemeData(
      useMaterial3: true,
      brightness: temaSeleccionado.brillo,
      fontFamily: config.fontFamily,

      // Mapeamos tus variables personalizadas a las propiedades estándar de Flutter
      colorScheme: ColorScheme.fromSeed(
        seedColor: seccion.colorBorde,
        primary: seccion.colorBorde,    // Para bordes
        secondary: seccion.btnActivo,   // Para botones/iconos activos
        surface: seccion.cardFondo,     // Para el fondo de las tarjetas
        onSurface: seccion.btnInactivo, // Para elementos inactivos
        tertiary: seccion.fondoMezcla[1], // Guardamos el segundo color del gradiente aquí
        brightness: temaSeleccionado.brillo,
      ),

      scaffoldBackgroundColor: seccion.fondoMezcla[0], // Color base del gradiente

      // Configuramos el estilo de los textos globalmente
      textTheme: TextTheme(
        displayLarge: TextStyle(color: seccion.colorTitulo, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: seccion.textoCuerpo),
        bodyMedium: TextStyle(color: seccion.textoCuerpo),
      ),

      // Configuramos la barra de navegación para que use tus variables de botón
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: seccion.fondoMezcla[0],
        selectedItemColor: seccion.btnActivo,
        unselectedItemColor: seccion.btnInactivo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en Config (para cuando el usuario cambie el tema o la pestaña)
    return ListenableBuilder(
      listenable: config,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Himnario',
          // Pasamos el objeto config y la pestaña actual para generar el tema
          theme: ThemeData(
            brightness: AppThemes.biblioteca[config.themeName]!.brillo,
            fontFamily: config.fontFamily,
            useMaterial3: true,
          ),
          home: MyHomePage(config: config),
        );
      },
    );
  }
}