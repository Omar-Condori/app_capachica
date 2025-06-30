import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'cart_bottom_sheet.dart';

class CartIconButton extends StatelessWidget {
  final Color? iconColor;
  final double iconSize;
  const CartIconButton({Key? key, this.iconColor, this.iconSize = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Obx(() {
      final count = cartController.reservas.length;
      return Stack(
        children: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: iconColor ?? Theme.of(context).iconTheme.color, size: iconSize),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => CartBottomSheet(
                  reservas: cartController.reservas,
                  onEliminar: cartController.eliminarReserva,
                  onEditar: cartController.editarReserva,
                  onConfirmar: cartController.confirmarReservas,
                ),
              );
            },
          ),
          if (count > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
} 