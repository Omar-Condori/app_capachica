import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/backend_config.dart';
import '../core/exceptions/api_exception.dart';
import '../data/models/api_response_model.dart';
import '../data/models/slider_model.dart';
import '../data/models/municipalidad_model.dart';
import '../data/models/municipalidad_detalle_model.dart';

class MunicipalidadService {
  final http.Client _client = http.Client();

  // Método para verificar que la app funciona
  Future<ApiResponse<Map<String, dynamic>>> healthCheck() async {
    try {
      print('🔍 MunicipalidadService: Realizando health check...');
      
      if (BackendConfig.testMode) {
        print('🧪 MunicipalidadService: Usando modo de prueba para health check');
        await Future.delayed(Duration(milliseconds: 500)); // Simular delay
        return ApiResponse.success(
          data: {
            'status': 'ok',
            'message': 'API funcionando correctamente',
            'timestamp': DateTime.now().toIso8601String(),
          },
          message: 'API funcionando correctamente',
        );
      }

      final response = await _client
          .get(
            Uri.parse('${BackendConfig.getBaseUrl()}/'),
            headers: BackendConfig.defaultHeaders,
          )
          .timeout(BackendConfig.requestTimeout);

      print('📡 MunicipalidadService: Health check response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data, (json) => Map<String, dynamic>.from(json));
      } else {
        throw ApiException(
          message: 'Error en health check: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ MunicipalidadService: Error en health check: $e');
      if (e is ApiException) rethrow;
      throw NetworkException(message: 'Error de conexión: $e');
    }
  }

  // Método para obtener sliders/banners promocionales
  Future<List<Slider>> getSliders() async {
    try {
      print('🔍 MunicipalidadService: Obteniendo sliders...');
      
      if (BackendConfig.testMode) {
        print('🧪 MunicipalidadService: Usando modo de prueba para sliders');
        await Future.delayed(Duration(milliseconds: 800)); // Simular delay
        return [
          Slider(
            id: 1,
            title: 'Banner Promocional 1',
            description: 'Descubre la magia del lago Titicaca',
            imageUrl: 'https://example.com/banner1.jpg',
            linkUrl: 'https://example.com/promo1',
            isActive: true,
            order: 1,
          ),
          Slider(
            id: 2,
            title: 'Banner Promocional 2',
            description: 'Experiencias únicas en Capachica',
            imageUrl: 'https://example.com/banner2.jpg',
            linkUrl: 'https://example.com/promo2',
            isActive: true,
            order: 2,
          ),
        ];
      }

      final response = await _client
          .get(
            Uri.parse('${BackendConfig.getBaseUrl()}/sliders'),
            headers: BackendConfig.defaultHeaders,
          )
          .timeout(BackendConfig.requestTimeout);

      print('📡 MunicipalidadService: Sliders response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> slidersData = data['data'] ?? data;
        return slidersData.map((json) => Slider.fromJson(json)).toList();
      } else {
        throw ApiException(
          message: 'Error obteniendo sliders: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ MunicipalidadService: Error obteniendo sliders: $e');
      if (e is ApiException) rethrow;
      throw NetworkException(message: 'Error de conexión: $e');
    }
  }

  // Método para listar municipalidades
  Future<List<Municipalidad>> listMunicipalidades() async {
    try {
      print('🔍 MunicipalidadService: Obteniendo lista de municipalidades...');
      
      if (BackendConfig.testMode) {
        print('🧪 MunicipalidadService: Usando modo de prueba para municipalidades');
        await Future.delayed(Duration(milliseconds: 1000)); // Simular delay
        return [
          Municipalidad(
            id: 1,
            nombre: 'Municipalidad de Capachica',
            descripcion: 'Municipalidad principal de la península de Capachica',
            imagenUrl: 'https://example.com/muni1.jpg',
            ubicacion: 'Capachica, Puno',
            telefono: '+51 123 456 789',
            email: 'info@capachica.gob.pe',
            website: 'https://capachica.gob.pe',
            isActive: true,
          ),
          Municipalidad(
            id: 2,
            nombre: 'Municipalidad de Llachón',
            descripcion: 'Municipalidad de la comunidad de Llachón',
            imagenUrl: 'https://example.com/muni2.jpg',
            ubicacion: 'Llachón, Capachica',
            telefono: '+51 987 654 321',
            email: 'info@llachon.gob.pe',
            website: 'https://llachon.gob.pe',
            isActive: true,
          ),
        ];
      }

      final response = await _client
          .get(
            Uri.parse('${BackendConfig.getBaseUrl()}/municipalidad'),
            headers: BackendConfig.defaultHeaders,
          )
          .timeout(BackendConfig.requestTimeout);

      print('📡 MunicipalidadService: Municipalidades response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> municipalidadesData = data['data'] ?? data;
        return municipalidadesData.map((json) => Municipalidad.fromJson(json)).toList();
      } else {
        throw ApiException(
          message: 'Error obteniendo municipalidades: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ MunicipalidadService: Error obteniendo municipalidades: $e');
      if (e is ApiException) rethrow;
      throw NetworkException(message: 'Error de conexión: $e');
    }
  }

  // Método para obtener una municipalidad específica
  Future<Municipalidad> getMunicipalidad(int id) async {
    try {
      print('🔍 MunicipalidadService: Obteniendo municipalidad con ID: $id');
      
      if (BackendConfig.testMode) {
        print('🧪 MunicipalidadService: Usando modo de prueba para municipalidad $id');
        await Future.delayed(Duration(milliseconds: 600)); // Simular delay
        return Municipalidad(
          id: id,
          nombre: 'Municipalidad de Capachica',
          descripcion: 'Municipalidad principal de la península de Capachica, ubicada en las orillas del lago Titicaca',
          imagenUrl: 'https://example.com/muni$id.jpg',
          ubicacion: 'Capachica, Puno, Perú',
          telefono: '+51 123 456 789',
          email: 'info@capachica.gob.pe',
          website: 'https://capachica.gob.pe',
          isActive: true,
        );
      }

      final response = await _client
          .get(
            Uri.parse('${BackendConfig.getBaseUrl()}/municipalidad/$id'),
            headers: BackendConfig.defaultHeaders,
          )
          .timeout(BackendConfig.requestTimeout);

      print('📡 MunicipalidadService: Municipalidad $id response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final municipalidadData = data['data'] ?? data;
        return Municipalidad.fromJson(municipalidadData);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Municipalidad no encontrada');
      } else {
        throw ApiException(
          message: 'Error obteniendo municipalidad: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ MunicipalidadService: Error obteniendo municipalidad $id: $e');
      if (e is ApiException || e is NotFoundException) rethrow;
      throw NetworkException(message: 'Error de conexión: $e');
    }
  }

  // Método para obtener municipalidad con relaciones
  Future<MunicipalidadDetalle> getMunicipalidadConRelaciones(int id) async {
    try {
      print('🔍 MunicipalidadService: Obteniendo municipalidad $id con relaciones...');
      
      if (BackendConfig.testMode) {
        print('🧪 MunicipalidadService: Usando modo de prueba para municipalidad $id con relaciones');
        await Future.delayed(Duration(milliseconds: 1200)); // Simular delay
        
        final municipalidad = Municipalidad(
          id: id,
          nombre: 'Municipalidad de Capachica',
          descripcion: 'Municipalidad principal de la península de Capachica',
          imagenUrl: 'https://example.com/muni$id.jpg',
          ubicacion: 'Capachica, Puno',
          telefono: '+51 123 456 789',
          email: 'info@capachica.gob.pe',
          website: 'https://capachica.gob.pe',
          isActive: true,
        );

        final servicios = [
          Servicio(
            id: 1,
            nombre: 'Paseo en Bote',
            descripcion: 'Recorrido por las islas flotantes',
            imagenUrl: 'https://example.com/servicio1.jpg',
            precio: 50.0,
            isActive: true,
          ),
          Servicio(
            id: 2,
            nombre: 'Hospedaje Local',
            descripcion: 'Alojamiento en casas de familias locales',
            imagenUrl: 'https://example.com/servicio2.jpg',
            precio: 80.0,
            isActive: true,
          ),
        ];

        final negocios = [
          Negocio(
            id: 1,
            nombre: 'Restaurante El Lago',
            descripcion: 'Comida típica de la región',
            imagenUrl: 'https://example.com/negocio1.jpg',
            ubicacion: 'Plaza Principal, Capachica',
            telefono: '+51 987 654 321',
            email: 'info@ellago.com',
            isActive: true,
          ),
          Negocio(
            id: 2,
            nombre: 'Artesanías Titicaca',
            descripcion: 'Productos artesanales locales',
            imagenUrl: 'https://example.com/negocio2.jpg',
            ubicacion: 'Calle Comercial, Capachica',
            telefono: '+51 987 654 322',
            email: 'info@artesanias.com',
            isActive: true,
          ),
        ];

        return MunicipalidadDetalle(
          municipalidad: municipalidad,
          servicios: servicios,
          negocios: negocios,
          estadisticas: {
            'total_servicios': servicios.length,
            'total_negocios': negocios.length,
            'visitantes_mes': 1500,
          },
        );
      }

      final response = await _client
          .get(
            Uri.parse('${BackendConfig.getBaseUrl()}/municipalidad/$id/relaciones'),
            headers: BackendConfig.defaultHeaders,
          )
          .timeout(BackendConfig.requestTimeout);

      print('📡 MunicipalidadService: Municipalidad $id con relaciones response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final detalleData = data['data'] ?? data;
        return MunicipalidadDetalle.fromJson(detalleData);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Municipalidad no encontrada');
      } else {
        throw ApiException(
          message: 'Error obteniendo municipalidad con relaciones: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ MunicipalidadService: Error obteniendo municipalidad $id con relaciones: $e');
      if (e is ApiException || e is NotFoundException) rethrow;
      throw NetworkException(message: 'Error de conexión: $e');
    }
  }

  void dispose() {
    _client.close();
  }
} 