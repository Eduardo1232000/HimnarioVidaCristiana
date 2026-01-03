import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../app_themes.dart'; // Importante para los temas

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

  @override
  void initState() {
    super.initState();
    himnoFuture = rootBundle.loadString(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tema actual basándonos en la configuración
    final temaActual = AppThemes.biblioteca[widget.config.themeName] ?? AppThemes.biblioteca['oscuro']!;
    // Usamos la sección de himnos (índice 0)
    final seccion = temaActual.pestanas[0]!;
    final String currentFont = widget.config.fontFamily == 'Serif' ? 'serif' : 'sans-serif';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: seccion.fondoMezcla,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ENCABEZADO ESTILIZADO (Igual al de Ajustes)
              _buildHeader(seccion),

              // CONTENIDO DEL HIMNO
              Expanded(
                child: FutureBuilder<String>(
                  future: himnoFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: seccion.colorBorde));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error al cargar', style: TextStyle(color: seccion.textoCuerpo)));
                    }

                    final paragraphs = (snapshot.data ?? '').split(RegExp(r'\n\s*\n'));

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: paragraphs.length,
                      itemBuilder: (context, index) {
                        final paragraphText = paragraphs[index].trim();
                        if (paragraphText.isEmpty) return const SizedBox.shrink();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: seccion.cardFondo,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: seccion.colorBorde.withOpacity(0.2),
                                width: 1
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Text(
                            paragraphText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.config.himnoFontSize,
                              fontFamily: currentFont,
                              color: seccion.textoCuerpo,
                              height: 1.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el encabezado con el título y botón atrás
  Widget _buildHeader(SectionColors seccion) {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: seccion.colorBorde, width: 2),
          right: BorderSide(color: seccion.colorBorde, width: 2),
          bottom: BorderSide(color: seccion.colorBorde, width: 5),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: seccion.colorTitulo, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: widget.config.fontSize + 2,
                  fontWeight: FontWeight.w900,
                  color: seccion.colorTitulo,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}