import 'package:flutter/material.dart';

/// Clase que define todos los colores específicos de una sección/pestaña
class SectionColors {
  final List<Color> fondoMezcla; // Gradiente de fondo [Inicio, Fin]
  final Color colorBorde;        // Borde del encabezado curvo
  final Color colorTitulo;       // Texto del encabezado (Ej: "HIMNOS")
  final Color btnActivo;         // Color de icono seleccionado en el BottomNav
  final Color btnInactivo;       // Color de icono NO seleccionado
  final Color cardFondo;         // Fondo de cada fila/tarjeta de himno
  final Color textoCuerpo;       // Color del nombre del himno en la lista

  SectionColors({
    required this.fondoMezcla,
    required this.colorBorde,
    required this.colorTitulo,
    required this.btnActivo,
    required this.btnInactivo,
    required this.cardFondo,
    required this.textoCuerpo,
  });
}

/// Contenedor que agrupa las configuraciones de todas las pestañas para un tema
class AppThemeData {
  final Map<int, SectionColors> pestanas;
  final Brightness brillo;

  AppThemeData({required this.pestanas, required this.brillo});
}

/// Biblioteca global de temas de la aplicación
class AppThemes {
  static Map<String, AppThemeData> biblioteca = {

    // ---------------------------------------------------------
    // TEMA OSCURO (Deep Blue / Night Mode)
    // ---------------------------------------------------------
    'oscuro': AppThemeData(
      brillo: Brightness.dark,
      pestanas: {
        0: SectionColors( // HIMNOS (Azul Galaxia)
          fondoMezcla: [const Color(0xFF020210), const Color(0xFF081448)],
          colorBorde: const Color(0xFF448AFF), // Azul más eléctrico
          colorTitulo: Colors.white,
          btnActivo: const Color(0xFF448AFF),
          btnInactivo: Colors.white.withValues(alpha: 0.3),
          cardFondo: Colors.white.withValues(alpha: 0.05), // Casi transparente
          textoCuerpo: const Color(0xFFE0E0E0),
        ),
        1: SectionColors( // FOLDER (Morado Profundo)
          fondoMezcla: [const Color(0xFF0A0210), const Color(0xFF2D0848)],
          colorBorde: const Color(0xFFAB47BC),
          colorTitulo: Colors.white,
          btnActivo: const Color(0xFFAB47BC),
          btnInactivo: Colors.white.withValues(alpha: 0.3),
          cardFondo: Colors.white.withValues(alpha: 0.05),
          textoCuerpo: const Color(0xFFE0E0E0),
        ),
        2: SectionColors( // CONFIG (Verde Bosque Oscuro)
          fondoMezcla: [const Color(0xFF020D05), const Color(0xFF0B3D1A)],
          colorBorde: const Color(0xFF66BB6A),
          colorTitulo: Colors.white,
          btnActivo: const Color(0xFF66BB6A),
          btnInactivo: Colors.white.withValues(alpha: 0.3),
          cardFondo: Colors.white.withValues(alpha: 0.05),
          textoCuerpo: const Color(0xFFE0E0E0),
        ),
      },
    ),
    // ---------------------------------------------------------
    // TEMA CLARO (Soft Pastel / Day Mode)
    // ---------------------------------------------------------
    'claro': AppThemeData(
      brillo: Brightness.light,
      pestanas: {
    0: SectionColors( // HIMNOS (Azul Cielo)
    fondoMezcla: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
    colorBorde: const Color(0xFF1976D2),
    colorTitulo: const Color(0xFF0D47A1),
    btnActivo: const Color(0xFF1976D2),
    btnInactivo: const Color(0xFF90CAF9),
    cardFondo: Colors.white.withValues(alpha: 0.7),
    textoCuerpo: const Color(0xFF0D47A1),
    ),
    1: SectionColors( // FOLDER (Lavanda)
    fondoMezcla: [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
    colorBorde: const Color(0xFF7B1FA2),
    colorTitulo: const Color(0xFF4A148C),
    btnActivo: const Color(0xFF7B1FA2),
    btnInactivo: const Color(0xFFCE93D8),
    cardFondo: Colors.white.withValues(alpha: 0.7),
    textoCuerpo: const Color(0xFF4A148C),
    ),
    2: SectionColors( // CONFIG (Menta)
    fondoMezcla: [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
    colorBorde: const Color(0xFF388E3C),
    colorTitulo: const Color(0xFF1B5E20),
    btnActivo: const Color(0xFF388E3C),
    btnInactivo: const Color(0xFFA5D6A7),
    cardFondo: Colors.white.withValues(alpha: 0.7),
    textoCuerpo: const Color(0xFF1B5E20),
    ),
    },
    ),
  };
}