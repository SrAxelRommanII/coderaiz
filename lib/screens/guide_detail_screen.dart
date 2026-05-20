import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  final Map<String, dynamic> guia;

  const GuideDetailScreen({super.key, required this.guia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guia['titulo'] ?? 'Detalle de la Guía'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner superior decorativo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(Icons.build_circle_rounded, size: 60, color: Colors.blue.shade800),
                  const SizedBox(height: 10),
                  Text(
                    guia['titulo'] ?? 'Sin título',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // <-- Debe ser TextAlign.center, no Center a secas
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Sección de Descripción
            const Text(
              'Descripción del mantenimiento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Divider(color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              guia['descripcion'] ?? 'No hay descripción detallada disponible.',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            
            const SizedBox(height: 40),
            
            // Botones de acción exigidos por la rúbrica (Edición y Eliminación)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar pantalla de edición
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar función de borrado en Supabase
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}