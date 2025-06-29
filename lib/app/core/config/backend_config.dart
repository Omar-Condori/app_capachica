class BackendConfig {
  // Configuración del backend
  static const String defaultBaseUrl = 'http://127.0.0.1:8000/api';
  
  // URLs alternativas para probar
  static const List<String> possibleUrls = [
    'http://127.0.0.1:8000/api',
    'http://localhost:8000/api',
    'http://10.0.2.2:8000/api', // Para emulador Android
    'http://192.168.1.100:8000/api', // IP local común
    'http://192.168.0.100:8000/api', // Otra IP local común
  ];
  
  // Timeout para peticiones HTTP
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Modo de prueba - cambiar a true para simular el backend
  static const bool testMode = true;
  
  // Datos de prueba para simular el backend
  static const Map<String, dynamic> testLoginResponse = {
    'token': 'test_token_123456789',
    'message': 'Login exitoso',
    'user': {
      'id': 1,
      'name': 'Usuario de Prueba',
      'email': 'test@example.com'
    },
    'success': true
  };
  
  static const Map<String, dynamic> testGoogleAuthUrl = {
    'data': {
      'url': 'https://accounts.google.com/o/oauth2/auth?client_id=test&redirect_uri=test&response_type=code&scope=email%20profile'
    },
    'success': true
  };
  
  // Método para obtener la URL del backend desde variables de entorno o configuración
  static String getBaseUrl() {
    // Aquí puedes agregar lógica para obtener la URL desde variables de entorno
    // Por ejemplo, desde un archivo de configuración o variables de entorno
    return defaultBaseUrl;
  }
  
  // Método para verificar si estamos en modo debug
  static bool isDebugMode() {
    // En Flutter, puedes usar kDebugMode de foundation.dart
    return true; // Por ahora siempre true para debugging
  }
} 