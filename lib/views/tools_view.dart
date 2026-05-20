import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/steps_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/models/guide_model.dart';

class ToolsView extends StatelessWidget {
  final RepairGuide guide;

  const ToolsView({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas Necesarias'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        // Consultamos la tabla intermedia para obtener los nombres de las herramientas
        future: _fetchTools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar herramientas'));
          }

          final tools = snapshot.data as List<dynamic>;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Para: ${guide.titulo}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tools.length,
                  itemBuilder: (context, index) {
                    // Accedemos al nombre de la herramienta a través de la relación
                    final toolName = tools[index]['herramientas']['nombre'];
                    return ListTile(
                      leading: const Icon(Icons.handyman, color: Colors.orange),
                      title: Text(toolName),
                    );
                  },
                ),
              ),
              // Botón para ir a los pasos (Siguiente Fase)
             Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => StepsView(guide: guide),
        ),
      );
    },
    child: const Text('Ver Pasos de la Reparación'),
  ),
)
            ],
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchTools() async {
    final supabase = Supabase.instance.client;
    // Esta consulta es "mágica": entra a la tabla intermedia y jala el nombre de la herramienta
    return await supabase
        .from('guia_herramientas')
        .select('herramientas(nombre)')
        .eq('guia_id', guide.id);
  }
}