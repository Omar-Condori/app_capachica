import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/reserva_model.dart';
import 'cart_card.dart';

class CartBottomSheet extends StatelessWidget {
  final List<ReservaModel> reservas;
  final void Function(ReservaModel) onEliminar;
  final void Function(ReservaModel) onEditar;
  final void Function() onConfirmar;

  const CartBottomSheet({
    super.key,
    required this.reservas,
    required this.onEliminar,
    required this.onEditar,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mi Carrito', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (reservas.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('No hay reservas en el carrito.', style: theme.textTheme.bodyLarge),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: reservas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reserva = reservas[index];
                  return CartCard(
                    reserva: reserva,
                    onEliminar: () => onEliminar(reserva),
                    onEditar: () => onEditar(reserva),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          if (reservas.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirmar Servicio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: onConfirmar,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
} 