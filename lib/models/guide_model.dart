class RepairGuide {
  final int id;
  final String titulo;     
  final String descripcion; 
  final String dificultad;  
  final String tiempoEstimado; // Agregamos esta que está en tu SQL
  final int categoriaId;    // Es un int en la DB (Foreign Key)

  // Estas las dejaremos para cuando hagamos un SELECT con JOIN
  final List<String> tools;
  final List<String> steps;

  RepairGuide({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.dificultad,
    required this.tiempoEstimado,
    required this.categoriaId,
    this.tools = const [],
    this.steps = const [],
  });

  factory RepairGuide.fromMap(Map<String, dynamic> map) {
    return RepairGuide(
      id: map['id'],
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      dificultad: map['dificultad'] ?? '',
      tiempoEstimado: map['tiempo_estimado'] ?? '', // Coincide con tu SQL
      categoriaId: map['categoria_id'] ?? 0,        // Coincide con tu SQL
      // Por ahora, como Supabase devuelve tablas planas, 
      // tools y steps se llenan por separado después.
    );
  }
}