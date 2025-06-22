import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

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
                // Top Navigation Tabs
                _buildTopNavigation(screenWidth),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bottom Content
                      _buildBottomContent(screenWidth, screenHeight),
                    ],
                  ),
                ),

                // Bottom Navigation
                _buildBottomNavigation(screenWidth),
              ],
            ),
          ),

          // Overlay para cerrar dropdown (MOVIDO ANTES DEL MENÚ)
          // Esta capa transparente ahora está detrás del menú, permitiendo
          // que los botones del menú reciban los toques.
          Obx(() => controller.showProfileDropdown.value
              ? GestureDetector(
                  onTap: () => controller.hideProfileDropdown(),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : SizedBox.shrink()),
                
          // Profile Dropdown Menu (AHORA ENCIMA DEL OVERLAY)
          Obx(() => controller.showProfileDropdown.value
              ? _buildProfileDropdown(screenWidth, screenHeight)
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildTopNavigation(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, // Reducido para más espacio
          vertical: 20
      ),
      child: Obx(
            () => Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Reducido
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopNavItem('Resumen', controller.selectedTopNav.value == 'Resumen', screenWidth),
              _buildTopNavItem('Negocios', controller.selectedTopNav.value == 'Negocios', screenWidth),
              _buildTopNavItem('Servicios', controller.selectedTopNav.value == 'Servicios', screenWidth),
              _buildTopNavItem('Mi Perfil', controller.selectedTopNav.value == 'Mi Perfil', screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavItem(String title, bool isSelected, double screenWidth) {
    // Calculamos el tamaño de fuente dinámicamente
    double fontSize = screenWidth < 350 ? 10 : (screenWidth < 400 ? 11 : 12);
    double horizontalPadding = screenWidth < 350 ? 4 : (screenWidth < 400 ? 6 : 8);

    return Flexible( // Cambiado a Flexible para evitar overflow
      child: GestureDetector(
        onTap: () => controller.onTopNavTap(title),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: horizontalPadding
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible( // Agregado Flexible al texto
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.3, // Reducido
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Previene overflow
                ),
              ),
              if (title == 'Mi Perfil') ...[
                SizedBox(width: 2), // Reducido
                AnimatedRotation(
                  turns: controller.showProfileDropdown.value ? 0.5 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 14, // Reducido
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDropdown(double screenWidth, double screenHeight) {
    return Positioned(
      top: 90, // Ajusta según la altura de tu top navigation
      right: screenWidth * 0.03, // Ajustado para coincidir con el margen
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: screenWidth * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 40,
              offset: Offset(0, 16),
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header del dropdown
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1976D2).withOpacity(0.1),
                    Color(0xFF3949AB).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF3949AB)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1976D2).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mi Perfil',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Gestiona tu cuenta',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildDropdownItem(
                    icon: Icons.login_outlined,
                    title: 'Iniciar Sesión',
                    subtitle: 'Accede a tu cuenta',
                    onTap: () => controller.onLoginTap(),
                    color: Color(0xFF2E7D32),
                  ),
                  _buildDropdownItem(
                    icon: Icons.account_circle_outlined,
                    title: 'Mi Cuenta',
                    subtitle: 'Información personal',
                    onTap: () => controller.onMyAccountTap(),
                    color: Color(0xFF1976D2),
                  ),
                  _buildDropdownItem(
                    icon: Icons.bookmark_border_outlined,
                    title: 'Mis Reservas',
                    subtitle: 'Historial de reservas',
                    onTap: () => controller.onMyReservationsTap(),
                    color: Color(0xFFFF9100),
                  ),
                  _buildDropdownItem(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Mi Carrito',
                    subtitle: 'Productos guardados',
                    onTap: () => controller.onMyCartTap(),
                    color: Color(0xFFE91E63),
                  ),
                  _buildDropdownItem(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    subtitle: 'Preferencias de la app',
                    onTap: () => controller.onSettingsTap(),
                    color: Color(0xFF424242),
                  ),

                  // Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  _buildDropdownItem(
                    icon: Icons.logout_outlined,
                    title: 'Cerrar Sesión',
                    subtitle: 'Salir de la aplicación',
                    onTap: () => controller.onLogoutTap(),
                    color: Color(0xFFD32F2F),
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isLogout ? Color(0xFFD32F2F) : Color(0xFF1A237E),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 14,
              ),
            ],
          ),
        ),
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
                  'Hospedajes',
                  Icons.hotel_outlined,
                  false,
                      () => controller.onHotelsTap(),
                  screenWidth,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  'Tours',
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
                controller.selectedBottomNav.value == 'Inicio',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.business_outlined,
                Icons.business,
                'Emprendimientos',
                controller.selectedBottomNav.value == 'Emprendimientos',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.miscellaneous_services_outlined,
                Icons.miscellaneous_services,
                'Servicios',
                controller.selectedBottomNav.value == 'Servicios',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.event_outlined,
                Icons.event,
                'Eventos',
                controller.selectedBottomNav.value == 'Eventos',
                screenWidth
            ),
            _buildBottomNavItem(
                Icons.assignment_outlined,
                Icons.assignment,
                'Planes',
                controller.selectedBottomNav.value == 'Planes',
                screenWidth
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData outlinedIcon, IconData filledIcon, String label, bool isSelected, double screenWidth) {
    return GestureDetector(
      onTap: () => controller.onBottomNavTap(label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(
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
}