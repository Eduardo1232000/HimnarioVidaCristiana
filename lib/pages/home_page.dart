import 'package:flutter/material.dart';
import 'himnos_tab.dart';
import 'folder_tab.dart';
import 'configuracion_tab.dart';
import '../config.dart';

class MyHomePage extends StatefulWidget {
  final Config config;
  const MyHomePage({super.key, required this.config});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: [
          HimnosTab(config: widget.config), // Config pasada aquí
          FolderTab(config: widget.config),
          ConfiguracionTab(config: widget.config),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // mantiene todos los labels visibles
        backgroundColor: Colors.black,         // color de fondo fijo
        selectedItemColor: Colors.lightBlue,  // color del item activo
        unselectedItemColor: Colors.grey,     // color de los items inactivos
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Himnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Folder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}