import 'dart:io';
import 'package:flutter/foundation.dart';

/// Configuración centralizada del API.
///
/// Por qué existe este archivo:
/// - En emuladores/dispositivos, `localhost` NO apunta a tu PC.
/// - Android Emulator: usa 10.0.2.2
/// - iOS Simulator: usa 127.0.0.1
/// - Dispositivo físico: usa la IP LAN de tu PC (ajústala abajo).
class ApiConfig {
  /// Cuando está en true, la app NO llamará al backend y usará respuestas simuladas.
  static const bool useMock = true; // Cambia a false para volver a usar el backend real

  static const String _port = '3000';

  /// Si pruebas en un dispositivo físico, cambia esta IP por la de tu PC
  /// conectado a la misma red local (por ejemplo 192.168.1.50).
  static const String lanServerIp = '192.168.1.100'; // TODO: ajusta esta IP si usas dispositivo físico

  /// URL base calculada para la mayoría de casos (emuladores/simuladores y escritorio).
  static String get baseUrl {
    // Web (Flutter Web) normalmente puede usar localhost del navegador
    if (kIsWeb) {
      return 'http://localhost:$_port/api';
    }

    // Plataformas nativas
    if (Platform.isAndroid) {
      // Android Emulator redirige localhost del host con 10.0.2.2
      return 'http://10.0.2.2:$_port/api';
    } else if (Platform.isIOS) {
      // iOS Simulator puede hablar a localhost del host con 127.0.0.1
      return 'http://127.0.0.1:$_port/api';
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Ejecutando Flutter Desktop en la misma máquina del backend
      return 'http://localhost:$_port/api';
    }

    // Fallback
    return 'http://localhost:$_port/api';
  }

  /// Para dispositivo físico en la misma red local.
  /// Úsala si tu backend corre en tu PC y pruebas en un teléfono real.
  static String get baseUrlForPhysicalDevice => 'http://$lanServerIp:$_port/api';
}
