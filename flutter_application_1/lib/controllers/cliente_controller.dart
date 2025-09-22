import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ClienteService {
  // URL base de tu API (ajusta según tu configuración)
  static final String baseUrl = ApiConfig.baseUrlForPhysicalDevice; // Dispositivo físico
  
  // Método para registrar un nuevo cliente
  static Future<Map<String, dynamic>> registrarCliente({
    required String nombre,
    required String correo,
    required String numLicencia,
    String? password,
  }) async {
    try {
      if (ApiConfig.useMock) {
        // Simulación sin tocar el backend
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'success': true,
          'message': 'Cliente registrado exitosamente (mock)',
          'data': {
            'id': 1,
            'nombre': nombre,
            'correo': correo,
            'numLicencia': numLicencia,
          },
        };
      }
      final response = await http.post(
        Uri.parse('$baseUrl/clientes'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(() {
          final Map<String, dynamic> body = {
            'nombre': nombre,
            'correo': correo,
            'numLicencia': numLicencia,
          };
          if (password != null && password.isNotEmpty) {
            body['password'] = password;
          }
          return body;
        }()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro exitoso
        return {
          'success': true,
          'message': 'Cliente registrado exitosamente',
          'data': jsonDecode(response.body),
        };
      } else {
        // Error en el servidor
        return {
          'success': false,
          'message': 'Error al registrar cliente: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      // Error de conexión o excepción
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }

  // Método para solicitar recuperación de contraseña (mock y real opcional)
  static Future<Map<String, dynamic>> recuperarPassword({
    required String correo,
  }) async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'success': true,
          'message': 'Correo de recuperación enviado (mock) a $correo',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/clientes/recuperar'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'correo': correo}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Correo de recuperación enviado',
        };
      } else {
        return {
          'success': false,
          'message': 'No se pudo iniciar la recuperación: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }

  // Método para login del cliente
  static Future<Map<String, dynamic>> loginCliente({
    required String correo,
    String? numLicencia,
    String? password,
  }) async {
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(milliseconds: 250));
        final ok = correo.isNotEmpty && ((numLicencia != null && numLicencia.isNotEmpty) || (password != null && password.isNotEmpty));
        if (ok) {
          return {
            'success': true,
            'message': 'Login exitoso (mock)',
            'data': {
              'token': 'mock-token',
              'cliente': {
                'id': 1,
                'nombre': 'Cliente Mock',
                'correo': correo,
                'numLicencia': numLicencia ?? 'N/A',
              }
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Credenciales inválidas (mock)',
            'error': 'empty_fields',
          };
        }
      }
      final response = await http.post(
        Uri.parse('$baseUrl/clientes/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode((){
          final Map<String, dynamic> body = {
            'correo': correo,
          };
          if (numLicencia != null && numLicencia.isNotEmpty) body['numLicencia'] = numLicencia;
          if (password != null && password.isNotEmpty) body['password'] = password;
          return body;
        }()),
      );

      if (response.statusCode == 200) {
        // Login exitoso
        return {
          'success': true,
          'message': 'Login exitoso',
          'data': jsonDecode(response.body),
        };
      } else {
        // Error de autenticación
        return {
          'success': false,
          'message': 'Credenciales inválidas',
          'error': response.body,
        };
      }
    } catch (e) {
      // Error de conexión o excepción
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }
}
