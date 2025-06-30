import 'package:get/get.dart';
import '../../data/models/reserva_model.dart';

class CartController extends GetxController {
  var reservas = <ReservaModel>[].obs;

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