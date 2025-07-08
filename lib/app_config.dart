import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  //VARIABLES
  final String color;
  final double fontSize;
  final double himnoFontSize;
  final String textColor;

  //CONSTRUCTOR
  AppConfig({
    required this.color,
    required this.fontSize,
    required this.himnoFontSize,
    required this.textColor,
  });

  static Future<AppConfig> loadFromAsset(String path) async {
    final data = await rootBundle.loadString(path);                   // OBTENCION DE DATA
    final jsonResult = json.decode(data);                             // CONVERTIR A JSON
    return AppConfig(                                                 // RETORNA UN OBJETO APPCONFIG CON LOS PARAMETROS
      color: jsonResult['color'],
      fontSize: (jsonResult['fontSize'] as num).toDouble(),
      himnoFontSize: (jsonResult['himnoFontSize'] as num).toDouble(),
      textColor: jsonResult['textColor'],
    );
  }
}