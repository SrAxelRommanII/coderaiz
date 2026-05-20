import 'package:flutter/material.dart';
// 1. Cambiamos el import para que reconozca la nueva pantalla
import 'package:flutter_application_1/screens/product_screen.dart';


class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blueGrey[900], 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.build_circle, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'AUTODOC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Tu guía mecánica de confianza',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // 2. Ahora navegamos a ProductScreen (la que tiene la conexión a Supabase)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductScreen()),
                );
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}
