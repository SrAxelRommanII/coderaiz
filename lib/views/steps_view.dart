import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/models/guide_model.dart';

class StepsView extends StatelessWidget {
  final RepairGuide guide;

  const StepsView({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasos de la Reparación'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: supabase
            .from('pasos')
            .select()
            .eq('guia_id', guide.id)
            .order('orden', ascending: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) return const Center(child: Text('Error al cargar pasos'));

          final steps = snapshot.data as List<dynamic>;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1A237E),
                    child: Text('${step['orden']}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(step['instruccion']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}