import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Variables observables
  final selectedTopNav = 'Resumen'.obs;
  final selectedBottomNav = 'Inicio'.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController inicializado');
  }

  // Métodos para manejar navegación superior
  void onTopNavTap(String navItem) {
    selectedTopNav.value = navItem;
    print('Top Nav seleccionado: $navItem');

    // Aquí puedes agregar lógica específica para cada tab
    switch (navItem) {
      case 'Resumen':
        _handleResumen();
        break;
      case 'Negocios':
        _handleNegocios();
        break;
      case 'Servicios':
        _handleServicios();
        break;
      case 'Planes':
        _handlePlanes();
        break;
    }
  }

  // Métodos para manejar botones de acción
  void onHotelsTap() {
    print('Hotels presionado');
    // Aquí navegarías a la pantalla de hoteles
    Get.snackbar(
      'Hospedajes',
      'Explorando opciones de hospedaje...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white.withOpacity(0.95),
      colorText: Colors.black87,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  void onToursTap() {
    print('Tours presionado');
    // Aquí navegarías a la pantalla de tours
    Get.snackbar(
      'Tours',
      'Descubre nuestros tours únicos...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF2E7D32).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  // Métodos para manejar navegación inferior
  void onBottomNavTap(String navItem) {
    selectedBottomNav.value = navItem;
    print('Bottom Nav seleccionado: $navItem');

    switch (navItem) {
      case 'Inicio':
      // Ya estamos en home
        break;
      case 'Emprendimientos':
        _handleEmprendimientos();
        break;
      case 'Servicios':
        _handleServiciosBottom();
        break;
      case 'Eventos':
        _handleEventos();
        break;
      case 'Planes':
        _handlePlanesBottom();
        break;
    }
  }

  // Métodos privados para manejar cada acción
  void _handleResumen() {
    // Lógica para "Resumen"
  }

  void _handleNegocios() {
    // Lógica para "Negocios"
  }

  void _handleServicios() {
    // Lógica para "Servicios"
  }

  void _handlePlanes() {
    // Lógica para "Planes"
  }

  void _handleEmprendimientos() {
    Get.snackbar(
      'Emprendimientos',
      'Conoce los emprendimientos locales',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF1565C0).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  void _handleServiciosBottom() {
    Get.snackbar(
      'Servicios',
      'Servicios turísticos disponibles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF7B1FA2).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  void _handleEventos() {
    Get.snackbar(
      'Eventos',
      'Próximos eventos en Capachica',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFE65100).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  void _handlePlanesBottom() {
    Get.snackbar(
      'Planes',
      'Planifica tu visita perfecta',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF424242).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }
}