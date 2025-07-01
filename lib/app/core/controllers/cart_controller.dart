import 'package:get/get.dart';
import '../../data/models/reserva_model.dart';
import '../../services/reserva_service.dart';

class CartController extends GetxController {
  var reservas = <ReservaModel>[].obs;
  final ReservaService _reservaService = Get.find<ReservaService>();

  @override
  void onInit() {
    super.onInit();
    sincronizarCarritoConBackend();
  }

  Future<void> sincronizarCarritoConBackend() async {
    try {
      final carritoResponse = await _reservaService.obtenerCarrito();
      reservas.assignAll(carritoResponse.items);
    } catch (e) {
      // Puedes manejar el error si lo deseas
      print('Error al sincronizar el carrito: $e');
    }
  }

  void agregarReserva(ReservaModel reserva) {
    reservas.add(reserva);
  }

  void eliminarReserva(ReservaModel reserva) {
    reservas.remove(reserva);
  }

  void editarReserva(ReservaModel reservaEditada) {
    final index = reservas.indexWhere((r) => r.id == reservaEditada.id);
    if (index != -1) {
      reservas[index] = reservaEditada;
    }
  }

  void limpiarCarrito() {
    reservas.clear();
  }

  void confirmarReservas() {
    // Aquí puedes implementar la lógica para enviar las reservas al backend o procesarlas
    // Por ahora solo limpia el carrito
    reservas.clear();
  }
} 