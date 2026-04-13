import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../config.dart';
import '../app_themes.dart';

class HimnoDetalle extends StatefulWidget {
  final Config config;
  final String path;
  final String title;

  const HimnoDetalle({
    super.key,
    required this.config,
    required this.path,
    required this.title,
  });

  @override
  State<HimnoDetalle> createState() => _HimnoDetalleState();
}

class _HimnoDetalleState extends State<HimnoDetalle> {
  late Future<String> himnoFuture;
  bool _mostrarAjustes = false;

  // Colores base para el modo profesional oscuro
  final Color _fondoProfundo = const Color(0xFF08080E);
  final Color _fondoCard = const Color(0xFF0F0F1A);

  @override
  void initState() {
    super.initState();
    himnoFuture = rootBundle.loadString(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.config,
      builder: (context, child) {
        final temaActual = AppThemes.biblioteca[widget.config.themeName] ?? AppThemes.biblioteca['oscuro']!;
        final seccion = temaActual.pestanas[widget.config.currentTab] ?? temaActual.pestanas[0]!;
        final String currentFont = widget.config.fontFamily == 'Serif' ? 'serif' : 'sans-serif';

        return Scaffold(
          backgroundColor: _fondoProfundo,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _fondoProfundo,
                  seccion.colorBorde.withOpacity(0.05), // Sutil matiz del color del tema
                  _fondoProfundo,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildHeader(seccion),
                      Expanded(
                        child: FutureBuilder<String>(
                          future: himnoFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator(color: seccion.colorBorde));
                            }

                            // Procesamiento profesional del texto: Separar título de estrofas
                            final lines = (snapshot.data ?? '').split(RegExp(r'\n\s*\n')).where((l) => l.trim().isNotEmpty).toList();

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              itemCount: lines.length,
                              itemBuilder: (context, index) {
                                final text = lines[index].trim();
                                final isTitle = index == 0;

                                return _buildTextSection(text, isTitle, seccion, currentFont);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Menú de ajustes flotante
                  if (_mostrarAjustes)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => setState(() => _mostrarAjustes = false),
                        child: Container(color: Colors.black26),
                      ),
                    ),
                  if (_mostrarAjustes)
                    Positioned(
                      top: 100,
                      right: 25,
                      child: _buildMenuFlotante(seccion),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ESTRUCTURA DE TEXTO: Solo bordes neón, relleno oscuro
  Widget _buildTextSection(String text, bool isTitle, SectionColors seccion, String fontFamily) {
    return Container(
      width: double.infinity,
      // 1. Reducimos el margen inferior si es título
      margin: EdgeInsets.only(bottom: isTitle ? 15 : 20),

      // 2. Reducimos el padding (espacio interno)
      padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: isTitle ? 15 : 25 // Antes era 35, ahora 15 para que sea más delgado
      ),

      decoration: BoxDecoration(
        color: _fondoCard,
        borderRadius: BorderRadius.circular(20), // Un radio un poco más cerrado se ve más limpio
        border: Border.all(
          color: isTitle ? seccion.colorBorde : seccion.colorBorde.withOpacity(0.2),
          width: isTitle ? 2.0 : 1, // Borde un poco más fino
        ),
        boxShadow: [
          if (isTitle)
            BoxShadow(
              color: seccion.colorBorde.withOpacity(0.2), // Brillo más sutil
              blurRadius: 10,
              spreadRadius: -1,
            ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: widget.config.himnoFontSize, // Mismo tamaño que pediste antes
          fontWeight: isTitle ? FontWeight.bold : FontWeight.w400,
          fontFamily: fontFamily,
          color: Colors.white,
          height: 1.3, // Reducimos el interlineado para que el cuadro no crezca hacia arriba
          letterSpacing: isTitle ? 0.5 : 0.4,
        ),
      ),
    );
  }

  Widget _buildHeader(SectionColors seccion) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _fondoCard,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(color: seccion.colorBorde, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: seccion.colorBorde.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: AutoSizeText(
              widget.title.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
            onPressed: () => setState(() => _mostrarAjustes = !_mostrarAjustes),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuFlotante(SectionColors seccion) {
    final double tamanoActual = widget.config.himnoFontSize;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161625),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white10, width: 1),
          boxShadow: const [
            BoxShadow(color: Colors.black87, blurRadius: 30, offset: Offset(0, 15))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "TAMAÑO DE FUENTE",
              style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(Icons.remove, () {
                  if (tamanoActual > 12) widget.config.updateConfig(himnoFontSize: tamanoActual - 1);
                }, seccion),
                Text(
                  tamanoActual.toInt().toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                _buildCircleButton(Icons.add, () {
                  if (tamanoActual < 40) widget.config.updateConfig(himnoFontSize: tamanoActual + 1);
                }, seccion),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap, SectionColors seccion) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: seccion.colorBorde.withOpacity(0.1),
          border: Border.all(color: seccion.colorBorde.withOpacity(0.3)),
        ),
        child: Icon(icon, color: seccion.colorBorde, size: 20),
      ),
    );
  }
}