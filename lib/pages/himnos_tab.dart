import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
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

  Future<void> loadAssetList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final himnos = manifestMap.keys
        .where((key) => key.startsWith('assets/himnos/') && key.endsWith('.txt'))
        .toList();

    // Ordenar por número de himno
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
                Color(0xFF070731),
                Color(0xFF070731),
                Color(0xFF1c59ac),
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
                        left: const BorderSide(color: Color(0xFF6896d4), width: 3),
                        right: const BorderSide(color: Color(0xFF6896d4), width: 3),
                        bottom: const BorderSide(color: Color(0xFF6896d4), width: 5),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'HIMNOS',
                      style: TextStyle(
                        fontSize: widget.config.fontSize + 5,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // TÍTULO DEL BUSCADOR
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
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),

                  // LISTA DE HIMNOS
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredFiles.length,
                      itemBuilder: (context, index) {
                        final file = filteredFiles[index];
                        final title = getTitleFromPath(file);
                        final backgroundColor =
                        Colors.transparent.withOpacity(index.isEven ? 0.2 : 0.4);

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
