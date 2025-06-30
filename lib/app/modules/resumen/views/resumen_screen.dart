import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resumen_controller.dart';
import '../../../domain/usecases/get_resumen_usecase.dart';
import '../../../core/widgets/theme_toggle_button.dart';

class ResumenScreen extends GetView<ResumenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resumen de Capachica',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.loadResumen(),
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
                SizedBox(height: 16),
                Text(
                  'Cargando datos del resumen...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.resumenError.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16),
                Text(
                  'Error al cargar datos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.resumenError.value!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.loadResumen(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Reintentar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final resumenData = controller.resumenData.value;
        if (resumenData == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No hay datos disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Presiona el botón de recarga para obtener datos',
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

        return RefreshIndicator(
          onRefresh: () async => controller.loadResumen(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con información del health check
                _buildHealthCheckCard(resumenData),
                SizedBox(height: 16),

                // Sección de Sliders/Banners
                _buildSlidersSection(resumenData.sliders),
                SizedBox(height: 16),

                // Sección de Municipalidades
                _buildMunicipalidadesSection(resumenData.municipalidades),
                SizedBox(height: 16),

                // Sección de detalles de la primera municipalidad
                if (resumenData.primeraMunicipalidadDetalle != null)
                  _buildMunicipalidadDetalleSection(resumenData.primeraMunicipalidadDetalle!),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHealthCheckCard(ResumenData resumenData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50).withOpacity(0.1),
              Color(0xFF4CAF50).withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del Sistema',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    resumenData.healthCheck.message ?? 'API funcionando correctamente',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidersSection(List<dynamic> sliders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Banners Promocionales',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sliders.length,
            itemBuilder: (context, index) {
              final slider = sliders[index];
              return Container(
                width: 300,
                margin: EdgeInsets.only(right: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Imagen de fondo (placeholder)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1976D2),
                                Color(0xFF3949AB),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        // Contenido
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                slider.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              if (slider.description != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  slider.description!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMunicipalidadesSection(List<dynamic> municipalidades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Municipalidades',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: municipalidades.length,
          itemBuilder: (context, index) {
            final municipalidad = municipalidades[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  municipalidad.nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (municipalidad.descripcion != null) ...[
                      SizedBox(height: 4),
                      Text(
                        municipalidad.descripcion!,
                        style: TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (municipalidad.ubicacion != null) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            municipalidad.ubicacion!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Aquí podrías navegar a los detalles de la municipalidad
                  Get.snackbar(
                    'Municipalidad',
                    'Detalles de ${municipalidad.nombre}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMunicipalidadDetalleSection(dynamic municipalidadDetalle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalles de ${municipalidadDetalle.municipalidad.nombre}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: 12),

        // Servicios
        if (municipalidadDetalle.servicios.isNotEmpty) ...[
          Text(
            'Servicios Disponibles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1976D2),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: municipalidadDetalle.servicios.length,
              itemBuilder: (context, index) {
                final servicio = municipalidadDetalle.servicios[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: 12),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.miscellaneous_services, color: Color(0xFF1976D2)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  servicio.nombre,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          if (servicio.descripcion != null)
                            Text(
                              servicio.descripcion!,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Spacer(),
                          if (servicio.precio != null)
                            Text(
                              'S/ ${servicio.precio!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
        ],

        // Negocios
        if (municipalidadDetalle.negocios.isNotEmpty) ...[
          Text(
            'Negocios Locales',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1976D2),
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: municipalidadDetalle.negocios.length,
            itemBuilder: (context, index) {
              final negocio = municipalidadDetalle.negocios[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.store,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    negocio.nombre,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (negocio.descripcion != null) ...[
                        SizedBox(height: 2),
                        Text(
                          negocio.descripcion!,
                          style: TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (negocio.ubicacion != null) ...[
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              negocio.ubicacion!,
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],

        // Estadísticas
        if (municipalidadDetalle.estadisticas != null) ...[
          SizedBox(height: 16),
          Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1976D2),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Servicios',
                    municipalidadDetalle.estadisticas!['total_servicios']?.toString() ?? '0',
                    Icons.miscellaneous_services,
                    Color(0xFF1976D2),
                  ),
                  _buildStatItem(
                    'Negocios',
                    municipalidadDetalle.estadisticas!['total_negocios']?.toString() ?? '0',
                    Icons.store,
                    Color(0xFFFF9100),
                  ),
                  _buildStatItem(
                    'Visitantes',
                    municipalidadDetalle.estadisticas!['visitantes_mes']?.toString() ?? '0',
                    Icons.people,
                    Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 