import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../controllers/emprendedores_controller.dart';
import 'emprendedor_card.dart';

class EmprendedoresScreen extends GetView<EmprendedoresController> {
  const EmprendedoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprendedores'),
        actions: [
          // Carrito con contador
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Get.toNamed('/carrito'),
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
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.error.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.cargarEmprendedores(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.emprendedores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 64,
                  color: isDark ? Colors.white54 : Colors.black38,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay emprendedores disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Intenta recargar la página',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.cargarEmprendedores(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recargar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.cargarEmprendedores(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.emprendedores.length,
            itemBuilder: (context, index) {
              final emprendedor = controller.emprendedores[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EmprendedorCard(
                  emprendedor: emprendedor,
                  onTap: () => Get.toNamed(
                    '/emprendedor-detail',
                    arguments: emprendedor,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
} 