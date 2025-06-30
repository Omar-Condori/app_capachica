import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/services_capachica_model.dart';
import '../../core/config/backend_config.dart';

class ServicesCapachicaProvider {
  final String baseUrl;

  ServicesCapachicaProvider({String? baseUrl}) 
    : baseUrl = baseUrl ?? BackendConfig.getBaseUrl();

  Future<List<ServicioCapachica>> fetchServicios() async {
    try {
      print('🔄 ServicesCapachicaProvider: Iniciando fetch de servicios...');
      print('🌐 ServicesCapachicaProvider: URL: $baseUrl/servicios');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servicios'),
        headers: BackendConfig.defaultHeaders,
      ).timeout(BackendConfig.requestTimeout);
      
      print('📡 ServicesCapachicaProvider: Status code: ${response.statusCode}');
      print('📄 ServicesCapachicaProvider: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        
        // Manejar diferentes estructuras de respuesta
        List<dynamic> data;
        if (decoded['data'] != null && decoded['data']['data'] != null) {
          data = decoded['data']['data'];
        } else if (decoded['data'] != null) {
          data = decoded['data'] is List ? decoded['data'] : [decoded['data']];
        } else {
          data = decoded is List ? decoded : [decoded];
        }
        
        final servicios = data.map((e) => ServicioCapachica.fromJson(e)).toList();
        print('✅ ServicesCapachicaProvider: ${servicios.length} servicios cargados exitosamente');
        return servicios;
      } else {
        print('❌ ServicesCapachicaProvider: Error HTTP ${response.statusCode}');
        throw Exception('Error al cargar los servicios: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ ServicesCapachicaProvider: Error en fetchServicios: $e');
      throw Exception('Error al cargar los servicios: $e');
    }
  }

  Future<ServicioCapachica> fetchServicioById(int id) async {
    try {
      print('🔄 ServicesCapachicaProvider: Obteniendo servicio con ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servicios/$id'),
        headers: BackendConfig.defaultHeaders,
      ).timeout(BackendConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'] ?? decoded;
        final servicio = ServicioCapachica.fromJson(data);
        print('✅ ServicesCapachicaProvider: Servicio $id cargado exitosamente');
        return servicio;
      } else {
        throw Exception('Error al cargar el servicio: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ServicesCapachicaProvider: Error en fetchServicioById: $e');
      throw Exception('Error al cargar el servicio: $e');
    }
  }

  Future<List<ServicioCapachica>> fetchServiciosByCategoria(int categoriaId) async {
    try {
      print('🔄 ServicesCapachicaProvider: Obteniendo servicios por categoría: $categoriaId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servicios/categoria/$categoriaId'),
        headers: BackendConfig.defaultHeaders,
      ).timeout(BackendConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;
        if (decoded['data'] != null && decoded['data']['data'] != null) {
          data = decoded['data']['data'];
        } else if (decoded['data'] != null) {
          data = decoded['data'] is List ? decoded['data'] : [decoded['data']];
        } else {
          data = decoded is List ? decoded : [decoded];
        }
        
        final servicios = data.map((e) => ServicioCapachica.fromJson(e)).toList();
        print('✅ ServicesCapachicaProvider: ${servicios.length} servicios por categoría cargados');
        return servicios;
      } else {
        throw Exception('Error al cargar servicios por categoría: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ServicesCapachicaProvider: Error en fetchServiciosByCategoria: $e');
      throw Exception('Error al cargar servicios por categoría: $e');
    }
  }

  Future<List<ServicioCapachica>> fetchServiciosByEmprendedor(int emprendedorId) async {
    try {
      print('🔄 ServicesCapachicaProvider: Obteniendo servicios por emprendedor: $emprendedorId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servicios/emprendedor/$emprendedorId'),
        headers: BackendConfig.defaultHeaders,
      ).timeout(BackendConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;
        if (decoded['data'] != null && decoded['data']['data'] != null) {
          data = decoded['data']['data'];
        } else if (decoded['data'] != null) {
          data = decoded['data'] is List ? decoded['data'] : [decoded['data']];
        } else {
          data = decoded is List ? decoded : [decoded];
        }
        
        final servicios = data.map((e) => ServicioCapachica.fromJson(e)).toList();
        print('✅ ServicesCapachicaProvider: ${servicios.length} servicios por emprendedor cargados');
        return servicios;
      } else {
        throw Exception('Error al cargar servicios por emprendedor: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ServicesCapachicaProvider: Error en fetchServiciosByEmprendedor: $e');
      throw Exception('Error al cargar servicios por emprendedor: $e');
    }
  }
} 