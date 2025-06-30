import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con overlay mejorado
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_home.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Gradient overlay profesional
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A237E).withOpacity(0.3),
                  Color(0xFF3949AB).withOpacity(0.2),
                  Color(0xFF1976D2).withOpacity(0.3),
                  Colors.black.withOpacity(0.4),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Icono de carrito de compras en la esquina superior derecha
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 8, right: 16),
                  child: Obx(() {
                    final cartController = Get.find<CartController>();
                    final count = cartController.reservas.length;
                    return Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 32),
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
                  }),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bottom Content
                      _buildBottomContent(screenWidth, screenHeight),
                    ],
                  ),
                ),

                // Bottom Navigation (ahora con las opciones superiores)
                _buildBottomNavigation(screenWidth),
              ],
            ),
          ),

          // Overlay para cerrar dropdown
          Obx(() => controller.showProfileDropdown.value
              ? GestureDetector(
                  onTap: () => controller.hideProfileDropdown(),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : SizedBox.shrink()),
                
          // Profile Dropdown Menu MEJORADO
          Obx(() => controller.showProfileDropdown.value
              ? _buildProfileDropdownBottom(screenWidth, screenHeight)
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildBottomContent(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal con animación
          Text(
            'Turismo\nCapachica',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth < 400 ? 36 : 48,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.6),
                ),
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Subtítulo
          Text(
            'Descubre la magia del lago Titicaca',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: screenWidth < 400 ? 16 : 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.04),

          // Botones de acción mejorados
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Ver Planes',
                  Icons.map,
                  false,
                      () => controller.onHotelsTap(),
                  screenWidth,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  'Servicios',
                  Icons.explore_outlined,
                  true,
                      () => controller.onToursTap(),
                  screenWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, bool isFilled, VoidCallback onTap, double screenWidth) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: screenWidth < 400 ? 16 : 20
        ),
        decoration: BoxDecoration(
          color: isFilled
              ? Color(0xFFFF9100).withOpacity(0.9)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isFilled
                ? Color(0xFFFF9100)
                : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: screenWidth < 400 ? 18 : 20,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth < 400 ? 14 : 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(double screenWidth) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(
                Icons.home_outlined,
                Icons.home,
                'Inicio',
                controller.selectedTopNav.value == 'Inicio',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.store_outlined,
                Icons.store,
                'Emprendimientos',
                controller.selectedTopNav.value == 'Emprendimientos',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.event_outlined,
                Icons.event,
                'Eventos',
                controller.selectedTopNav.value == 'Eventos',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.person_outline,
                Icons.person,
                'Mi Perfil',
                controller.selectedTopNav.value == 'Mi Perfil',
                screenWidth
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData outlinedIcon, IconData filledIcon, String label, bool isSelected, double screenWidth) {
    return GestureDetector(
      onTap: () {
        if (label == 'Mi Perfil') {
          controller.toggleProfileDropdown();
        } else {
          controller.onTopNavTap(label);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: label == 'Inicio' && controller.isLoadingResumen.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      isSelected ? filledIcon : outlinedIcon,
                      key: ValueKey(isSelected),
                      color: isSelected ? Colors.white : Colors.white60,
                      size: isSelected ? 26 : 24,
                    ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: screenWidth < 400 ? 10 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // MENÚ DE PERFIL COMPACTO Y ELEGANTE
  Widget _buildProfileDropdownBottom(double screenWidth, double screenHeight) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 110, // Justo encima de la navegación inferior
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, -8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF8F9FA),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header compacto
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1976D2).withOpacity(0.05),
                        Color(0xFF3949AB).withOpacity(0.02),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar compacto
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1976D2),
                              Color(0xFF3949AB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF1976D2).withOpacity(0.25),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.authService.isLoggedIn ? 'Mi Cuenta' : '¡Hola!',
                              style: TextStyle(
                                color: Color(0xFF1A237E),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              controller.authService.isLoggedIn ? 'Gestiona tu perfil' : 'Inicia sesión para continuar',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón de cierre compacto
                      GestureDetector(
                        onTap: () => controller.hideProfileDropdown(),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu items compactos
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Obx(
                    () => Column(
                      children: controller.authService.isLoggedIn
                          ? [
                              _buildCompactDropdownItem(
                                icon: Icons.account_circle_rounded,
                                title: 'Mi Cuenta',
                                onTap: () => controller.onMyAccountTap(),
                                color: Color(0xFF1976D2),
                              ),
                              _buildCompactDropdownItem(
                                icon: Icons.bookmark_rounded,
                                title: 'Mis Reservas',
                                onTap: () => controller.onMyReservationsTap(),
                                color: Color(0xFFFF9100),
                              ),
                              _buildCompactDropdownItem(
                                icon: Icons.shopping_cart_rounded,
                                title: 'Mi Carrito',
                                onTap: () => controller.onMyCartTap(),
                                color: Color(0xFFE91E63),
                              ),
                              _buildCompactDropdownItem(
                                icon: Icons.settings_rounded,
                                title: 'Configuración',
                                onTap: () => controller.onSettingsTap(),
                                color: Color(0xFF424242),
                              ),
                              // Separador sutil
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              _buildCompactDropdownItem(
                                icon: Icons.logout_rounded,
                                title: 'Cerrar Sesión',
                                onTap: () => controller.onLogoutTap(),
                                color: Color(0xFFD32F2F),
                                isLogout: true,
                              ),
                            ]
                          : [
                              // Botón de Iniciar Sesión compacto
                              _buildCompactLoginButton(),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Item compacto del dropdown
  Widget _buildCompactDropdownItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Icono compacto
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isLogout ? Color(0xFFD32F2F) : Color(0xFF1A237E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Flecha compacta
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Botón compacto para iniciar sesión
  Widget _buildCompactLoginButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onLoginTap(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2E7D32),
                  Color(0xFF43A047),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2E7D32).withOpacity(0.25),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}