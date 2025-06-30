import 'package:flutter/material.dart';
import '../../data/models/services_capachica_model.dart';
import 'auth_redirect_dialog.dart';
import '../../services/reserva_service.dart';
import '../../data/models/reserva_model.dart';
import 'package:get/get.dart';

class ModernServiceCard extends StatelessWidget {
  final ServicioCapachica servicio;
  final VoidCallback onTap;
  final bool showPrice;
  final VoidCallback? onVerDetalle;
  final VoidCallback? onReservar;

  const ModernServiceCard({
    super.key,
    required this.servicio,
    required this.onTap,
    this.showPrice = true,
    this.onVerDetalle,
    this.onReservar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Obtener imagen del servicio
    String? imagenUrl = _getImagenUrl();
    
    // Obtener categoría principal
    final categoria = servicio.categorias.isNotEmpty 
        ? servicio.categorias.first.nombre 
        : 'Servicio';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shadowColor: theme.shadowColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del servicio
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
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
                      child: imagenUrl != null
                          ? Image.network(
                              imagenUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage(theme);
                              },
                            )
                          : _buildPlaceholderImage(theme),
                    ),
                    
                    // Overlay con información
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          // Badge de categoría
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              categoria,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Badge de estado
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: servicio.estado 
                                  ? Colors.green.withValues(alpha: 0.9)
                                  : Colors.red.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              servicio.estado ? 'Disponible' : 'No disponible',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Precio en la esquina inferior derecha
                    if (showPrice)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'S/ ${servicio.precioReferencial}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Contenido de la tarjeta
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del servicio
                    Text(
                      servicio.nombre,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Descripción
                    Text(
                      servicio.descripcion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Información adicional
                    Row(
                      children: [
                        // Capacidad
                        _buildInfoItem(
                          context,
                          Icons.people_rounded,
                          '${servicio.capacidad} personas',
                          theme.primaryColor,
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Ubicación
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            Icons.location_on_rounded,
                            servicio.ubicacionReferencia,
                            Colors.grey[600]!,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Emprendedor
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.business_rounded,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                servicio.emprendedor.nombre,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                servicio.emprendedor.tipoServicio,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        Icon(
                          Icons.verified_rounded,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                      ],
                    ),
                    
                    // Botones de acción
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Botón Ver Detalle
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onVerDetalle,
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: theme.primaryColor,
                            ),
                            label: Text(
                              'Ver Detalle',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        ),
      ),
    );
  }

  void _handleReservar() {
    final reservaService = Get.find<ReservaService>();
    
    if (!reservaService.isAuthenticated) {
      // Mostrar diálogo de autenticación requerida
      Get.dialog(
        AuthRedirectDialog(
          onLoginPressed: () {
            // Guardar la ruta pendiente para regresar después del login
            Get.offAllNamed('/login');
          },
          onRegisterPressed: () {
            // Guardar la ruta pendiente para regresar después del registro
            Get.offAllNamed('/register');
          },
        ),
      );
    } else {
      // Usuario autenticado, agregar al carrito
      _agregarAlCarrito();
    }
  }

  void _agregarAlCarrito() async {
    try {
      final reservaService = Get.find<ReservaService>();
      
      // Crear la solicitud para agregar al carrito
      final request = AgregarAlCarritoRequest(
        servicioId: servicio.id,
        emprendedorId: servicio.emprendedorId,
        fechaInicio: DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0],
        fechaFin: DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0],
        horaInicio: '09:00',
        horaFin: '10:00',
        duracionMinutos: 60,
        cantidad: 1,
        notasCliente: null,
      );
      
      await reservaService.agregarAlCarrito(request);
      
      Get.snackbar(
        '¡Servicio agregado!',
        'El servicio ha sido agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Navegar al carrito
      Get.toNamed('/carrito');
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar el servicio al carrito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      height: 180,
      width: double.infinity,
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
        size: 48,
        color: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  String? _getImagenUrl() {
    try {
      final imgs = servicio.emprendedor.imagenes;
      if (imgs != null && imgs.isNotEmpty) {
        List<String> lista = [];
        
        // Si es un string que contiene una lista serializada
        if (imgs.startsWith('[') && imgs.endsWith(']')) {
          lista = imgs
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        } else if (imgs.contains(',')) {
          // Si es un string con URLs separadas por comas
          lista = imgs.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        } else {
          // Si es una sola URL
          lista = [imgs];
        }
        
        if (lista.isNotEmpty && lista[0].isNotEmpty) {
          final url = lista[0];
          // Validar que la URL sea válida
          if (url.startsWith('http://') || url.startsWith('https://')) {
            return url;
          }
        }
      }
    } catch (e) {
      print('Error procesando imagen: $e');
    }
    return null;
  }
} 