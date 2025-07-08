import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
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

    // Ordenar por número extraído del nombre del archivo
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

  String getTitleFromPath(String path) {
    return path.split('/').last.replaceAll('.txt', '');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.config,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF170731),
                Color(0xFF170731),
                Color(0xFF501cac),
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // ENCABEZADO
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      border: Border(
                        top: BorderSide.none,
                        left: const BorderSide(color: Color(0xFF8f68d4), width: 3),
                        right: const BorderSide(color: Color(0xFF8f68d4), width: 3),
                        bottom: const BorderSide(color: Color(0xFF8f68d4), width: 5),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'FOLDER',
                      style: TextStyle(
                        fontSize: widget.config.fontSize + 5,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // SUBTÍTULO DEL BUSCADOR
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Buscar Himno',
                          style: TextStyle(
                            fontSize: widget.config.fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BUSCADOR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSearch,
                      decoration: InputDecoration(
                        hintText: 'Buscar himno...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: TextStyle(
                        fontSize: widget.config.fontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // LISTA DE HIMNOS
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredFiles.length,
                      itemBuilder: (context, index) {
                        final file = filteredFiles[index];
                        final title = getTitleFromPath(file);
                        final baseColor = Colors.transparent;
                        final backgroundColor = baseColor.withOpacity(index.isEven ? 0.2 : 0.4);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            color: backgroundColor,
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(
                                  fontSize: widget.config.fontSize,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HimnoDetalle(
                                      config: widget.config,
                                      path: file,
                                      title: title,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
