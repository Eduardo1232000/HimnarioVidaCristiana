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

  // FUNCION CAMBIAR PESTAÑA
  void _onItemTapped(int index) {
    widget.config.updateTab(index); //ACTUALIZAMOS EL NUMERO PARA ASIGNAR COLOR DEL CONFIG
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: IndexedStack(
        index: widget.config.currentTab,
        children: [
          HimnosTab(config: widget.config),
          FolderTab(config: widget.config),
          ConfiguracionTab(config: widget.config),
        ],
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: widget.config.currentTab,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,

          // COLORES DINAMICOS
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: activeColor,
          unselectedItemColor: Colors.grey.withValues(alpha: 0.5),

          selectedFontSize: 12,
          unselectedFontSize: 12,

          elevation: 0,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded),
              label: 'Himnos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_rounded),
              label: 'Folder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}