import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Leer Notas (Read)
  Future<void> _fetchNotes() async {
    try {
      final data = await _supabase.from('notas').select().order('created_at');
      setState(() {
        _notes = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Eliminar Nota (Delete)
  Future<void> _deleteNote(int id) async {
    await _supabase.from('notas').delete().match({'id': id});
    _fetchNotes(); // Recargar lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas de AutoDoc')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? const Center(child: Text('Aún no tienes notas.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Card(
                      child: ListTile(
                        title: Text(note['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(note['contenido'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(note['id']),
                        ),
                        onTap: () => _showNoteForm(note), // Para editar
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteForm(), // Para crear nueva
        child: const Icon(Icons.add),
      ),
    );
  }

  // Formulario para Crear/Editar (Create/Update)
  void _showNoteForm([Map<String, dynamic>? note]) {
    final tituloController = TextEditingController(text: note?['titulo']);
    final contenidoController = TextEditingController(text: note?['contenido']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(note == null ? 'Nueva Nota' : 'Editar Nota', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: contenidoController, decoration: const InputDecoration(labelText: 'Contenido')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text;
                final contenido = contenidoController.text;

                if (note == null) {
                  // Crear
                  await _supabase.from('notas').insert({'titulo': titulo, 'contenido': contenido});
                } else {
                  // Actualizar
                  await _supabase.from('notas').update({'titulo': titulo, 'contenido': contenido}).match({'id': note['id']});
                }
                Navigator.pop(context);
                _fetchNotes();
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}