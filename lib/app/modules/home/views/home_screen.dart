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
        ],
      ),
    );
  }

  Widget _buildTopNavigation(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 20
      ),
      child: Obx(
            () => Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              _buildTopNavItem('Planes', controller.selectedTopNav.value == 'Planes', screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavItem(String title, bool isSelected, double screenWidth) {
    return GestureDetector(
      onTap: () => controller.onTopNavTap(title),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: screenWidth < 400 ? 8 : 12
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
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: screenWidth < 400 ? 12 : 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.5,
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
              ? Color(0xFF2E7D32).withOpacity(0.9)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isFilled
                ? Color(0xFF2E7D32)
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