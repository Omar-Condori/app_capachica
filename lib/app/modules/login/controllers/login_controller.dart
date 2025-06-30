import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';

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
    try {
      final email = emailController.text.trim().toLowerCase();
      final response = await _authService.login(
        email,
        passwordController.text,
      );

      Get.rawSnackbar(
        message: response.message ?? 'Inicio de sesión exitoso',
        backgroundColor: Colors.green,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      );

      // Redirección inteligente tras login
      final box = GetStorage();
      final pendingRoute = box.read('pending_route') as String?;
      if (pendingRoute != null) {
        box.remove('pending_route');
        // Navegar a la ruta pendiente (detalle del servicio)
        Get.offAllNamed(pendingRoute);
        // Si la ruta pendiente es de detalle de servicio, mostrar el carrito tras un pequeño delay
        if (pendingRoute.startsWith('/services-capachica/detail/')) {
          Future.delayed(const Duration(milliseconds: 600), () {
            final cartController = Get.find<CartController>();
            Get.bottomSheet(
              CartBottomSheet(
                reservas: cartController.reservas,
                onEliminar: cartController.eliminarReserva,
                onEditar: cartController.editarReserva,
                onConfirmar: cartController.confirmarReservas,
              ),
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            );
          });
        }
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
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