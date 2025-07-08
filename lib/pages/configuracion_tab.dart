import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../config.dart';

class ConfiguracionTab extends StatefulWidget {
  final Config config;
  const ConfiguracionTab({super.key, required this.config});

  @override
  State<ConfiguracionTab> createState() => _ConfiguracionTabState();
}

class _ConfiguracionTabState extends State<ConfiguracionTab> {
  late double _fontSize;
  late double _himnoFontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.config.fontSize;
    _himnoFontSize = widget.config.himnoFontSize;
  }

  Future<void> _saveConfig() async {
    widget.config.updateConfig(
      fontSize: _fontSize,
      himnoFontSize: _himnoFontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // para que el fondo se vea
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF070731),
              Color(0xFF070731),
              Color(0xFF1c59ac),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Tamaño de fuente general',
                    style: TextStyle(fontSize: _fontSize, color: Colors.white),
                  ),
                  subtitle: Slider(
                    value: _fontSize,
                    min: 12,
                    max: 32,
                    divisions: 20,
                    label: _fontSize.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _fontSize = value);
                      _saveConfig();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Tamaño fuente himnos',
                    style: TextStyle(fontSize: _himnoFontSize, color: Colors.white),
                  ),
                  subtitle: Slider(
                    value: _himnoFontSize,
                    min: 12,
                    max: 32,
                    divisions: 20,
                    label: _himnoFontSize.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _himnoFontSize = value);
                      _saveConfig();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
