import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';

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
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              // Flecha atrás fija arriba
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Colors.white,
                      size: widget.config.himnoFontSize + 8),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Contenido desplazable con párrafos en cuadros
              Expanded(
                child: FutureBuilder<String>(
                  future: himnoFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // Dividir texto en párrafos usando doble salto de línea
                    final paragraphs = (snapshot.data ?? '')
                        .split(RegExp(r'\n\s*\n'));

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: paragraphs.length,
                      itemBuilder: (context, index) {
                        final color = Colors.white10;
                        // Aquí se respeta saltos simples '\n' dentro del texto
                        final paragraphText = paragraphs[index].trim();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            paragraphText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.config.himnoFontSize,
                              color: Colors.white,
                              height: 1.4, // para mejor legibilidad
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
}
