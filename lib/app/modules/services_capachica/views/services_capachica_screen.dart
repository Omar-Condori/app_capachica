import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/services_capachica_controller.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/widgets/modern_service_card.dart';
import '../../../services/reserva_service.dart';
import 'service_detail_screen.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/widgets/cart_icon_button.dart';

class ServicesCapachicaScreen extends GetView<ServicesCapachicaController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reservaService = Get.find<ReservaService>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Servicios',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 2,
        backgroundColor: theme.appBarTheme.backgroundColor,
        shadowColor: theme.shadowColor.withOpacity(0.08),
        actions: [
          CartIconButton(),
          const ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          _buildSearchAndFilters(context),

          // Contenido principal
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState(context);
              } else if (controller.error.isNotEmpty) {
                return _buildErrorState(context);
              } else if (controller.serviciosFiltrados.isEmpty) {
                return _buildEmptyState(context);
              } else {
                return _buildServicesList(context);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            onChanged: controller.buscarServicios,
            decoration: InputDecoration(
              hintText: 'Buscar servicios...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.primaryColor),
              suffixIcon: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: Icon(Icons.clear_rounded, color: theme.primaryColor),
                    onPressed: () {
                      controller.limpiarFiltros();
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor ??
                  theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 12),

          // Filtros de categorías
          Obx(() {
            final categorias = controller.getCategoriasUnicas();
            if (categorias.isEmpty) {
              // Mostrar mensaje cuando no hay categorías disponibles
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No hay categorías disponibles',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar por categoría:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Botón "Todas"
                      _buildFilterChip(
                        context,
                        'Todas',
                        controller.categoriaSeleccionada.value == 0,
                        () => controller.limpiarFiltros(),
                      ),
                      const SizedBox(width: 8),
                      // Categorías
                      ...categorias.map((categoria) {
                        // Verificar si esta categoría está seleccionada
                        final isSelected = controller.categoriaSeleccionada.value > 0 &&
                            controller.servicios.any((servicio) =>
                                servicio.categorias.any((cat) => cat.nombre == categoria && cat.id == controller.categoriaSeleccionada.value));

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            context,
                            categoria,
                            isSelected,
                            () {
                              // Encontrar el ID de la categoría
                              final servicio = controller.servicios.firstWhere(
                                (s) => s.categorias.any((cat) => cat.nombre == categoria),
                                orElse: () => controller.servicios.first,
                              );
                              if (servicio.categorias.isNotEmpty) {
                                final categoriaId = servicio.categorias
                                    .firstWhere((cat) => cat.nombre == categoria)
                                    .id;
                                controller.filtrarPorCategoria(categoriaId);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor
              : theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando servicios...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar servicios',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.refreshServicios,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron servicios',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'Intenta con otros términos de búsqueda'
                  : 'No hay servicios disponibles en este momento',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.searchQuery.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.limpiarFiltros,
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Limpiar filtros'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshServicios();
      },
      child: Obx(() {
        if (controller.serviciosFiltrados.isEmpty) {
          return _buildEmptyState(context);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.serviciosFiltrados.length,
          itemBuilder: (context, index) {
            final servicio = controller.serviciosFiltrados[index];
            return ModernServiceCard(
              servicio: servicio,
              onTap: () {
                Get.to(() => ServiceDetailScreen(servicio: servicio));
              },
              onVerDetalle: () {
                Get.to(() => ServiceDetailScreen(servicio: servicio));
              },
            );
          },
        );
      }),
    );
  }
}

class CarritoButton extends StatelessWidget {
  final ReservaService reservaService = Get.find<ReservaService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reservaService.isAuthenticated) {
        return IconButton(
          onPressed: () => Get.toNamed('/carrito'),
          icon: Stack(
            children: [
              Icon(
                Icons.shopping_cart_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}