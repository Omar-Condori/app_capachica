import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/services_capachica_model.dart';

class ServicesCapachicaProvider {
  final String baseUrl;

  ServicesCapachicaProvider({required this.baseUrl});

  Future<List<ServicioCapachica>> fetchServicios() async {
    final response = await http.get(Uri.parse('$baseUrl/servicios'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data']['data'];
      return data.map((e) => ServicioCapachica.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los servicios');
    }
  }
} 