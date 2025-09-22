import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/alquiler_controller.dart';

class DetalleVehiculoScreen extends StatefulWidget {
  final Map<String, dynamic> auto;
  final int clienteId;

  const DetalleVehiculoScreen({
    super.key,
    required this.auto,
    required this.clienteId,
  });

  @override
  State<DetalleVehiculoScreen> createState() => _DetalleVehiculoScreenState();
}

class _DetalleVehiculoScreenState extends State<DetalleVehiculoScreen> {
  bool _isLoading = false;
  bool _disponible = true; // Variable para el estado disponible

  @override
  void initState() {
    super.initState();
    // Inicializar el estado disponible basado en el vehículo
    _disponible = widget.auto['disponible'] ?? true;
    
    // Debug: imprimir datos iniciales
    print('DetalleVehiculoScreen inicializado:');
    print('Auto ID: ${widget.auto['id']}');
    print('Cliente ID: ${widget.clienteId}');
    print('Disponible: $_disponible');
    print('Marca: ${widget.auto['marca']}');
    print('Modelo: ${widget.auto['modelo']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 99, 38),
        foregroundColor: Colors.white,
        title: Text('${widget.auto['marca']} ${widget.auto['modelo']}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del vehículo
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: widget.auto['imagen'] != null && widget.auto['imagen'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        widget.auto['imagen'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.directions_car,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del vehículo
                  Text(
                    '${widget.auto['marca']} ${widget.auto['modelo']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 99, 38),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Año del vehículo
                  Text(
                    'Año: ${widget.auto['anio']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Información del vehículo en tarjetas
                  _buildInfoCard('Placa', widget.auto['placa'], Icons.confirmation_number),
                  _buildInfoCard('Valor de Alquiler', '\$${widget.auto['valorAlquiler']}', Icons.attach_money),
                  _buildInfoCard('Estado', _disponible ? 'Disponible' : 'No Disponible', 
                      _disponible ? Icons.check_circle : Icons.cancel),
                  
                  const SizedBox(height: 24),
                  
                  // Descripción
                  if (widget.auto['descripcion'] != null && widget.auto['descripcion'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.auto['descripcion'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  
                  // Botón de alquilar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _disponible && !_isLoading
                          ? () => _confirmarAlquiler()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _disponible
                            ? const Color.fromARGB(255, 0, 255, 64)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _disponible ? 'Alquilar Vehículo' : 'No Disponible',
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String titulo, String valor, IconData icono) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: const Color.fromARGB(255, 255, 99, 38),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para confirmar alquiler
  Future<void> _confirmarAlquiler() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Alquiler'),
          content: Text(
            '¿Estás seguro de que deseas alquilar este vehículo?\n\n'
            '${widget.auto['marca']} ${widget.auto['modelo']}\n'
            'Placa: ${widget.auto['placa']}\n'
            'Valor por día: \$${widget.auto['valorAlquiler']}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 255, 64),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _alquilarVehiculo();
    }
  }

  // Función para alquilar vehículo
  Future<void> _alquilarVehiculo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Debug: imprimir datos del alquiler
      print('Registrar alquiler:');
      print('Cliente ID: ${widget.clienteId}');
      print('Auto ID: ${widget.auto['id']}');
      print('Valor por día: \$${widget.auto['valorAlquiler']}');
      
      // Calcular fechas (por defecto: hoy y mañana)
      final fechaInicio = DateTime.now();
      final fechaFin = fechaInicio.add(const Duration(days: 1));
      final valorTotal = (widget.auto['valorAlquiler'] as num).toDouble();
      
      print('Fecha inicio: $fechaInicio');
      print('Fecha fin: $fechaFin');
      print('Valor total: \$$valorTotal');

      // Llamar al servicio de alquiler
      final resultado = await AlquilerController.registrarAlquiler(
        clienteId: widget.clienteId,
        autoId: widget.auto['id'],
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        valorTotal: valorTotal,
      );

      if (!mounted) return;

      if (resultado['success']) {
        // Alquiler exitoso
        setState(() {
          _disponible = false; // Marcar como no disponible
        });
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Debug: imprimir resultado exitoso
        print('Alquiler registrado exitosamente: ${resultado['data']}');

        // Navegar de vuelta después de un breve delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        // Error en el alquiler
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message']),
            backgroundColor: Colors.red,
          ),
        );
        
        // Debug: imprimir error
        print('Error al registrar alquiler: ${resultado['error']}');
      }
    } catch (e) {
      if (!mounted) return;
      
      // Debug: imprimir excepción
      print('Excepción al alquilar: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al alquilar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
