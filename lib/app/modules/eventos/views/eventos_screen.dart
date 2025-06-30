import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eventos_controller.dart';
import 'evento_card.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';

class EventosScreen extends GetView<EventosController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Eventos',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final cartController = Get.find<CartController>();
            final count = cartController.reservas.length;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
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
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: theme.iconTheme.color,
            ),
            onPressed: () => controller.refreshEventos(),
          ),
        ],
      ),
      body: Column(
        children: [
          // TabBar personalizado
          _buildTabBar(theme),
          
          // Contenido de las pestañas
          Expanded(
            child: Obx(() {
              switch (controller.selectedTab.value) {
                case 0:
                  return _buildTodosTab(theme);
                case 1:
                  return _buildProximosTab(theme);
                case 2:
                  return _buildActivosTab(theme);
                default:
                  return _buildTodosTab(theme);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
        children: [
          _buildTabItem(theme, 'Todos', 0, Icons.event_available_rounded),
          _buildTabItem(theme, 'Próximos', 1, Icons.upcoming_rounded),
          _buildTabItem(theme, 'Activos', 2, Icons.play_circle_outline_rounded),
        ],
      )),
    );
  }

  Widget _buildTabItem(ThemeData theme, String title, int index, IconData icon) {
    final isSelected = controller.selectedTab.value == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChanged(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? theme.primaryColor
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? theme.primaryColor
                      : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodosTab(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState(theme);
      }
      
      if (controller.error.value != null) {
        return _buildErrorState(theme, controller.error.value!, () => controller.loadEventos());
      }
      
      if (controller.eventos.isEmpty) {
        return _buildEmptyState(theme, 'No hay eventos disponibles');
      }
      
      return RefreshIndicator(
        onRefresh: controller.refreshEventos,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.eventos.length,
          itemBuilder: (context, index) {
            final evento = controller.eventos[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: EventoCard(
                evento: evento,
                onTap: () => controller.onEventoTap(evento),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProximosTab(ThemeData theme) {
    return Obx(() {
      if (controller.isLoadingProximos.value) {
        return _buildLoadingState(theme);
      }
      
      if (controller.errorProximos.value != null) {
        return _buildErrorState(theme, controller.errorProximos.value!, () => controller.loadEventosProximos());
      }
      
      if (controller.eventosProximos.isEmpty) {
        return _buildEmptyState(theme, 'No hay próximos eventos');
      }
      
      return RefreshIndicator(
        onRefresh: controller.refreshProximos,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.eventosProximos.length,
          itemBuilder: (context, index) {
            final evento = controller.eventosProximos[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: EventoCard(
                evento: evento,
                onTap: () => controller.onEventoTap(evento),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildActivosTab(ThemeData theme) {
    return Obx(() {
      if (controller.isLoadingActivos.value) {
        return _buildLoadingState(theme);
      }
      
      if (controller.errorActivos.value != null) {
        return _buildErrorState(theme, controller.errorActivos.value!, () => controller.loadEventosActivos());
      }
      
      if (controller.eventosActivos.isEmpty) {
        return _buildEmptyState(theme, 'No hay eventos activos');
      }
      
      return RefreshIndicator(
        onRefresh: controller.refreshActivos,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.eventosActivos.length,
          itemBuilder: (context, index) {
            final evento = controller.eventosActivos[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: EventoCard(
                evento: evento,
                onTap: () => controller.onEventoTap(evento),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando eventos...',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error.withOpacity(0.6),
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar eventos',
              style: TextStyle(
                color: theme.textTheme.titleMedium?.color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded),
              label: Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Pronto tendremos nuevos eventos para ti',
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 