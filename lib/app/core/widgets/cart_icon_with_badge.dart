import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'cart_bottom_sheet.dart';

class CartIconWithBadge extends StatelessWidget {
  final Color? iconColor;
  final double? iconSize;

  const CartIconWithBadge({
    Key? key,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDark = Get.isDarkMode;

    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: iconColor,
            size: iconSize,
          ),
          onPressed: () {
            Get.bottomSheet(
              CartBottomSheet(
                items: cartController.items,
                onEliminar: cartController.eliminarDelCarrito,
                onEditar: cartController.editarReserva,
                onConfirmar: ({String? notas, String metodoPago = 'efectivo'}) {
                  final request = {
                    'notas': notas,
                    'metodoPago': metodoPago,
                  };
                  cartController.confirmarReserva(request);
                },
              ),
              isScrollControlled: true,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            );
          },
        ),
        Obx(() {
          if (cartController.items.isEmpty) return const SizedBox.shrink();
          return Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${cartController.items.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ],
    );
  }
} 