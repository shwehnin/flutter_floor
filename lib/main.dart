import 'package:flutter/material.dart';
import 'package:flutter_floor/pages/home/home_page.dart';

void main() {
  runApp(
    const FlutterFloor(),
  );
}

class FlutterFloor extends StatelessWidget {
  const FlutterFloor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(),
    );
  }
}
