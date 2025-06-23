import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/login_model.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

    isLoading.value = true;
    print('[LoginController] Iniciando proceso de login.');
    try {
      final response = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Si llegamos aquí, el login fue exitoso y el token existe.
      print('[LoginController] Login exitoso. Respuesta del repositorio recibida.');
      await _authService.login(response);

      Get.rawSnackbar(
        message: 'Inicio de sesión exitoso',
        backgroundColor: Colors.green,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
      );

      // Navegamos hacia atrás inmediatamente.
      Get.back();

    } catch (e) {
      print('[LoginController] Excepción capturada. Mostrando error al usuario: $e');
      Get.snackbar(
        'Error de Login',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    print('[LoginController] Abriendo WebView para autenticación con Google.');
    try {
      // Navegar a la pantalla de WebView
      Get.toNamed('/google-signin-webview');
    } catch (e) {
      print('[LoginController] Error al abrir WebView: $e');
      Get.snackbar(
        'Error',
        'No se pudo abrir la autenticación con Google: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}