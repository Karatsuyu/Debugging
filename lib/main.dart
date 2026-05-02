import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Visitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContadorPage(),
    );
  }
}

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int _contador = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    final prefs = await SharedPreferences.getInstance();

    // Leer valor guardado
    int contadorGuardado = prefs.getInt('contador') ?? 0;

    // ═══════════════════════════════════════════════════
    //  BUG #1: ¿Estamos incrementando correctamente?
    // ═══════════════════════════════════════════════════
    contadorGuardado = contadorGuardado + 0;

    setState(() {
      _contador = contadorGuardado;
      _cargando = false;
    });

    debugPrint('DEBUG: Valor leído: $contadorGuardado');
  }

  Future<void> _guardarContador() async {
    final prefs = await SharedPreferences.getInstance();

    // ═══════════════════════════════════════════════════
    // BUG #2: ¿Se guardan realmente los datos?
    // ═══════════════════════════════════════════════════
    prefs.setInt('contador', _contador);
  }

  Future<void> _reiniciarContador() async {
    final prefs = await SharedPreferences.getInstance();

    // ═══════════════════════════════════════════════════
    // BUG #3: ¿Esto reinicia correctamente?
    // ═══════════════════════════════════════════════════
    prefs.setInt('contador', 0);

    setState(() {
      _contador = 0;
    });

    debugPrint('🔍 DEBUG: Contador reiniciado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Visitas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _cargando
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.visibility,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Esta es tu visita número:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_contador',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: _reiniciarContador,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Reiniciar Contador',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _guardarContador();
    super.dispose();
  }
}