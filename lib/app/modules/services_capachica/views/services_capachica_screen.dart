import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/services_capachica_controller.dart';
import 'service_card.dart';
import 'service_detail_screen.dart';

class ServicesCapachicaScreen extends GetView<ServicesCapachicaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios Capachica'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.error.isNotEmpty) {
          return Center(child: Text('Error: ' + controller.error.value));
        } else if (controller.servicios.isEmpty) {
          return Center(child: Text('No hay servicios disponibles.'));
        } else {
          return ListView.builder(
            itemCount: controller.servicios.length,
            itemBuilder: (context, index) {
              final servicio = controller.servicios[index];
              return ServiceCard(
                servicio: servicio,
                onTap: () {
                  Get.to(() => ServiceDetailScreen(servicio: servicio));
                },
              );
            },
          );
        }
      }),
    );
  }
} 