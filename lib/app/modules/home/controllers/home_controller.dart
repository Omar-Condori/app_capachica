import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Variables observables
  final selectedTopNav = 'Resumen'.obs;
  final selectedBottomNav = 'Inicio'.obs;
  final showProfileDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController inicializado');
  }

  // Métodos para manejar navegación superior
  void onTopNavTap(String navItem) {
    if (navItem == 'Mi Perfil') {
      toggleProfileDropdown();
    } else {
      selectedTopNav.value = navItem;
      hideProfileDropdown(); // Ocultar dropdown si se selecciona otra opción
    }

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
      case 'Mi Perfil':
        _handleMiPerfil();
        break;
    }
  }

  // Métodos para manejar el dropdown del perfil
  void toggleProfileDropdown() {
    showProfileDropdown.value = !showProfileDropdown.value;
    if (showProfileDropdown.value) {
      selectedTopNav.value = 'Mi Perfil';
    }
  }

  void hideProfileDropdown() {
    showProfileDropdown.value = false;
    if (selectedTopNav.value == 'Mi Perfil') {
      selectedTopNav.value = 'Resumen'; // Volver a la opción anterior
    }
  }

  // Métodos para manejar las opciones del dropdown
  void onLoginTap() {
    hideProfileDropdown();
    print('Login presionado');
    Get.snackbar(
      'Iniciar Sesión',
      'Redirigiendo al login...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF2E7D32).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.login, color: Colors.white),
    );
    // Aquí navegarías a la pantalla de login
    // Get.toNamed('/login');
  }

  void onMyAccountTap() {
    hideProfileDropdown();
    print('Mi Cuenta presionado');
    Get.snackbar(
      'Mi Cuenta',
      'Accediendo a tu perfil...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF1976D2).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.account_circle, color: Colors.white),
    );
    // Get.toNamed('/profile');
  }

  void onMyReservationsTap() {
    hideProfileDropdown();
    print('Mis Reservas presionado');
    Get.snackbar(
      'Mis Reservas',
      'Cargando tus reservas...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFFF9100).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.bookmark, color: Colors.white),
    );
    // Get.toNamed('/reservations');
  }

  void onMyCartTap() {
    hideProfileDropdown();
    print('Mi Carrito presionado');
    Get.snackbar(
      'Mi Carrito',
      'Viendo productos guardados...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFE91E63).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.shopping_cart, color: Colors.white),
    );
    // Get.toNamed('/cart');
  }

  void onSettingsTap() {
    hideProfileDropdown();
    print('Configuración presionado');
    Get.snackbar(
      'Configuración',
      'Abriendo configuración...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF424242).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.settings, color: Colors.white),
    );
    // Get.toNamed('/settings');
  }

  void onLogoutTap() {
    hideProfileDropdown();
    print('Cerrar Sesión presionado');

    // Mostrar diálogo de confirmación
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFD32F2F)),
            SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Lógica para cerrar sesión
    Get.snackbar(
      'Sesión Cerrada',
      'Has cerrado sesión exitosamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFD32F2F).withOpacity(0.95),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );

    // Aquí podrías limpiar datos de usuario, tokens, etc.
    // Get.offAllNamed('/login'); // Redirigir al login
  }

  // Métodos para manejar botones de acción
  void onHotelsTap() {
    print('Hotels presionado');
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
    hideProfileDropdown(); // Ocultar dropdown si está abierto
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

  void _handleMiPerfil() {
    // Lógica para "Mi Perfil" - ya manejado por el dropdown
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