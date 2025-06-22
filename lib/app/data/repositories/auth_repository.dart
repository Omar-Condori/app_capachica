import 'package:get/get.dart';
import '../models/login_model.dart';
import '../providers/auth_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  Future<LoginResponse?> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final response = await _authProvider.login(loginRequest);

      if (response.status.hasError) {
        throw Exception(response.statusText);
      }

      return response.body;
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }
}