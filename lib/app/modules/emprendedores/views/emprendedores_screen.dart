import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/emprendedores_controller.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'emprendedor_card.dart';

class EmprendedoresScreen extends GetView<EmprendedoresController> {
  const EmprendedoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Emprendedores',
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
            onPressed: () => controller.refreshData(),
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
              if (controller.isLoading.value) {
                return _buildLoadingState();
              } else if (controller.hasError.value) {
                return _buildErrorState();
              } else if (!controller.hasEmprendedores) {
                return _buildEmptyState();
              } else {
                return _buildEmprendedoresList();
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
        color: AppColors.background,
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
          _buildSearchBar(),
          const SizedBox(height: 12),
          // Filtros por categoría
          _buildCategoriaFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          if (value.isEmpty) {
            controller.clearFilters();
          } else {
            controller.searchEmprendedores(value);
          }
        },
        decoration: InputDecoration(
          hintText: 'Buscar emprendedores...',
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => controller.clearFilters(),
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoriaFilter() {
    return Obx(() {
      if (controller.categorias.isEmpty) {
        return const SizedBox.shrink();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Botón "Todos"
            _buildCategoriaChip('', 'Todos'),
            const SizedBox(width: 8),
            // Chips de categorías
            ...controller.categorias.map((categoria) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoriaChip(categoria, categoria),
            )),
          ],
        ),
      );
    });
  }

  Widget _buildCategoriaChip(String categoria, String label) {
    return Obx(() {
      final isSelected = controller.selectedCategoria.value == categoria;
      
      return FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            controller.filterByCategoria(categoria);
          } else {
            controller.clearFilters();
          }
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        side: BorderSide(color: AppColors.primary),
        elevation: isSelected ? 4 : 1,
        pressElevation: 2,
      );
    });
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando emprendedores...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar emprendedores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => controller.refreshData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron emprendedores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros filtros o busca algo diferente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmprendedoresList() {
    return Obx(() {
      final emprendedores = controller.filteredEmprendedores;
      
      return Column(
        children: [
          // Contador de resultados
          if (controller.hasSearchResults || controller.hasCategoriaFilter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${emprendedores.length} emprendedor${emprendedores.length != 1 ? 'es' : ''} encontrado${emprendedores.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (controller.hasSearchResults || controller.hasCategoriaFilter)
                    TextButton.icon(
                      onPressed: () => controller.clearFilters(),
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Limpiar filtros'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          
          // Lista de emprendedores
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.refreshData(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: emprendedores.length,
                itemBuilder: (context, index) {
                  final emprendedor = emprendedores[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EmprendedorCard(
                      emprendedor: emprendedor,
                      onTap: () => controller.navigateToDetail(emprendedor),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
} 