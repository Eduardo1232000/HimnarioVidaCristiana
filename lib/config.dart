import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends ChangeNotifier {
  double fontSize;
  double himnoFontSize;
  String themeName; // 'oscuro' o 'claro'
  int currentTab;
  String fontFamily;

  Config({
    this.fontSize = 18.0,
    this.himnoFontSize = 20.0,
    this.themeName = 'oscuro',
    this.currentTab = 0,
    this.fontFamily = 'Sans',
  });

  // Método para inicializar y cargar los datos guardados
  static Future<Config> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return Config(
      fontSize: prefs.getDouble('fontSize') ?? 18.0,
      himnoFontSize: prefs.getDouble('himnoFontSize') ?? 20.0,
      themeName: prefs.getString('themeName') ?? 'oscuro',
    );
  }

  // ACTUALIZAR TEMA
  void updateTheme(String newTheme) async {
    themeName = newTheme;
    notifyListeners(); // Esto hace que app.dart se redibuje con nuevos colores

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeName', newTheme);
  }

  // ACTUALIZAR FONT FAMILY
  void updateFontFamily(String newFont) async {
    fontFamily = newFont;
    notifyListeners(); // Avisa a la app para cambiar el estilo visual

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', newFont); // Guarda la elección
  }

  // Actualiza la pestaña actual (para cambiar colores en tiempo real)
  void updateTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  // Actualiza las fuentes
  void updateConfig({double? fontSize, double? himnoFontSize}) async {
    final prefs = await SharedPreferences.getInstance();
    if (fontSize != null) {
      this.fontSize = fontSize;
      await prefs.setDouble('fontSize', fontSize);
    }
    if (himnoFontSize != null) {
      this.himnoFontSize = himnoFontSize;
      await prefs.setDouble('himnoFontSize', himnoFontSize);
    }
    notifyListeners();
  }
}