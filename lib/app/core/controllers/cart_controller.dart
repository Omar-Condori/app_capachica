import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/reserva_service.dart';

class CartController extends GetxController {
  final ReservaService _reservaService = Get.find<ReservaService>();
  
  final items = <Map<String, dynamic>>[].obs;
  final total = 0.0.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    sincronizarCarritoConBackend();
  }

  Future<void> sincronizarCarritoConBackend() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final carritoResponse = await _reservaService.obtenerCarrito();
      items.assignAll(carritoResponse['items'] ?? []);
      total.value = carritoResponse['total'] ?? 0.0;
    } catch (e) {
      error.value = e.toString();
      print('[CartController] Error sincronizando carrito: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> agregarAlCarrito(Map<String, dynamic> request) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _reservaService.agregarAlCarrito(request);
      
      if (response['success'] == true) {
        // Sincronizar con el backend
        await sincronizarCarritoConBackend();
        
        Get.snackbar(
          '¡Agregado!',
          'Servicio agregado al carrito exitosamente',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        throw response['message'] ?? 'Error agregando al carrito';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo agregar al carrito: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> eliminarDelCarrito(Map<String, dynamic> reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _reservaService.eliminarDelCarrito(reserva);
      
      if (response['success'] == true) {
        // Sincronizar con el backend
        await sincronizarCarritoConBackend();
        
        Get.snackbar(
          'Eliminado',
          'Servicio eliminado del carrito',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
        );
      } else {
        throw response['message'] ?? 'Error eliminando del carrito';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo eliminar del carrito: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editarReserva(Map<String, dynamic> reservaEditada) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Primero eliminar la reserva actual
      await _reservaService.eliminarDelCarrito(reservaEditada);
      
      // Luego agregar la reserva editada
      await _reservaService.agregarAlCarrito(reservaEditada);
      
      // Sincronizar con el backend
      await sincronizarCarritoConBackend();
      
      Get.snackbar(
        'Actualizado',
        'Plan actualizado correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.edit_outlined, color: Colors.white),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo actualizar el plan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> vaciarCarrito() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _reservaService.vaciarCarrito();
      
      if (response['success'] == true) {
        // Sincronizar con el backend
        await sincronizarCarritoConBackend();
        
        Get.snackbar(
          'Carrito vaciado',
          'Se han eliminado todos los servicios del carrito',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.remove_shopping_cart_outlined, color: Colors.white),
        );
      } else {
        throw response['message'] ?? 'Error vaciando carrito';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo vaciar el carrito: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmarReserva(Map<String, dynamic> request) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _reservaService.confirmarReserva(request);
      
      if (response['success'] == true) {
        // Sincronizar con el backend
        await sincronizarCarritoConBackend();
        
        Get.snackbar(
          '¡Reserva confirmada!',
          'Tu reserva ha sido confirmada exitosamente',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
        
        // Navegar a mis reservas
        Get.offAllNamed('/mis-reservas');
      } else {
        throw response['message'] ?? 'Error confirmando reserva';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo confirmar la reserva: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> agregarReserva(Map<String, dynamic> reserva) async {
    await agregarAlCarrito(reserva);
  }

  void mostrarDialogoConfirmacion() {
    Get.snackbar(
      '¡Agregado!',
      'El item ha sido agregado al carrito',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
} 