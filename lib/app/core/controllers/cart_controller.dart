import 'package:get/get.dart';
import '../../data/models/reserva_model.dart';
import '../../services/reserva_service.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  var reservas = <ReservaModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final ReservaService _reservaService = Get.find<ReservaService>();

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
      print('[CartController] Respuesta del backend (carrito):');
      print('Items: \\n' + carritoResponse.items.map((e) => e.toJson().toString()).join(',\\n'));
      print('Total: \\n' + carritoResponse.total.toString());
      print('Cantidad de items: \\n' + carritoResponse.cantidadItems.toString());
      reservas.assignAll(carritoResponse.items);
    } catch (e) {
      error.value = e.toString();
      print('Error al sincronizar el carrito: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> agregarReserva(ReservaModel reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Crear request para agregar al carrito
      final request = AgregarAlCarritoRequest(
        servicioId: reserva.servicioId,
        emprendedorId: reserva.emprendedorId,
        fechaInicio: reserva.fechaInicio,
        fechaFin: reserva.fechaFin,
        horaInicio: reserva.horaInicio,
        horaFin: reserva.horaFin,
        duracionMinutos: reserva.duracionMinutos,
        cantidad: reserva.cantidad,
        notasCliente: reserva.notasCliente,
      );
      
      await _reservaService.agregarAlCarrito(request);
      
      // Sincronizar con el backend
      await sincronizarCarritoConBackend();
      
      Get.snackbar(
        '¡Agregado!',
        'Servicio agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo agregar al carrito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> eliminarReserva(ReservaModel reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _reservaService.eliminarDelCarrito(reserva.servicioId);
      
      // Sincronizar con el backend
      await sincronizarCarritoConBackend();
      
      Get.snackbar(
        'Eliminado',
        'Servicio eliminado del carrito',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo eliminar del carrito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editarReserva(ReservaModel reservaEditada) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Primero eliminar la reserva actual
      await _reservaService.eliminarDelCarrito(reservaEditada.servicioId);
      
      // Luego agregar la reserva editada
      final request = AgregarAlCarritoRequest(
        servicioId: reservaEditada.servicioId,
        emprendedorId: reservaEditada.emprendedorId,
        fechaInicio: reservaEditada.fechaInicio,
        fechaFin: reservaEditada.fechaFin,
        horaInicio: reservaEditada.horaInicio,
        horaFin: reservaEditada.horaFin,
        duracionMinutos: reservaEditada.duracionMinutos,
        cantidad: reservaEditada.cantidad,
        notasCliente: reservaEditada.notasCliente,
      );
      
      await _reservaService.agregarAlCarrito(request);
      
      // Sincronizar con el backend
      await sincronizarCarritoConBackend();
      
      Get.snackbar(
        'Actualizado',
        'Reserva actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo actualizar la reserva: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> limpiarCarrito() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _reservaService.vaciarCarrito();
      reservas.clear();
      
      Get.snackbar(
        'Carrito vacío',
        'Todos los servicios han sido eliminados',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo vaciar el carrito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmarReservas({String? notas, String metodoPago = 'efectivo'}) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      if (reservas.isEmpty) {
        Get.snackbar(
          'Carrito vacío',
          'No hay reservas para confirmar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      
      final request = ConfirmarReservaRequest(
        notas: notas,
        metodoPago: metodoPago,
      );
      
      final response = await _reservaService.confirmarReserva(request);
      
      // Limpiar carrito después de confirmar
      reservas.clear();
      
      Get.snackbar(
        '¡Reserva confirmada!',
        'Tu reserva ha sido procesada exitosamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Navegar a mis reservas
      Get.offAllNamed('/mis-reservas');
      
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo confirmar la reserva: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Getters útiles
  double get total => reservas.fold(0.0, (sum, reserva) => sum + (reserva.precioTotal * reserva.cantidad));
  int get cantidadItems => reservas.fold(0, (sum, reserva) => sum + reserva.cantidad);
  bool get tieneItems => reservas.isNotEmpty;
} 