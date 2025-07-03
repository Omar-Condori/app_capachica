import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/reserva_model.dart';
import '../core/config/backend_config.dart';

class ReservaService extends GetxService {
  final _storage = GetStorage();
  static String _baseUrl = BackendConfig.defaultBaseUrl;
  
  // Getter para obtener la URL actual
  String get baseUrl => _baseUrl;
  
  // Método para cambiar la URL del backend
  void setBaseUrl(String url) {
    _baseUrl = url;
    print('[ReservaService] URL del backend cambiada a: $_baseUrl');
  }

  // Obtener token de autenticación
  String? get _token => _storage.read('token');

  // Headers con autenticación
  Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // POST /api/reservas/carrito/agregar
  Future<Map<String, dynamic>> agregarAlCarrito(AgregarAlCarritoRequest request) async {
    try {
      print('[ReservaService] Agregando al carrito: ${request.toJson()}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/reservas/carrito/agregar'),
        headers: _authHeaders,
        body: jsonEncode(request.toJson()),
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta agregar al carrito - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error agregando al carrito: $e');
      rethrow;
    }
  }

  // GET /api/reservas/carrito
  Future<CarritoResponse> obtenerCarrito() async {
    try {
      print('[ReservaService] Obteniendo carrito...');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/carrito'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta obtener carrito - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return CarritoResponse.fromJson(responseData);
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo carrito: $e');
      rethrow;
    }
  }

  // GET /api/reservas/mis-reservas
  Future<List<ReservaModel>> obtenerMisReservas() async {
    try {
      print('[ReservaService] Obteniendo mis reservas...');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/mis-reservas'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta mis reservas - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> reservasData = responseData['reservas'] ?? responseData;
        return reservasData.map((item) => ReservaModel.fromJson(item)).toList();
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo mis reservas: $e');
      rethrow;
    }
  }

  // DELETE /api/reservas/carrito/servicio/{id}
  Future<Map<String, dynamic>> eliminarDelCarrito(int servicioId) async {
    try {
      print('[ReservaService] Eliminando del carrito servicio ID: $servicioId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/reservas/carrito/servicio/$servicioId'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta eliminar del carrito - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error eliminando del carrito: $e');
      rethrow;
    }
  }

  // DELETE /api/reservas/carrito/vaciar
  Future<Map<String, dynamic>> vaciarCarrito() async {
    try {
      print('[ReservaService] Vaciando carrito...');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/reservas/carrito/vaciar'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta vaciar carrito - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error vaciando carrito: $e');
      rethrow;
    }
  }

  // POST /api/reservas/carrito/confirmar
  Future<Map<String, dynamic>> confirmarReserva(ConfirmarReservaRequest request) async {
    try {
      print('[ReservaService] Confirmando reserva: ${request.toJson()}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/reservas/carrito/confirmar'),
        headers: _authHeaders,
        body: jsonEncode(request.toJson()),
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta confirmar reserva - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error confirmando reserva: $e');
      rethrow;
    }
  }

  // GET /api/reservas/emprendedor/{emprendedorId}
  Future<List<ReservaModel>> obtenerReservasEmprendedor(int emprendedorId) async {
    try {
      print('[ReservaService] Obteniendo reservas del emprendedor ID: $emprendedorId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/emprendedor/$emprendedorId'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta reservas emprendedor - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> reservasData = responseData['reservas'] ?? responseData;
        return reservasData.map((item) => ReservaModel.fromJson(item)).toList();
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo reservas del emprendedor: $e');
      rethrow;
    }
  }

  // GET /api/reservas/servicio/{servicioId}
  Future<List<ReservaModel>> obtenerReservasServicio(int servicioId) async {
    try {
      print('[ReservaService] Obteniendo reservas del servicio ID: $servicioId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/servicio/$servicioId'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta reservas servicio - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> reservasData = responseData['reservas'] ?? responseData;
        return reservasData.map((item) => ReservaModel.fromJson(item)).toList();
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo reservas del servicio: $e');
      rethrow;
    }
  }

  // GET /api/reservas
  Future<List<ReservaModel>> obtenerTodasLasReservas() async {
    try {
      print('[ReservaService] Obteniendo todas las reservas...');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta todas las reservas - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> reservasData = responseData['reservas'] ?? responseData;
        return reservasData.map((item) => ReservaModel.fromJson(item)).toList();
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo todas las reservas: $e');
      rethrow;
    }
  }

  // POST /api/reservas
  Future<Map<String, dynamic>> crearReserva(Map<String, dynamic> reservaData) async {
    try {
      print('[ReservaService] Creando reserva: $reservaData');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/reservas'),
        headers: _authHeaders,
        body: jsonEncode(reservaData),
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta crear reserva - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error creando reserva: $e');
      rethrow;
    }
  }

  // GET /api/reservas/{id}
  Future<ReservaModel> obtenerReservaPorId(int id) async {
    try {
      print('[ReservaService] Obteniendo reserva ID: $id');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/$id'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta obtener reserva - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ReservaModel.fromJson(responseData);
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error obteniendo reserva: $e');
      rethrow;
    }
  }

  // PUT /api/reservas/{id}
  Future<Map<String, dynamic>> actualizarReserva(int id, Map<String, dynamic> reservaData) async {
    try {
      print('[ReservaService] Actualizando reserva ID: $id con datos: $reservaData');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/api/reservas/$id'),
        headers: _authHeaders,
        body: jsonEncode(reservaData),
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta actualizar reserva - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error actualizando reserva: $e');
      rethrow;
    }
  }

  // DELETE /api/reservas/{id}
  Future<Map<String, dynamic>> eliminarReserva(int id) async {
    try {
      print('[ReservaService] Eliminando reserva ID: $id');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/reservas/$id'),
        headers: _authHeaders,
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta eliminar reserva - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error eliminando reserva: $e');
      rethrow;
    }
  }

  // PUT /api/reservas/{id}/estado
  Future<Map<String, dynamic>> actualizarEstadoReserva(int id, String estado) async {
    try {
      print('[ReservaService] Actualizando estado de reserva ID: $id a: $estado');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/api/reservas/$id/estado'),
        headers: _authHeaders,
        body: jsonEncode({'estado': estado}),
      ).timeout(BackendConfig.requestTimeout);

      print('[ReservaService] Respuesta actualizar estado - Status: ${response.statusCode}');
      print('[ReservaService] Response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw _handleErrorResponse(responseData, response.statusCode);
      }
    } catch (e) {
      print('[ReservaService] Error actualizando estado de reserva: $e');
      rethrow;
    }
  }

  // Método para verificar si el usuario está autenticado
  bool get isAuthenticated => _token != null;

  // Método para manejar errores de respuesta
  String _handleErrorResponse(Map<String, dynamic> responseData, int statusCode) {
    if (responseData['message'] != null && responseData['errors'] == null) {
      return responseData['message'];
    }

    if (responseData['errors'] != null) {
      final errors = responseData['errors'] as Map<String, dynamic>;
      if (errors.isNotEmpty) {
        final allMessages = errors.values
            .expand((e) => e is List ? e : [e])
            .join('\n');
        return allMessages;
      }
    }

    switch (statusCode) {
      case 401:
        return 'No autorizado. Debes iniciar sesión.';
      case 403:
        return 'Acceso denegado';
      case 422:
        return 'Datos de entrada inválidos';
      case 500:
        return 'Error interno del servidor';
      default:
        return 'Error de conexión (Código: $statusCode)';
    }
  }
} 