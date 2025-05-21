import 'package:flutter/material.dart';
import 'gui.dart';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(400, 600),
      minimumSize: Size(400, 600),
      center: true,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
  runApp(const BlinkDoroApp());
}

class BlinkDoroApp extends StatelessWidget {
  const BlinkDoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlinkDoro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BlinkDoroGUI(),
    );
  }
}
