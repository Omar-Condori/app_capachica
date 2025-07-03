import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../data/models/reserva_model.dart';
import '../../../core/widgets/cart_card.dart';
import '../../../core/widgets/apple_style_widgets.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          Obx(() {
            if (cartController.tieneItems) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => _mostrarDialogoVaciarCarrito(context, cartController),
                tooltip: 'Vaciar carrito',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cartController.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar el carrito',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  cartController.error.value,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cartController.sincronizarCarritoConBackend(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (!cartController.tieneItems) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tu carrito está vacío',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega algunos servicios para comenzar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/services-capachica'),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Explorar Servicios'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Lista de reservas
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.reservas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reserva = cartController.reservas[index];
                  return CartCard(
                    reserva: reserva,
                    onEliminar: () => _mostrarDialogoEliminar(context, cartController, reserva),
                    onEditar: () => _mostrarDialogoEditar(context, cartController, reserva),
                  );
                },
              ),
            ),
            
            // Resumen y botón de confirmar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Resumen de precios
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        'S/ ${cartController.total.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de items:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${cartController.cantidadItems}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón de confirmar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _mostrarDialogoConfirmar(context, cartController),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Confirmar Reserva'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _mostrarDialogoVaciarCarrito(BuildContext context, CartController cartController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Vaciar Carrito'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los servicios del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cartController.limpiarCarrito();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Vaciar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, CartController cartController, ReservaModel reserva) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar Servicio'),
        content: Text('¿Estás seguro de que quieres eliminar "${reserva.servicio?.nombre ?? 'este servicio'}" del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cartController.eliminarReserva(reserva);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEditar(BuildContext context, CartController cartController, ReservaModel reserva) {
    // Implementar diálogo de edición
    Get.snackbar(
      'Función en desarrollo',
      'La edición de reservas estará disponible próximamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _mostrarDialogoConfirmar(BuildContext context, CartController cartController) {
    final notasController = TextEditingController();
    String metodoPago = 'efectivo';

    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Reserva'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total a pagar: S/ ${cartController.total.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: notasController,
              decoration: const InputDecoration(
                labelText: 'Notas adicionales (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: metodoPago,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
                DropdownMenuItem(value: 'transferencia', child: Text('Transferencia')),
              ],
              onChanged: (value) {
                if (value != null) metodoPago = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cartController.confirmarReservas(
                notas: notasController.text.isNotEmpty ? notasController.text : null,
                metodoPago: metodoPago,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
} 