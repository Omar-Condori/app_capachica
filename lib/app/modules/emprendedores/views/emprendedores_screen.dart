import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/emprendedores_controller.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'emprendedor_card.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';

class EmprendedoresScreen extends GetView<EmprendedoresController> {
  const EmprendedoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF101A30) : Color(0xFFF5F7FA),
      body: Column(
        children: [
          // HEADER MODERNO
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 8, right: 8, top: MediaQuery.of(context).padding.top + 10, bottom: 18),
            decoration: BoxDecoration(
              color: Color(0xFFFF9100),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                SizedBox(width: 4),
                Text(
                  'Capachica Travel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Spacer(),
                Obx(() {
                  final cartController = Get.find<CartController>();
                  final count = cartController.reservas.length;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, size: 22),
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
                  icon: Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () => controller.refreshData(),
                ),
                ThemeToggleButton(),
              ],
            ),
          ),
          // Buscador y filtros modernos
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              children: [
                // Buscador
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(30),
                  color: isDark ? Color(0xFF22325A) : Colors.white,
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
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(Icons.search, color: isDark ? Colors.white : Color(0xFFFF9100)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filtros tipo chip
                Obx(() {
                  if (controller.categorias.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoriaChipModern('', 'Todos', selected: controller.selectedCategoria.value == ''),
                        const SizedBox(width: 8),
                        ...controller.categorias.map((categoria) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildCategoriaChipModern(categoria, categoria, selected: controller.selectedCategoria.value == categoria),
                        )),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
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
                return _buildEmprendedoresListModern(context, isDark);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaChipModern(String value, String label, {bool selected = false}) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : Color(0xFFFF9100))),
      selected: selected,
      selectedColor: Color(0xFFFF9100),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Color(0xFFFF9100), width: 1)),
      onSelected: (_) => controller.filterByCategoria(value),
      elevation: selected ? 4 : 0,
      pressElevation: 0,
    );
  }

  Widget _buildEmprendedoresListModern(BuildContext context, bool isDark) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.filteredEmprendedores.length,
      separatorBuilder: (_, __) => SizedBox(height: 18),
      itemBuilder: (ctx, i) {
        final emprendedor = controller.filteredEmprendedores[i];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          color: isDark ? Color(0xFF22325A) : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => controller.navigateToDetail(emprendedor),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9100).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.store_rounded, color: Colors.white, size: 32),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emprendedor.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.category_rounded, color: Color(0xFFFF9100), size: 18),
                            SizedBox(width: 4),
                            Text(
                              emprendedor.tipoServicio,
                              style: TextStyle(
                                color: Color(0xFFFF9100),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: isDark ? Colors.white54 : Colors.grey[500], size: 16),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                emprendedor.ubicacion,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey[700],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                emprendedor.estado ? 'Activo' : 'Inactivo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              backgroundColor: emprendedor.estado ? Color(0xFF43A047) : Colors.grey,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
} 