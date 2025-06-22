import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/login_model.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final GetStorage _storage = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (response?.token != null) {
        // Guardar token y datos del usuario
        await _storage.write('token', response!.token);
        await _storage.write('user', response.user!.toJson());

        Get.snackbar(
          'Éxito',
          'Login exitoso',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navegar al home
        Get.offAllNamed('/home');
      } else {
        // Si no hay token, mostrar el mensaje de error del API.
        Get.snackbar(
          'Error de Login',
          response?.message ?? 'Las credenciales son incorrectas',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}