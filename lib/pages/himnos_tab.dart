import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../app_themes.dart';
import 'contenido_himno.dart';

class HimnosTab extends StatefulWidget {
  final Config config;
  const HimnosTab({super.key, required this.config});

  @override
  State<HimnosTab> createState() => _HimnosTabState();
}

class _HimnosTabState extends State<HimnosTab> {
  List<String> allFiles = [];
  List<String> filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAssetList();
  }

  // CARGA DE ARCHIVOS
  Future<void> loadAssetList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final himnos = manifestMap.keys
        .where((key) => key.startsWith('assets/himnos/') && key.endsWith('.txt'))
        .toList();

    // ORDENAMIENTO DE ARCHIVOS
    himnos.sort((a, b) {
      final aNum = _extractHimnoNumber(a);
      final bNum = _extractHimnoNumber(b);
      return aNum.compareTo(bNum);
    });

    setState(() {
      allFiles = himnos;
      filteredFiles = allFiles;
    });
  }

  int _extractHimnoNumber(String path) { // OBTENER EL NUMERO DE HIMNO
    final fileName = path.split('/').last.split('.').first;
    final match = RegExp(r'^(\d+)').firstMatch(fileName);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  void filterSearch(String query) {
    setState(() {
      filteredFiles = allFiles
          .where((file) => getTitleFromPath(file).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String getTitleFromPath(String path) => path.split('/').last.replaceAll('.txt', '');

  @override
  Widget build(BuildContext context) {
    final temaActual = AppThemes.biblioteca[widget.config.themeName] ?? AppThemes.biblioteca['oscuro']!;
    final seccion = temaActual.pestanas[0]!;

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
            //  ENCABEZADO CON BORDE
            Container(
              height: 60+widget.config.fontSize, //ALTURA DE
              width: double.infinity,
              margin: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,  //COLOR DE FONDO
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                border: Border(
                  left: BorderSide(color: seccion.colorBorde, width: 2),
                  right: BorderSide(color: seccion.colorBorde, width: 2),
                  bottom: BorderSide(color: seccion.colorBorde, width: 5),
                ),
              ),
              child: Center(
                child: Text(
                  'HIMNOS',
                  style: TextStyle(
                    fontSize: widget.config.fontSize + 10,
                    fontWeight: FontWeight.w900,
                    color: seccion.colorTitulo,
                    letterSpacing: 6,
                  ),
                ),
              ),
            ),

            // SECCIÓN DE BÚSQUEDA
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    onChanged: filterSearch,
                    style: TextStyle(color: seccion.textoCuerpo),
                    decoration: InputDecoration(
                      hintText: 'Buscar himno',
                      hintStyle: TextStyle(
                        color: seccion.textoCuerpo.withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(Icons.search, color: seccion.colorBorde),
                      filled: true,
                      fillColor: seccion.cardFondo,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ],
              ),
            ),

            // 4. LISTA DE HIMNOS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final file = filteredFiles[index];
                  final title = getTitleFromPath(file);
                  final String number = title.split(' ').first;
                  final String name = title.replaceFirst(number, '').trim();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12), // Mayor separación entre elementos
                    child: Container(
                      decoration: BoxDecoration(
                        // Aplicamos un oscurecimiento sutil mediante el color de fondo de la celda
                        color: index.isOdd
                            ? Colors.black.withValues(alpha: 0.2) // Oscurecimiento para efecto cebra
                            : seccion.cardFondo, // Fondo base del tema
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: seccion.colorBorde.withValues(alpha: 0.1), // Borde casi invisible
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HimnoDetalle(
                              config: widget.config,
                              path: file,
                              title: title,
                            ),
                          ),
                        ),
                        leading: SizedBox(
                          width: 50,
                          child: Text(
                            number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: seccion.colorBorde, // Color de acento (azul/morado/verde)
                              fontWeight: FontWeight.w900,
                              fontSize: widget.config.fontSize  ,
                              backgroundColor: Colors.transparent, // Fondo totalmente transparente
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: widget.config.fontSize,
                            color: seccion.textoCuerpo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}