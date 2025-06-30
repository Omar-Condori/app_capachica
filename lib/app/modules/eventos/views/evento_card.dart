import 'package:flutter/material.dart';
import '../../../data/models/evento_model.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;

  const EventoCard({
    Key? key,
    required this.evento,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            _buildImageSection(theme),
            
            // Contenido del evento
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y estado
                  _buildHeaderSection(theme),
                  
                  SizedBox(height: 8),
                  
                  // Descripción
                  _buildDescriptionSection(theme),
                  
                  SizedBox(height: 12),
                  
                  // Información de fecha y ubicación
                  _buildInfoSection(theme),
                  
                  SizedBox(height: 12),
                  
                  // Emprendedor y precio
                  _buildFooterSection(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: theme.primaryColor.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: evento.imagenUrl != null && evento.imagenUrl!.isNotEmpty
            ? Image.network(
                evento.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage(theme);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderImage(theme);
                },
              )
            : _buildPlaceholderImage(theme),
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.event_rounded,
          size: 48,
          color: theme.primaryColor.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            evento.titulo,
            style: TextStyle(
              color: theme.textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        _buildStatusChip(theme),
      ],
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    Color chipColor;
    Color textColor;
    String text;
    IconData icon;

    if (evento.isActivo && evento.isProximo) {
      chipColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      text = 'Próximo';
      icon = Icons.upcoming_rounded;
    } else if (evento.isActivo) {
      chipColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue;
      text = 'Activo';
      icon = Icons.play_circle_outline_rounded;
    } else {
      chipColor = Colors.grey.withOpacity(0.1);
      textColor = Colors.grey;
      text = 'Finalizado';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Text(
      evento.descripcion,
      style: TextStyle(
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
        fontSize: 14,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Row(
      children: [
        // Fecha y hora
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: theme.primaryColor.withOpacity(0.7),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${evento.fecha} • ${evento.hora}',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        // Ubicación
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: theme.primaryColor.withOpacity(0.7),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  evento.ubicacion,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(ThemeData theme) {
    return Row(
      children: [
        // Emprendedor
        Expanded(
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: evento.emprendedorImagen != null && evento.emprendedorImagen!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          evento.emprendedorImagen!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person_rounded,
                              size: 14,
                              color: theme.primaryColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: 14,
                        color: theme.primaryColor,
                      ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  evento.emprendedorNombre,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        // Precio
        if (evento.precio != null && evento.precio! > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'S/ ${evento.precio!.toStringAsFixed(2)}',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Gratis',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
} 