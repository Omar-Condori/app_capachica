import 'package:flutter/material.dart';
import '../../data/models/reserva_model.dart';

class CartCard extends StatelessWidget {
  final ReservaModel reserva;
  final VoidCallback onEliminar;
  final VoidCallback? onEditar;

  const CartCard({
    super.key,
    required this.reserva,
    required this.onEliminar,
    this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shadowColor: theme.shadowColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con imagen y título
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del servicio
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: reserva.servicio?.imagenUrl != null
                        ? Image.network(
                            reserva.servicio!.imagenUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage(theme);
                            },
                          )
                        : _buildPlaceholderImage(theme),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Información del servicio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reserva.servicio?.nombre ?? 'Servicio',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        reserva.emprendedor?.nombre ?? 'Emprendedor',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Precio
                      Row(
                        children: [
                          Text(
                            'S/ ${reserva.precioTotal.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.primaryColor,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Cantidad
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'x${reserva.cantidad}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Detalles de la reserva
            _buildDetailRow(
              context,
              Icons.calendar_today_rounded,
              'Fecha: ${reserva.fechaInicio}',
              theme,
            ),
            
            const SizedBox(height: 8),
            
            _buildDetailRow(
              context,
              Icons.access_time_rounded,
              'Hora: ${reserva.horaInicio} - ${reserva.horaFin}',
              theme,
            ),
            
            const SizedBox(height: 8),
            
            _buildDetailRow(
              context,
              Icons.timer_rounded,
              'Duración: ${reserva.duracionMinutos} minutos',
              theme,
            ),
            
            // Notas del cliente
            if (reserva.notasCliente != null && reserva.notasCliente!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notas:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reserva.notasCliente!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                // Botón Editar (opcional)
                if (onEditar != null) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEditar,
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: theme.primaryColor,
                      ),
                      label: Text(
                        'Editar',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                
                // Botón Eliminar
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onEliminar,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Eliminar',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Icon(
        Icons.image_rounded,
        size: 32,
        color: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }
} 