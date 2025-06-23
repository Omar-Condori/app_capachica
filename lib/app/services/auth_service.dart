import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/login_model.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();

  final currentUser = Rxn<User>();
  final token = Rxn<String>();

  bool get isLoggedIn => token.value != null;

  Future<AuthService> init() async {
    token.value = _storage.read('token');
    final userJson = _storage.read<Map<String, dynamic>>('user');
    if (userJson != null) {
      currentUser.value = User.fromJson(userJson);
    }
    return this;
  }

  Future<void> login(LoginResponse loginData) async {
    token.value = loginData.token;
    currentUser.value = loginData.user;
    await _storage.write('token', loginData.token);
    if (loginData.user != null) {
      await _storage.write('user', loginData.user!.toJson());
    }
  }

  Future<void> logout() async {
    token.value = null;
    currentUser.value = null;
    await _storage.remove('token');
    await _storage.remove('user');
  }
} 