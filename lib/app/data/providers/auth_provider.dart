import 'package:get/get.dart';
import '../models/login_model.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://127.0.0.1:8000/api';
    httpClient.timeout = Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }

  Future<Response<LoginResponse>> login(LoginRequest loginRequest) async {
    print('[AuthProvider] Iniciando petición POST a /login');
    final response = await post<LoginResponse>(
      '/login',
      loginRequest.toJson(),
      decoder: (data) {
        print('[AuthProvider] Decodificando respuesta del login: $data');
        return LoginResponse.fromJson(data);
      },
    );
    print('[AuthProvider] Respuesta recibida del servidor con Status: ${response.statusCode}');
    print('[AuthProvider] Cuerpo de la respuesta: ${response.bodyString}');
    return response;
  }

  Future<Response> register(FormData formData) async {
    return await post(
      '/register',
      formData,
    );
  }

  Future<Response> getGoogleSignInUrl() async {
    print('[AuthProvider] Obteniendo URL de autenticación de Google...');
    return await get('/auth/google');
  }

  Future<Response<LoginResponse>> verifyGoogleToken(String token) async {
    print('[AuthProvider] Iniciando petición GET a /auth/google con token');
    final response = await get<LoginResponse>(
      '/auth/google?token=$token',
      decoder: (data) {
        print('[AuthProvider] Decodificando respuesta de Google auth: $data');
        return LoginResponse.fromJson(data);
      },
    );
    print('[AuthProvider] Respuesta recibida del servidor con Status: ${response.statusCode}');
    print('[AuthProvider] Cuerpo de la respuesta: ${response.bodyString}');
    return response;
  }
}