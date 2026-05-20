import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RepairDetailView extends StatefulWidget {
  final Map<String, dynamic> guia;

  const RepairDetailView({super.key, required this.guia});

  @override
  State<RepairDetailView> createState() => _RepairDetailViewState();
}

class _RepairDetailViewState extends State<RepairDetailView> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  late final Future<List<Map<String, dynamic>>> _futurePasos;
  late final Future<List<Map<String, dynamic>>> _futureHerramientas;

  @override
  void initState() {
    super.initState();
    final int guiaId = widget.guia['id'];

    // 1. Consulta a la tabla 'pasos' en base a tu nuevo SQL
    _futurePasos = supabase
        .from('pasos')
        .select()
        .eq('guia_id', guiaId)
        .order('orden', ascending: true); 

    // 2. Consulta relacional limpia (Trae directamente la info de la tabla enlazada)
    _futureHerramientas = supabase
        .from('guia_herramientas')
        .select('herramientas(nombre)') 
        .eq('guia_id', guiaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guia['titulo'] ?? 'Detalle de la Guía'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera estática de la guía
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(Icons.build_rounded, size: 50, color: Colors.blue.shade800),
                  const SizedBox(height: 10),
                  Text(
                    widget.guia['titulo'] ?? 'Sin título',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECCIÓN: DESCRIPCIÓN
            const Text(
              'Descripción del mantenimiento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Divider(color: Colors.blue),
            Text(
              widget.guia['descripcion'] ?? 'Sin descripción disponible.',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 24),

            // SECCIÓN DINÁMICA: HERRAMIENTAS
            const Row(
              children: [
                Icon(Icons.shopping_basket_rounded, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Herramientas y Materiales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            const Divider(color: Colors.orange),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureHerramientas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No se requieren herramientas específicas.', style: TextStyle(fontStyle: FontStyle.italic)),
                  );
                }

                return Column(
                  children: data.map((item) {
                    // Validamos de forma segura la estructura relacional de Supabase
                    final herramientasData = item['herramientas'];
                    String nombreHerramienta = 'Herramienta';

                    if (herramientasData is Map<String, dynamic>) {
                      nombreHerramienta = herramientasData['nombre'] ?? 'Herramienta';
                    } else if (herramientasData is List && herramientasData.isNotEmpty) {
                      nombreHerramienta = herramientasData[0]['nombre'] ?? 'Herramienta';
                    }
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.handyman_rounded, color: Colors.orange),
                        title: Text(nombreHerramienta),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),

            // SECCIÓN DINÁMICA: PASOS DE LA GUÍA
            const Row(
              children: [
                Icon(Icons.format_list_numbered_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Instrucciones paso a paso',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const Divider(color: Colors.green),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futurePasos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final pasos = snapshot.data ?? [];
                if (pasos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No hay pasos registrados para esta guía.', style: TextStyle(fontStyle: FontStyle.italic)),
                  );
                }
                return Column(
                  children: pasos.map((paso) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${paso['orden'] ?? '•'}. ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          Expanded(
                            child: Text(
                              paso['instruccion'] ?? 'Paso sin instrucción',
                              style: const TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}