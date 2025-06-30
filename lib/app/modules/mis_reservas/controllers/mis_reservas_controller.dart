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