import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _emailKey = 'email'; // Clave para el email
  static const String _passwordKey = 'password'; // Clave para la contraseña
  static const String _isLoggedInKey = 'isLoggedIn'; // Clave para el estado de login
  static const String _clienteIdKey = 'clienteId'; // Clave para el ID del cliente

  // Guarda las credenciales del usuario
  static Future<void> saveUserCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  // Recupera las credenciales del usuario
  static Future<Map<String, String?>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_emailKey),
      'password': prefs.getString(_passwordKey),
    };
  }

  // Verifica si un email ya está registrado
  static Future<bool> isEmailRegistered(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_emailKey);
    return savedEmail == email;
  }

  // Marca si el usuario está logueado
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  // Verifica si el usuario está logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Guarda el ID del cliente
  static Future<void> saveClienteId(int clienteId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_clienteIdKey, clienteId);
  }

  // Recupera el ID del cliente
  static Future<int?> getClienteId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clienteIdKey);
  }

  // Borra los datos del usuario (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_clienteIdKey);
  }

  // Verifica si hay datos de usuario guardados
  static Future<bool> hasUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_emailKey) && prefs.containsKey(_passwordKey);
  }
} 