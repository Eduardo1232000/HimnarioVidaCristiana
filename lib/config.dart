import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config with ChangeNotifier {
  double _fontSize = 16.0;
  double _himnoFontSize = 20.0;

  double get fontSize => _fontSize;
  double get himnoFontSize => _himnoFontSize;

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _himnoFontSize = prefs.getDouble('himnoFontSize') ?? 20.0;
    notifyListeners();
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setDouble('himnoFontSize', _himnoFontSize);

    notifyListeners();
  }

  void updateConfig({
    Color? color,
    double? fontSize,
    double? himnoFontSize,
    Color? textColor,
  }) {
    _fontSize = fontSize ?? _fontSize;
    _himnoFontSize = himnoFontSize ?? _himnoFontSize;
    _himnoFontSize = himnoFontSize ?? _himnoFontSize;
    saveConfig();
  }
}