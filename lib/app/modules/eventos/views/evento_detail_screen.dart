import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eventos_controller.dart';
import '../../../data/models/evento_model.dart';
import 'evento_card.dart';

class EventoDetailScreen extends GetView<EventosController> {
  final Evento? evento;

  const EventoDetailScreen({Key? key, this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoadingDetalle.value) {
          return _buildLoadingState(theme);
        }
        
        if (controller.errorDetalle.value != null) {
          return _buildErrorState(theme);
        }
        
        final evento = this.evento ?? controller.eventoSeleccionado.value;
        if (evento == null) {
          return _buildNotFoundState(theme);
        }
        
        return _buildEventoDetail(theme, evento);
      }),
    );
  }

  Widget _buildEventoDetail(ThemeData theme, Evento evento) {
    return CustomScrollView(
      slivers: [
        // AppBar con imagen de fondo
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.share_rounded,
                color: Colors.white,
              ),
              onPressed: () => _shareEvento(evento),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeroImage(theme, evento),
          ),
        ),
        
        // Contenido del evento
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y estado
                _buildHeaderSection(theme, evento),
                
                SizedBox(height: 16),
                
                // Información principal
                _buildMainInfoSection(theme, evento),
                
                SizedBox(height: 24),
                
                // Descripción
                _buildDescriptionSection(theme, evento),
                
                SizedBox(height: 24),
                
                // Información adicional
                _buildAdditionalInfoSection(theme, evento),
                
                SizedBox(height: 24),
                
                // Emprendedor
                _buildEmprendedorSection(theme, evento),
                
                SizedBox(height: 24),
                
                // Otros eventos del emprendedor
                _buildOtherEventsSection(theme, evento),
                
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(ThemeData theme, Evento evento) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Imagen de fondo
          Container(
            width: double.infinity,
            height: double.infinity,
            child: evento.imagenUrl != null && evento.imagenUrl!.isNotEmpty
                ? Image.network(
                    evento.imagenUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage(theme);
                    },
                  )
                : _buildPlaceholderImage(theme),
          ),
          
          // Overlay con información
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                children: [
                  _buildStatusChip(theme, evento),
                  SizedBox(height: 8),
                  Text(
                    evento.titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
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

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.event_rounded,
          size: 64,
          color: theme.primaryColor.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, Evento evento) {
    Color chipColor;
    Color textColor;
    String text;
    IconData icon;

    if (evento.isActivo && evento.isProximo) {
      chipColor = Colors.green;
      textColor = Colors.white;
      text = 'Próximo';
      icon = Icons.upcoming_rounded;
    } else if (evento.isActivo) {
      chipColor = Colors.blue;
      textColor = Colors.white;
      text = 'Activo';
      icon = Icons.play_circle_outline_rounded;
    } else {
      chipColor = Colors.grey;
      textColor = Colors.white;
      text = 'Finalizado';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, Evento evento) {
    return Row(
      children: [
        Expanded(
          child: Text(
            evento.titulo,
            style: TextStyle(
              color: theme.textTheme.headlineSmall?.color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 12),
        if (evento.precio != null && evento.precio! > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'S/ ${evento.precio!.toStringAsFixed(2)}',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Gratis',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainInfoSection(ThemeData theme, Evento evento) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        children: [
          _buildInfoRow(theme, Icons.calendar_today_rounded, 'Fecha y Hora', '${evento.fecha} • ${evento.hora}'),
          SizedBox(height: 12),
          _buildInfoRow(theme, Icons.location_on_rounded, 'Ubicación', evento.ubicacion),
          if (evento.categoria != null) ...[
            SizedBox(height: 12),
            _buildInfoRow(theme, Icons.category_rounded, 'Categoría', evento.categoria!),
          ],
          if (evento.capacidadMaxima != null) ...[
            SizedBox(height: 12),
            _buildInfoRow(theme, Icons.people_rounded, 'Capacidad', '${evento.capacidadMaxima} personas'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.primaryColor.withOpacity(0.7),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ThemeData theme, Evento evento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12),
        Text(
          evento.descripcion,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(ThemeData theme, Evento evento) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Adicional',
            style: TextStyle(
              color: theme.textTheme.titleMedium?.color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          _buildInfoRow(theme, Icons.info_outline_rounded, 'Estado', evento.estado ?? 'No especificado'),
          if (evento.fechaCreacion != null) ...[
            SizedBox(height: 12),
            _buildInfoRow(
              theme, 
              Icons.schedule_rounded, 
              'Fecha de Creación', 
              '${evento.fechaCreacion!.day}/${evento.fechaCreacion!.month}/${evento.fechaCreacion!.year}'
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmprendedorSection(ThemeData theme, Evento evento) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organizador',
            style: TextStyle(
              color: theme.textTheme.titleMedium?.color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: evento.emprendedorImagen != null && evento.emprendedorImagen!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          evento.emprendedorImagen!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person_rounded,
                              size: 24,
                              color: theme.primaryColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: 24,
                        color: theme.primaryColor,
                      ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.emprendedorNombre,
                      style: TextStyle(
                        color: theme.textTheme.titleMedium?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Organizador del evento',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.primaryColor,
                ),
                onPressed: () => controller.onEmprendedorEventosTap(evento.emprendedorId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherEventsSection(ThemeData theme, Evento evento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Otros eventos de ${evento.emprendedorNombre}',
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () => controller.onEmprendedorEventosTap(evento.emprendedorId),
              child: Text(
                'Ver todos',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingEmprendedor.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
            );
          }
          
          if (controller.errorEmprendedor.value != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Error al cargar otros eventos',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }
          
          if (controller.eventosEmprendedor.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No hay otros eventos disponibles',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.eventosEmprendedor.length > 3 ? 3 : controller.eventosEmprendedor.length,
            itemBuilder: (context, index) {
              final otroEvento = controller.eventosEmprendedor[index];
              if (otroEvento.id == evento.id) return SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: EventoCard(
                  evento: otroEvento,
                  onTap: () => controller.onEventoTap(otroEvento),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando evento...',
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
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
                'Error al cargar el evento',
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorDetalle.value ?? 'Error desconocido',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (evento != null) {
                    controller.loadEventoDetalle(evento!.id);
                  }
                },
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
      ),
    );
  }

  Widget _buildNotFoundState(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Evento'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
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
                'Evento no encontrado',
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'El evento que buscas no existe o ha sido eliminado',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareEvento(Evento evento) {
    // Implementar funcionalidad de compartir
    Get.snackbar(
      'Compartir',
      'Funcionalidad de compartir próximamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }
} 