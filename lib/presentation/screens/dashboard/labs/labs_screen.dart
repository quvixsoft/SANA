import 'package:flutter/material.dart';

class LabsScreen extends StatelessWidget {
  static const String routePath = '/labs';
  static const String routeName = 'labs';

  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Laboratorios (Próximamente)',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
