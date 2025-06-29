import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

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
      // Probar formatos de respuesta para debugging
      await _authService.testResponseFormats();
      
      // Buscar la URL del backend
      print('[LoginController] Buscando URL del backend...');
      final backendUrl = await _authService.findBackendUrl();
      
      if (backendUrl == null) {
        throw 'No se pudo encontrar el backend. Verifica que esté ejecutándose y sea accesible desde la red.';
      }
      
      print('[LoginController] Backend encontrado en: $backendUrl');
      
      // Probar la conectividad
      print('[LoginController] Probando conectividad con el backend...');
      final isConnected = await _authService.testConnection();
      
      if (!isConnected) {
        throw 'No se pudo conectar con el servidor en $backendUrl';
      }
      
      print('[LoginController] Conectividad OK, procediendo con login...');
      
      final response = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Si llegamos aquí, el login fue exitoso y el token existe.
      print('[LoginController] Login exitoso. Respuesta del servicio recibida.');
      print('[LoginController] Token: ${response.token}');
      print('[LoginController] Usuario: ${response.user?.name}');
      
      Get.rawSnackbar(
        message: response.message ?? 'Inicio de sesión exitoso',
        backgroundColor: Colors.green,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
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
        duration: Duration(seconds: 5),
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

  Future<void> forgotPassword(String email) async {
    print('[LoginController] Iniciando proceso de recuperación de contraseña para: $email');
    try {
      await _authService.forgotPassword(email);
      print('[LoginController] Solicitud de recuperación de contraseña enviada exitosamente.');
    } catch (e) {
      print('[LoginController] Error en recuperación de contraseña: $e');
      rethrow;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}