import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resumen_controller.dart';
import '../../../domain/usecases/get_resumen_usecase.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/widgets/apple_style_widgets.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';

class ResumenScreen extends GetView<ResumenController> {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Capachica',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.textTheme.bodyLarge?.color,
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
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () => controller.loadResumen(),
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState(context);
        }

        if (controller.resumenError.value != null) {
          return _buildErrorState(context);
        }

        final resumenData = controller.resumenData.value;
        if (resumenData == null) {
          return _buildEmptyState(context);
        }

        return _buildContent(context, resumenData);
      }),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando datos...',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar datos',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.resumenError.value!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppleButton(
              text: 'Reintentar',
              icon: Icons.refresh_rounded,
              onPressed: () => controller.loadResumen(),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.dashboard_outlined,
                size: 48,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay datos disponibles',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón de recarga para obtener datos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ResumenData resumenData) {
    return RefreshIndicator(
      onRefresh: () async => controller.loadResumen(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header con estado del sistema
          SliverToBoxAdapter(
            child: _buildHealthCheckSection(context, resumenData),
          ),
          
          // Sección de banners promocionales
          if (resumenData.sliders.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSlidersSection(context, resumenData.sliders),
            ),
          
          // Sección de municipalidades
          SliverToBoxAdapter(
            child: _buildMunicipalidadesSection(context, resumenData.municipalidades),
          ),
          
          // Sección de detalles de la primera municipalidad
          if (resumenData.primeraMunicipalidadDetalle != null)
            SliverToBoxAdapter(
              child: _buildMunicipalidadDetalleSection(
                context, 
                resumenData.primeraMunicipalidadDetalle!
              ),
            ),
          
          // Espacio final
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCheckSection(BuildContext context, ResumenData resumenData) {
    return AppleSection(
      title: 'Estado del Sistema',
      subtitle: 'Verificando conectividad y servicios',
      crossAxisAlignment: CrossAxisAlignment.center,
      child: AppleStatusIndicator(
        title: 'API Funcionando',
        message: resumenData.healthCheck.message ?? 'Todos los servicios están operativos',
        icon: Icons.check_circle_rounded,
        color: Colors.green,
        isSuccess: true,
      ),
    );
  }

  Widget _buildSlidersSection(BuildContext context, List<dynamic> sliders) {
    return AppleSection(
      title: 'Banners Promocionales',
      subtitle: 'Descubre las mejores ofertas',
      child: AppleCarousel(
        height: 240,
        itemWidth: 320,
        children: sliders.map((slider) {
          return AppleCard(
            padding: EdgeInsets.zero,
            borderRadius: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Imagen de fondo con gradiente
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.image_rounded,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  
                  // Overlay con contenido
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          slider.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (slider.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            slider.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMunicipalidadesSection(BuildContext context, List<dynamic> municipalidades) {
    return AppleSection(
      title: 'Municipalidades',
      subtitle: 'Explora las diferentes zonas de Capachica',
      child: Column(
        children: municipalidades.map((municipalidad) {
          return AppleListTile(
            title: municipalidad.nombre,
            subtitle: municipalidad.descripcion ?? municipalidad.ubicacion,
            leadingIcon: Icons.business_rounded,
            leadingIconColor: Theme.of(context).primaryColor,
            onTap: () {
              Get.snackbar(
                'Municipalidad',
                'Detalles de ${municipalidad.nombre}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Theme.of(context).primaryColor,
                colorText: Colors.white,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMunicipalidadDetalleSection(BuildContext context, dynamic municipalidadDetalle) {
    final theme = Theme.of(context);
    
    return AppleSection(
      title: 'Detalles de ${municipalidadDetalle.municipalidad.nombre}',
      subtitle: 'Información completa y servicios disponibles',
      child: Column(
        children: [
          // Servicios
          if (municipalidadDetalle.servicios.isNotEmpty) ...[
            _buildServicesSection(context, municipalidadDetalle.servicios),
            const SizedBox(height: 32),
          ],
          
          // Negocios
          if (municipalidadDetalle.negocios.isNotEmpty) ...[
            _buildBusinessesSection(context, municipalidadDetalle.negocios),
            const SizedBox(height: 32),
          ],
          
          // Estadísticas
          if (municipalidadDetalle.estadisticas != null) ...[
            _buildStatisticsSection(context, municipalidadDetalle.estadisticas),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, List<dynamic> servicios) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servicios Disponibles',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        AppleCarousel(
          height: 160,
          itemWidth: 240,
          children: servicios.map((servicio) {
            return AppleCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.miscellaneous_services_rounded,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          servicio.nombre,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (servicio.descripcion != null)
                    Text(
                      servicio.descripcion!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  if (servicio.precio != null)
                    Text(
                      'S/ ${servicio.precio!.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBusinessesSection(BuildContext context, List<dynamic> negocios) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Negocios Locales',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...negocios.map((negocio) {
          return AppleListTile(
            title: negocio.nombre,
            subtitle: negocio.descripcion ?? negocio.ubicacion,
            leadingIcon: Icons.store_rounded,
            leadingIconColor: Colors.orange,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context, Map<String, dynamic> estadisticas) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppleStatCard(
                label: 'Servicios',
                value: estadisticas['total_servicios']?.toString() ?? '0',
                icon: Icons.miscellaneous_services_rounded,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppleStatCard(
                label: 'Negocios',
                value: estadisticas['total_negocios']?.toString() ?? '0',
                icon: Icons.store_rounded,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppleStatCard(
                label: 'Visitantes',
                value: estadisticas['visitantes_mes']?.toString() ?? '0',
                icon: Icons.people_rounded,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 