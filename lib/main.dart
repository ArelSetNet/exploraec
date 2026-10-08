import 'package:flutter/material.dart';

void main() {
  runApp(const ExploraEcApp());
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Design DNA: Se utiliza la tipografía estándar del sistema (sans-serif)
        // con pesos geométricos y tracking ajustado en sustitución de 'Plus Jakarta Sans',
        // para no requerir fuentes personalizadas ni dependencias externas en pubspec.yaml.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006948), // Verde Esmeralda (Primary)
          primary: const Color(0xFF006948),
          surface: const Color(0xFFFAF8FF), // Fondo claro
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espaciador superior para centrado vertical armónico
              const SizedBox(height: 20),

              // Bloque central: Ícono con insignia y halo, Título y Subtítulo
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Insignia circular verde esmeralda con halo difuminado suave
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF059669).withValues(alpha: 0.12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF059669).withValues(alpha: 0.18),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF059669), // Emerald Vista
                      ),
                      child: const Icon(
                        Icons.explore_rounded, // Ícono de exploración y ubicación
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Título principal de la aplicación
                  const Text(
                    'ExploraEC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF131B2E), // Obsidian Slate
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtítulo descriptivo centrado
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: const Text(
                      'Descubre y guarda lugares cerca de ti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D4A42), // Slate Variant
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),

              // Botón principal de ancho completo tipo píldora
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción de bienvenida (sin navegación funcional por ahora)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669), // Verde Esmeralda
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFF059669).withValues(alpha: 0.35),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Empezar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}