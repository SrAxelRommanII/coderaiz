import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase
import 'package:flutter_application_1/views/splash_view.dart';

void main() async { // 1. Agregamos async
  WidgetsFlutterBinding.ensureInitialized(); // 2. Necesario para inicializar plugins

  // 3. Inicializamos la conexión (PARTE 8 del manual)
  await Supabase.initialize(
    url: 'https://prsiqgynekyxrnnnvuev.supabase.co', // <-- Ponle la diagonal aquí al final
  anonKey: 'sb_publishable_SRdMMud49BV82rjQ5mgDUg_JGfV4fbA',
  );

  runApp(const AutoDocApp());
}

class AutoDocApp extends StatelessWidget {
  const AutoDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoDoc: Guía de Reparación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      // La pantalla que se verá apenas abra la app
      home: const SplashView(), 
    );
  }
}