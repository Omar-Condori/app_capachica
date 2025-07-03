import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/widgets/cart_icon_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF101A30) : Color(0xFFF5F7FA),
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
                  Colors.black.withOpacity(isDark ? 0.5 : 0.2),
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
                  Color(0xFF1A237E).withOpacity(isDark ? 0.5 : 0.3),
                  Color(0xFF3949AB).withOpacity(isDark ? 0.4 : 0.2),
                  Color(0xFF1976D2).withOpacity(isDark ? 0.5 : 0.3),
                  Colors.black.withOpacity(isDark ? 0.6 : 0.4),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Barra superior moderna
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 18),
                    child: CartIconButton(iconColor: Colors.white, iconSize: 22),
                  ),
                ),
                // Expanded con cards modernas para sliders y municipalidades
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card de sliders (Tus viajes)
                        Obx(() {
                          final resumen = controller.resumenData.value;
                          if (resumen == null || resumen.sliders.isEmpty) return SizedBox.shrink();
                          return _buildModernCardSection(
                            context,
                            title: 'Tus viajes',
                            child: SizedBox(
                              height: 180,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: resumen.sliders.length,
                                separatorBuilder: (_, __) => SizedBox(width: 16),
                                itemBuilder: (ctx, i) {
                                  final slider = resumen.sliders[i];
                                  return _buildSliderCard(slider, isDark);
                                },
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 18),
                        // Card de municipalidades (Tus búsquedas recientes)
                        Obx(() {
                          final resumen = controller.resumenData.value;
                          if (resumen == null || resumen.municipalidades.isEmpty) return SizedBox.shrink();
                          return _buildModernCardSection(
                            context,
                            title: 'Tus búsquedas recientes',
                            child: SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: resumen.municipalidades.length,
                                separatorBuilder: (_, __) => SizedBox(width: 16),
                                itemBuilder: (ctx, i) {
                                  final muni = resumen.municipalidades[i];
                                  return _buildMunicipalidadCard(muni, isDark);
                                },
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 18),
                        // El contenido original (título, subtítulo, botones)
                        _buildBottomContentCentered(screenWidth, screenHeight),
                      ],
                    ),
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

  Widget _buildBottomContentCentered(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: screenHeight * 0.16, left: screenWidth * 0.08, right: screenWidth * 0.08, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título principal centrado
          Text(
            'Turismo\nCapachica',
            textAlign: TextAlign.center,
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
          // Subtítulo centrado
          Text(
            'Descubre la magia del lago Titicaca',
            textAlign: TextAlign.center,
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
          SizedBox(height: screenHeight * 0.06),
          // Botones de acción centrados y más abajo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
    final selectedColor = Color(0xFFFF9100);
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
                        valueColor: AlwaysStoppedAnimation<Color>(selectedColor),
                      ),
                    )
                  : Icon(
                      isSelected ? filledIcon : outlinedIcon,
                      key: ValueKey(isSelected),
                      color: isSelected ? selectedColor : Colors.white,
                      size: isSelected ? 26 : 24,
                    ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : Colors.white,
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

  // Agregar widgets auxiliares para cards modernas
  Widget _buildModernCardSection(BuildContext context, {required String title, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF222B45),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF22325A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.18) : Colors.grey.withOpacity(0.10),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard(slider, bool isDark) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF182447) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.18) : Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        image: slider.imageUrl != null && slider.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(slider.imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.18),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withOpacity(0.45) : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slider.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF222B45),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (slider.description != null && slider.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        slider.description,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMunicipalidadCard(muni, bool isDark) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF182447) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.18) : Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              muni.nombre,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF222B45),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (muni.descripcion != null && muni.descripcion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  muni.descripcion,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}