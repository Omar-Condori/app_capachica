import 'package:get/get.dart';
import '../../../services/reserva_service.dart';
import '../../../data/models/reserva_model.dart';
import 'package:flutter/material.dart';

class MisReservasController extends GetxController {
  final ReservaService _reservaService = Get.find<ReservaService>();
  
  final reservas = <ReservaModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarMisReservas();
  }

  Future<void> cargarMisReservas() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final reservasData = await _reservaService.obtenerMisReservas();
      reservas.assignAll(reservasData);
    } catch (e) {
      error.value = e.toString();
      print('[MisReservasController] Error cargando reservas: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filtrar reservas por estado
  List<ReservaModel> get reservasPendientes => 
      reservas.where((r) => r.estado == 'pendiente').toList();
  
  List<ReservaModel> get reservasConfirmadas => 
      reservas.where((r) => r.estado == 'confirmada').toList();
  
  List<ReservaModel> get reservasCompletadas => 
      reservas.where((r) => r.estado == 'completada').toList();
  
  List<ReservaModel> get reservasCanceladas => 
      reservas.where((r) => r.estado == 'cancelada').toList();

  // Obtener el color del estado
  Color getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmada':
        return Colors.blue;
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Obtener el texto del estado
  String getTextoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmada':
        return 'Confirmada';
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return estado;
    }
  }

  // Cancelar reserva
  Future<void> cancelarReserva(ReservaModel reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _reservaService.actualizarEstadoReserva(reserva.id, 'cancelada');
      
      // Recargar las reservas
      await cargarMisReservas();
      
      Get.snackbar(
        'Reserva cancelada',
        'La reserva ha sido cancelada exitosamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo cancelar la reserva: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Marcar como completada
  Future<void> marcarComoCompletada(ReservaModel reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _reservaService.actualizarEstadoReserva(reserva.id, 'completada');
      
      // Recargar las reservas
      await cargarMisReservas();
      
      Get.snackbar(
        'Reserva completada',
        'La reserva ha sido marcada como completada',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo marcar como completada: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar reserva
  Future<void> eliminarReserva(ReservaModel reserva) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _reservaService.eliminarReserva(reserva.id);
      
      // Recargar las reservas
      await cargarMisReservas();
      
      Get.snackbar(
        'Reserva eliminada',
        'La reserva ha sido eliminada exitosamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo eliminar la reserva: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Obtener reservas por emprendedor
  Future<List<ReservaModel>> obtenerReservasEmprendedor(int emprendedorId) async {
    try {
      return await _reservaService.obtenerReservasEmprendedor(emprendedorId);
    } catch (e) {
      print('[MisReservasController] Error obteniendo reservas del emprendedor: $e');
      rethrow;
    }
  }

  // Obtener reservas por servicio
  Future<List<ReservaModel>> obtenerReservasServicio(int servicioId) async {
    try {
      return await _reservaService.obtenerReservasServicio(servicioId);
    } catch (e) {
      print('[MisReservasController] Error obteniendo reservas del servicio: $e');
      rethrow;
    }
  }

  // Obtener reserva por ID
  Future<ReservaModel?> obtenerReservaPorId(int id) async {
    try {
      return await _reservaService.obtenerReservaPorId(id);
    } catch (e) {
      print('[MisReservasController] Error obteniendo reserva por ID: $e');
      return null;
    }
  }

  // Calcular estadísticas
  int get totalReservas => reservas.length;
  int get reservasPendientesCount => reservasPendientes.length;
  int get reservasConfirmadasCount => reservasConfirmadas.length;
  int get reservasCompletadasCount => reservasCompletadas.length;
  int get reservasCanceladasCount => reservasCanceladas.length;

  double get totalGastado => reservas
      .where((r) => r.estado == 'completada')
      .fold(0.0, (sum, r) => sum + r.precioTotal);

  // Formatear fecha
  String formatearFecha(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return fecha;
    }
  }

  // Formatear precio
  String formatearPrecio(double precio) {
    return 'S/ ${precio.toStringAsFixed(2)}';
  }
} 