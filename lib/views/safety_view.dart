import 'package:flutter/material.dart';

class SafetyView extends StatelessWidget {
  const SafetyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consejos de Seguridad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text('Usa siempre guantes y lentes de protección.'),
          ),
          ListTile(
            leading: Icon(Icons.front_loader, color: Colors.orange),
            title: Text('Asegúrate de que el motor esté frío antes de tocarlo.'),
          ),
          ListTile(
            leading: Icon(Icons.car_repair, color: Colors.orange),
            title: Text('Nunca trabajes debajo de un auto sostenido solo por un gato.'),
          ),
        ],
      ),
    );
  }
}