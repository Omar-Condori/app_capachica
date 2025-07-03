import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resumen_controller.dart';
import '../../../domain/usecases/get_resumen_usecase.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/widgets/apple_style_widgets.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/widgets/cart_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ResumenScreen extends GetView<ResumenController> {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF101A30) : Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Barra superior moderna naranja
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
                CartIconButton(iconColor: Colors.white),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () => controller.loadResumen(),
                ),
                // El botón de modo claro/oscuro debe funcionar correctamente
                Builder(
                  builder: (context) => ThemeToggleButton(),
                ),
              ],
            ),
          ),
          // Barra de búsqueda moderna
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              color: isDark ? Color(0xFF22325A) : Colors.white,
              child: TextField(
                onChanged: (value) => controller.searchText.value = value,
                decoration: InputDecoration(
                  hintText: '¿A dónde quieres ir?',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, color: isDark ? Colors.white : Colors.grey[700]),
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
          ),
          // Expanded con cards modernas para banners, municipalidades y detalles
          Expanded(
            child: Obx(() {
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
              return RefreshIndicator(
                onRefresh: () async => controller.loadResumen(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24),
                  children: [
                    // Card de banners
                    if (resumenData.sliders.isNotEmpty)
                      _buildModernCardSection(
                        context,
                        title: 'Banners Promocionales',
                        subtitle: 'Descubre las mejores ofertas',
                        child: SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: resumenData.sliders.length,
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                            itemBuilder: (ctx, i) {
                              final slider = resumenData.sliders[i];
                              return _buildSliderCard(slider, isDark);
                            },
                          ),
                        ),
                      ),
                    SizedBox(height: 18),
                    // Card de municipalidades (con toda la info detallada y sliders internos)
                    Obx(() {
                      final filtered = controller.filteredMunicipalidades;
                      if (filtered.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text('No se encontraron resultados', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                          ),
                        );
                      }
                      return Column(
                        children: filtered.map<Widget>((muni) {
                          return _buildModernCardSection(
                            context,
                            title: muni.nombre,
                            subtitle: (muni.frase ?? '').isNotEmpty ? '"${muni.frase}"' : null,
                            child: _buildMunicipalidadFullCard(context, muni, isDark),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: 18),
                    // Card de detalles de la primera municipalidad
                    if (resumenData.primeraMunicipalidadDetalle != null)
                      _buildModernCardSection(
                        context,
                        title: 'Detalles de ${resumenData.primeraMunicipalidadDetalle!.municipalidad.nombre}',
                        subtitle: 'Información completa y servicios disponibles',
                        child: _buildMunicipalidadDetalleSection(context, resumenData.primeraMunicipalidadDetalle!),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
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

  Widget _buildModernCardSection(BuildContext context, {required String title, String? subtitle, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFFFF9100),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Color(0xFFFF9100),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
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
      width: 320,
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
        image: slider.urlCompleta != null && slider.urlCompleta.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(slider.urlCompleta),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.18),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: slider.urlCompleta != null && slider.urlCompleta.isNotEmpty
          ? SizedBox.shrink()
          : Center(
              child: Icon(Icons.image_rounded, size: 64, color: isDark ? Colors.white30 : Colors.grey[300]),
            ),
    );
  }

  Widget _buildMunicipalidadFullCard(BuildContext context, muni, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sliders internos
          if (muni.slidersPrincipales != null && muni.slidersPrincipales.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: muni.slidersPrincipales.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final slider = muni.slidersPrincipales[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: slider.urlCompleta != null && slider.urlCompleta.isNotEmpty
                        ? Image.network(
                            slider.urlCompleta,
                            fit: BoxFit.cover,
                            width: 220,
                            height: 140,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                            ),
                          )
                        : Container(
                            width: 220,
                            height: 140,
                            color: Color(0xFFFF9100).withOpacity(0.15),
                            child: Icon(Icons.image_rounded, size: 48, color: Color(0xFFFF9100)),
                          ),
                  );
                },
              ),
            ),
          if (muni.descripcion != null && muni.descripcion.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              muni.descripcion,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
          if ((muni.mision != null && muni.mision.isNotEmpty) || (muni.vision != null && muni.vision.isNotEmpty) || (muni.valores != null && muni.valores.isNotEmpty)) ...[
            const SizedBox(height: 10),
            _buildMisionVisionValores(context, mision: muni.mision, vision: muni.vision, valores: muni.valores),
          ],
          // Redes sociales
          if ((muni.redFacebook != null && muni.redFacebook.isNotEmpty) || (muni.redInstagram != null && muni.redInstagram.isNotEmpty) || (muni.redYoutube != null && muni.redYoutube.isNotEmpty)) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (muni.redFacebook != null && muni.redFacebook.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.facebook, color: Colors.blue[800]),
                    onPressed: () => launchUrlString(muni.redFacebook, mode: LaunchMode.externalApplication),
                  ),
                if (muni.redInstagram != null && muni.redInstagram.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.purple),
                    onPressed: () => launchUrlString(muni.redInstagram, mode: LaunchMode.externalApplication),
                  ),
                if (muni.redYoutube != null && muni.redYoutube.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.play_circle_fill, color: Colors.red),
                    onPressed: () => launchUrlString(muni.redYoutube, mode: LaunchMode.externalApplication),
                  ),
              ],
            ),
          ],
          if (muni.comunidades != null && muni.comunidades.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Comunidades:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.comunidades, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.historiaFamilias != null && muni.historiaFamilias.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Historia de las Familias:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.historiaFamilias, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.historiaCapachica != null && muni.historiaCapachica.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Historia de Capachica:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.historiaCapachica, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.comite != null && muni.comite.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Comité de Turismo:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.comite, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.alianzas != null && muni.alianzas.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Alianzas:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.alianzas, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.ordenanzaMunicipal != null && muni.ordenanzaMunicipal.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Ordenanza Municipal:', style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold, fontSize: 15)),
            Text(muni.ordenanzaMunicipal, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
          ],
          if (muni.correo != null && muni.correo.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFFFF9100)),
                const SizedBox(width: 6),
                Text(muni.correo, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
              ],
            ),
          ],
          if (muni.horarioDeAtencion != null && muni.horarioDeAtencion.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, color: Color(0xFFFF9100)),
                const SizedBox(width: 6),
                Text(muni.horarioDeAtencion, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
              ],
            ),
          ],
        ],
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

  Widget _buildMisionVisionValores(BuildContext context, {required String? mision, required String? vision, required String? valores}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mision != null && mision.isNotEmpty)
          _buildInfoCard(
            context,
            icon: Icons.flag_rounded,
            title: 'Misión',
            color: Color(0xFFFF9100),
            content: mision,
          ),
        if (vision != null && vision.isNotEmpty) ...[
          SizedBox(height: 14),
          _buildInfoCard(
            context,
            icon: Icons.visibility_rounded,
            title: 'Visión',
            color: Color(0xFF1976D2),
            content: vision,
          ),
        ],
        if (valores != null && valores.isNotEmpty) ...[
          SizedBox(height: 14),
          _buildInfoCard(
            context,
            icon: Icons.star_rounded,
            title: 'Valores',
            color: Color(0xFF43A047),
            contentWidget: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: valores.split(',').map((valor) => Chip(
                label: Text(valor.trim(), style: TextStyle(fontWeight: FontWeight.w500)),
                backgroundColor: Color(0xFF43A047).withOpacity(0.1),
              )).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required Color color, String? content, Widget? contentWidget}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (content != null)
              Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            if (contentWidget != null) contentWidget,
          ],
        ),
      ),
    );
  }
} 