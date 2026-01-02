import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../app_themes.dart'; // Importante para los colores dinámicos
import 'contenido_himno.dart';

class FolderTab extends StatefulWidget {
  final Config config;
  const FolderTab({super.key, required this.config});

  @override
  State<FolderTab> createState() => _FolderTabState();
}

class _FolderTabState extends State<FolderTab> {
  List<String> allFiles = [];
  List<String> filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAssetList();
  }

  Future<void> loadAssetList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final himnos = manifestMap.keys
        .where((key) => key.startsWith('assets/folder/') && key.endsWith('.txt'))
        .toList();

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

  int _extractHimnoNumber(String path) {
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
    // 1. OBTENCIÓN DINÁMICA DEL TEMA (Sección 1 = Folder/Morado)
    final temaActual = AppThemes.biblioteca[widget.config.themeName] ?? AppThemes.biblioteca['oscuro']!;
    final seccion = temaActual.pestanas[1]!;

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
            // 2. ENCABEZADO CURVO PROFESIONAL
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
                child: Text(
                  'FOLDER',
                  style: TextStyle(
                    fontSize: widget.config.fontSize + 10,
                    fontWeight: FontWeight.w900,
                    color: seccion.colorTitulo,
                    letterSpacing: 6,
                  ),
                ),
              ),
            ),

            // 3. BUSCADOR CON ESTILO DE OSCURECIMIENTO (VIDRIO AHUMADO)
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: TextField(
                controller: searchController,
                onChanged: filterSearch,
                style: TextStyle(color: seccion.textoCuerpo),
                decoration: InputDecoration(
                  hintText: 'Buscar en folder...',
                  hintStyle: TextStyle(color: seccion.textoCuerpo.withValues(alpha: 0.4)),
                  prefixIcon: Icon(Icons.search, color: seccion.colorBorde),
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.2), // Oscurecimiento del buscador
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // 4. LISTA DE HIMNOS CON SEPARACIÓN Y NÚMERO TRANSPARENTE
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final file = filteredFiles[index];
                  final title = getTitleFromPath(file);
                  final String number = title.split(' ').first;
                  final String name = title.replaceFirst(number, '').trim();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12), // Separación de elementos
                    child: Container(
                      decoration: BoxDecoration(
                        // Efecto de oscurecimiento sutil
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: seccion.colorBorde.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                      child: ListTile(
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        // NÚMERO TRANSPARENTE Y MINIMALISTA
                        leading: SizedBox(
                          width: 40,
                          child: Text(
                            number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: seccion.colorBorde,
                              fontWeight: FontWeight.w900,
                              fontSize: widget.config.fontSize + 2,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: widget.config.fontSize,
                            color: seccion.textoCuerpo,
                            fontWeight: FontWeight.w400,
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