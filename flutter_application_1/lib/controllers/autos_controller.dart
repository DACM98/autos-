import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AutosController {
  // URL base de tu API (ajusta según tu configuración)
  static final String baseUrl = ApiConfig.baseUrlForPhysicalDevice; // Centralizado según plataforma
  
  // Método para obtener autos disponibles
  static Future<List<Map<String, dynamic>>> obtenerAutosDisponibles() async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 250));
        return [
          {
            'id': 101,
            'marca': 'Toyota',
            'modelo': 'Corolla',
            'anio': 2022,
            'placa': 'ABC123',
            'imagen': '',
            'valorAlquiler': 45.0,
            'disponible': true,
            'descripcion': 'Sedán económico',
          },
          {
            'id': 102,
            'marca': 'Hyundai',
            'modelo': 'Tucson',
            'anio': 2021,
            'placa': 'XYZ987',
            'imagen': '',
            'valorAlquiler': 70.0,
            'disponible': false,
            'descripcion': 'SUV cómoda',
          },
        ];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/disponibles'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Convertir la respuesta JSON a una lista de autos
        final List<dynamic> data = jsonDecode(response.body);
        
        // Mapear los datos a un formato más manejable
        return data.map((auto) {
          return {
            'id': auto['id'],
            'marca': auto['marca'],
            'modelo': auto['modelo'],
            'anio': auto['anio'],
            'placa': auto['placa'],
            'imagen': auto['imagen'],
            'valorAlquiler': auto['valorAlquiler'],
            'disponible': auto['disponible'],
            'descripcion': auto['descripcion'],
          };
        }).toList();
      } else {
        // Error en el servidor
        throw Exception('Error al obtener autos: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión o excepción
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener un auto específico por ID
  static Future<Map<String, dynamic>> obtenerAutoPorId(int autoId) async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 200));
        return {
          'id': autoId,
          'marca': 'MockMarca',
          'modelo': 'MockModelo',
          'anio': 2020,
          'placa': 'MOCK-$autoId',
          'imagen': '',
          'valorAlquiler': 55.0,
          'disponible': true,
          'descripcion': 'Auto simulado',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/autos/$autoId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> auto = jsonDecode(response.body);
        return {
          'id': auto['id'],
          'marca': auto['marca'],
          'modelo': auto['modelo'],
          'anio': auto['anio'],
          'placa': auto['placa'],
          'imagen': auto['imagen'],
          'valorAlquiler': auto['valorAlquiler'],
          'disponible': auto['disponible'],
          'descripcion': auto['descripcion'],
        };
      } else {
        throw Exception('Error al obtener auto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
