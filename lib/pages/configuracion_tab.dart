import 'package:flutter/material.dart';
import '../config.dart';
import '../app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';

class ConfiguracionTab extends StatefulWidget {
  final Config config;
  const ConfiguracionTab({super.key, required this.config});

  @override
  State<ConfiguracionTab> createState() => _ConfiguracionTabState();
}

class _ConfiguracionTabState extends State<ConfiguracionTab> {

  void _updateFontSize(double value, bool isGeneral) {
    setState(() {
      if (isGeneral) {
        widget.config.updateConfig(fontSize: value);
      } else {
        widget.config.updateConfig(himnoFontSize: value);
      }
    });
  }

  // --- LÓGICA DE ACTUALIZACIÓN ---

  Future<void> _procesoCompletoActualizacion(SectionColors seccion) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text("Buscando actualizaciones...")));

    try {
      // REEMPLAZA ESTO CON TU URL REAL DE GITHUB
      final urlJson = Uri.parse('https://raw.githubusercontent.com/Eduardo1232000/HimnarioVidaCristiana/main/version.json');
      final response = await http.get(urlJson);


      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String versionRemota = data['version'];
        String urlApk = data['url_apk'];
        String versionActual = "1.0.0";

        if (versionRemota != versionActual) {
          await _descargarEInstalar(urlApk, seccion);
        } else {
          messenger.showSnackBar(const SnackBar(content: Text("La aplicación ya está actualizada.")));
        }
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text("No se pudo conectar: $e")));
    }
  }

  Future<void> _descargarEInstalar(String urlApk, SectionColors seccion) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: seccion.colorBorde),
            const SizedBox(height: 20),
            const Text("Descargando nueva versión...", style: TextStyle(color: Colors.white)),
            const Text("La instalación comenzará al terminar.", style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw "No se pudo acceder al almacenamiento";

      final String filePath = '${directory.path}/update.apk';
      final response = await http.get(Uri.parse(urlApk));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      if (!mounted) return;
      Navigator.pop(context); // Quitar diálogo

      // IMPORTANTE: Cambia 'com.ejemplo.himnario' por el tuyo en android/app/build.gradle
      await OpenFilex.open(filePath);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final temaActual = AppThemes.biblioteca[widget.config.themeName] ?? AppThemes.biblioteca['oscuro']!;
    final seccion = temaActual.pestanas[2]!;
    final String currentFont = widget.config.fontFamily == 'Serif' ? 'serif' : 'sans-serif';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: seccion.fondoMezcla,
          ),
        ),
        child: Column(
          children: [
            // ENCABEZADO
            Container(
              height: 110,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: seccion.colorBorde, width: 2),
                  right: BorderSide(color: seccion.colorBorde, width: 2),
                  bottom: BorderSide(color: seccion.colorBorde, width: 5),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Text('AJUSTES',
                  style: TextStyle(
                    fontSize: widget.config.fontSize + 8,
                    fontWeight: FontWeight.w900,
                    color: seccion.colorTitulo,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TEMAS ---
                    _buildSectionTitle("Apariencia", seccion),
                    _buildCard(seccion,
                      child: Column(
                        children: [
                          _buildThemeTile(label: "Noche Profunda", themeKey: 'oscuro', previewColor: const Color(0xFF020210), seccion: seccion),
                          const Divider(height: 1, indent: 50),
                          _buildThemeTile(label: "Luz Pastel", themeKey: 'claro', previewColor: const Color(0xFFE3F2FD), seccion: seccion),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- FUENTES ---
                    _buildSectionTitle("Fuentes", seccion),
                    _buildCard(seccion,
                      child: Column(
                        children: [
                          _buildSliderOption("General", widget.config.fontSize, 12, 30, (v) => _updateFontSize(v, true), seccion),
                          const Divider(height: 1),
                          _buildSliderOption("Himnos", widget.config.himnoFontSize, 16, 40, (v) => _updateFontSize(v, false), seccion),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- ESTILO ---
                    _buildSectionTitle("Estilo", seccion),
                    _buildCard(seccion,
                      child: Column(
                        children: [
                          _buildFontOption("Moderna (Sans Serif)", "Sans", seccion),
                          const Divider(height: 1),
                          _buildFontOption("Clásica (Serif)", "Serif", seccion),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- VISTA PREVIA ---
                    _buildSectionTitle("Vista Previa", seccion),
                    _buildCard(seccion,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("1. Cuán grande es Él",
                              style: TextStyle(color: seccion.colorBorde, fontWeight: FontWeight.bold, fontSize: widget.config.fontSize, fontFamily: currentFont),
                            ),
                            const SizedBox(height: 8),
                            Text("Señor mi Dios, al contemplar los cielos...",
                              style: TextStyle(color: seccion.textoCuerpo, fontSize: widget.config.himnoFontSize, fontFamily: currentFont, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- SISTEMA (Botón de Actualización fuera de la vista previa) ---
                    _buildSectionTitle("Sistema", seccion),
                    _buildCard(seccion,
                      child: ListTile(
                        leading: Icon(Icons.cloud_download_rounded, color: seccion.colorBorde),
                        title: const Text("Actualizar Aplicación", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: const Text("Busca e instala mejoras automáticamente", style: TextStyle(color: Colors.white38, fontSize: 11)),
                        onTap: () => _procesoCompletoActualizacion(seccion),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildSectionTitle(String title, SectionColors seccion) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(title.toUpperCase(), style: TextStyle(color: seccion.colorBorde, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
    );
  }

  Widget _buildCard(SectionColors seccion, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: seccion.cardFondo, borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
    );
  }

  Widget _buildThemeTile({required String label, required String themeKey, required Color previewColor, required SectionColors seccion}) {
    final bool isSelected = widget.config.themeName == themeKey;
    return ListTile(
      leading: CircleAvatar(backgroundColor: previewColor, radius: 12, child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
      title: Text(label, style: TextStyle(color: seccion.textoCuerpo, fontSize: 15)),
      trailing: isSelected ? Icon(Icons.radio_button_checked, color: seccion.colorBorde) : Icon(Icons.radio_button_off, color: seccion.textoCuerpo.withValues(alpha: 0.3)),
      onTap: () {
        widget.config.updateTheme(themeKey);
        setState(() {}); // Forzar refresco local para el celular
      },
    );
  }

  Widget _buildFontOption(String label, String fontKey, SectionColors seccion) {
    bool isSelected = widget.config.fontFamily == fontKey;
    return ListTile(
      title: Text(label, style: TextStyle(color: seccion.textoCuerpo, fontFamily: fontKey == "Serif" ? 'serif' : 'sans-serif')),
      trailing: isSelected ? Icon(Icons.check_circle, color: seccion.colorBorde) : null,
      onTap: () {
        widget.config.updateFontFamily(fontKey);
        setState(() {});
      },
    );
  }

  Widget _buildSliderOption(String label, double value, double min, double max, Function(double) onChanged, SectionColors seccion) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: seccion.textoCuerpo)),
              Text("${value.toInt()}px", style: TextStyle(color: seccion.colorBorde, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(value: value, min: min, max: max, activeColor: seccion.colorBorde, inactiveColor: seccion.colorBorde.withValues(alpha: 0.2), onChanged: onChanged),
        ],
      ),
    );
  }
}