import 'package:flutter/material.dart';

class SumaPage extends StatefulWidget {
  const SumaPage({super.key});

  @override
  State<SumaPage> createState() => _SumaPageState();
}

class _SumaPageState extends State<SumaPage> {
  // Controladores para los campos de texto
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();
  double _result = 0.0;

  // Lógica para calcular la suma
  void _calculateSum() {
    setState(() {
      final double? num1 = double.tryParse(_firstNumberController.text);
      final double? num2 = double.tryParse(_secondNumberController.text);

      if (num1 != null && num2 != null) {
        _result = num1 + num2;
      } else {
        _result = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 233, 86),
        title: const Text('Sumar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Digite los numeros para sumar',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Primer número
            TextField(
              controller: _firstNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' digite el primer numero',
              ),
            ),
            const SizedBox(height: 20),
            // Segundo número
            TextField(
              controller: _secondNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' digite el segundo numero',
              ),
            ),
            const SizedBox(height: 20),
            // Botón para calcular
            ElevatedButton(
              onPressed: _calculateSum,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 73, 255), // Color del botón
                minimumSize: const Size(double.infinity, 50), // Ancho completo
              ),
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            // Muestra el resultado
            Text(
              'Resultado: $_result',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNumberController.dispose();
    _secondNumberController.dispose();
    super.dispose();
  }
} 