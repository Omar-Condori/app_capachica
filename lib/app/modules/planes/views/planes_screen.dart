import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/planes_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import 'plan_card.dart';

class PlanesScreen extends GetView<PlanesController> {
  const PlanesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Planes Turísticos',
          style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () => controller.refreshPlanes(),
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          _buildSearchAndFilters(),
          
          // Contenido principal
          Expanded(
            child: Obx(() {
              if (controller.isCurrentlyLoading) {
                return _buildLoadingState();
              } else if (controller.hasError) {
                return _buildErrorState();
              } else if (!controller.hasPlanes) {
                return _buildEmptyState();
              } else {
                return _buildPlanesList();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            onChanged: controller.filterByQuery,
            decoration: InputDecoration(
              hintText: 'Buscar planes...',
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              suffixIcon: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: Icon(Icons.clear, color: AppColors.primary),
                    onPressed: () => controller.filterByQuery(''),
                  );
                }
                return const SizedBox.shrink();
              }),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Filtros de categoría
          Row(
            children: [
              Text(
                'Categoría:',
                style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categorias.map((categoria) {
                      return Obx(() {
                        final isSelected = controller.selectedCategoria.value == categoria;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(categoria),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                controller.filterByCategoria(categoria);
                              } else {
                                controller.filterByCategoria('');
                              }
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : Colors.grey[300]!,
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          
          // Botón para limpiar filtros
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty || 
                (controller.selectedCategoria.value.isNotEmpty && controller.selectedCategoria.value != 'Todas')) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton.icon(
                  onPressed: controller.clearFilters,
                  icon: Icon(Icons.clear_all, size: 16, color: AppColors.primary),
                  label: Text(
                    'Limpiar filtros',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando planes...',
            style: AppTheme.lightTextTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar planes',
              style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              controller.errorMessage.value,
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.refreshPlanes(),
              icon: Icon(Icons.refresh),
              label: Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron planes',
              style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta ajustar tus filtros de búsqueda',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.clearFilters(),
              icon: Icon(Icons.clear_all),
              label: Text('Limpiar filtros'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanesList() {
    return RefreshIndicator(
      onRefresh: controller.refreshPlanes,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.planesFiltrados.length,
        itemBuilder: (context, index) {
          final plan = controller.planesFiltrados[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlanCard(
              plan: plan,
              onTap: () => controller.navigateToPlanDetalle(plan),
            ),
          );
        },
      ),
    );
  }
} 