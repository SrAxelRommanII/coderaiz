import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/models/guide_model.dart';
import 'package:flutter_application_1/views/tools_view.dart';

class CategoryListView extends StatefulWidget {
  final String categoryName;

  const CategoryListView({super.key, required this.categoryName});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>(); // Para validación del Formulario (Fase 5)
  
  // Controladores para capturar el texto
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _diffController = TextEditingController();
  final _timeController = TextEditingController();

  // Mapeo rápido de nombres a IDs según tu base de datos
  int _getCategoryId() {
    if (widget.categoryName == 'Frenos') return 1;
    if (widget.categoryName == 'Motor') return 2;
    if (widget.categoryName == 'Fluidos') return 3;
    return 1; // Por defecto
  }

  // REQUISITO: CONSULTAR REGISTROS (READ)
  Future<List<RepairGuide>> _fetchGuidesFromSupabase() async {
    final response = await supabase
        .from('guias')
        .select('*, categorias!inner(nombre)')
        .eq('categorias.nombre', widget.categoryName);

    final List data = response as List;
    return data.map((json) => RepairGuide.fromMap(json)).toList();
  }

  // REQUISITO: CREAR REGISTROS (CREATE + VALIDADOR + ALERTA EXITO/ERROR)
  void _createNewGuide() async {
    if (_formKey.currentState!.validate()) {
      try {
        await supabase.from('guias').insert({
          'categoria_id': _getCategoryId(),
          'titulo': _titleController.text.trim(),
          'descripcion': _descController.text.trim(),
          'dificultad': _diffController.text.trim().isEmpty ? 'Intermedio' : _diffController.text.trim(),
          'tiempo_estimado': _timeController.text.trim().isEmpty ? '1 hora' : _timeController.text.trim(),
        });

        if (!mounted) return;
        Navigator.pop(context); // Cierra el formulario
        _clearControllers();
        setState(() {}); // Refresca la lista en tiempo real
        
        // Mensaje de Éxito (Fase 5)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Guía agregada exitosamente!'), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // REQUISITO: EDITAR REGISTROS (UPDATE + VALIDADOR)
  void _editGuide(int id) async {
    if (_formKey.currentState!.validate()) {
      try {
        await supabase.from('guias').update({
          'titulo': _titleController.text.trim(),
          'descripcion': _descController.text.trim(),
          'dificultad': _diffController.text.trim(),
          'tiempo_estimado': _timeController.text.trim(),
        }).eq('id', id);

        if (!mounted) return;
        Navigator.pop(context);
        _clearControllers();
        setState(() {}); // Refresca la pantalla
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Guía actualizada con éxito!'), backgroundColor: Colors.blue),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // REQUISITO: ELIMINAR REGISTROS (DELETE)
  void _deleteGuide(int id) async {
    try {
      await supabase.from('guias').delete().eq('id', id);
      setState(() {}); // Actualiza la interfaz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guía eliminada correctamente'), backgroundColor: Colors.orange),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _clearControllers() {
    _titleController.clear();
    _descController.clear();
    _diffController.clear();
    _timeController.clear();
  }

  // DISEÑO DEL FORMULARIO DE REGISTRO / EDICIÓN
  void _showFormModal({int? guideId, RepairGuide? existingGuide}) {
    if (existingGuide != null) {
      _titleController.text = existingGuide.titulo;
      _descController.text = existingGuide.descripcion;
      _diffController.text = existingGuide.dificultad;
      _timeController.text = existingGuide.tiempoEstimado;
    } else {
      _clearControllers();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Evita que el teclado tape el diseño
          top: 20, left: 20, right: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  existingGuide == null ? 'Nueva Guía de Mantenimiento' : 'Editar Guía',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título de la guía *', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? 'El título es obligatorio' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Descripción corta *', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? 'La descripción es obligatoria' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _diffController,
                  decoration: const InputDecoration(labelText: 'Dificultad (Ej: Fácil, Intermedio)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Tiempo estimado (Ej: 45 min)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (existingGuide == null) {
                      _createNewGuide();
                    } else {
                      _editGuide(guideId!);
                    }
                  },
                  child: Text(existingGuide == null ? 'Guardar Guía' : 'Actualizar Cambios', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guías de ${widget.categoryName}'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<RepairGuide>>(
        future: _fetchGuidesFromSupabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al conectar con la base de datos'));
          }

          final guides = snapshot.data ?? [];

          if (guides.isEmpty) {
            return Center(
              child: Text('Aún no hay guías para la categoría ${widget.categoryName}.'),
            );
          }

          return ListView.builder(
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.build_circle, color: Colors.blue, size: 40),
                  title: Text(guide.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(guide.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ICONO EDITAR (UPDATE)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () => _showFormModal(guideId: guide.id, existingGuide: guide),
                      ),
                      // ICONO ELIMINAR (DELETE)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Validación rápida de confirmación antes de borrar
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('¿Eliminar guía?'),
                              content: const Text('Esta acción quitará el registro permanentemente de Supabase.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteGuide(guide.id);
                                  }, 
                                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToolsView(guide: guide)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // BOTÓN FLOTANTE PARA CREAR (CREATE)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        onPressed: () => _showFormModal(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}