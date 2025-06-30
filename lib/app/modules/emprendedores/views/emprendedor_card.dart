import 'package:flutter/material.dart';
import '../../../data/models/emprendedor_model.dart';
import '../../../core/constants/app_colors.dart';

class EmprendedorCard extends StatelessWidget {
  final Emprendedor emprendedor;
  final VoidCallback onTap;

  const EmprendedorCard({
    Key? key,
    required this.emprendedor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del emprendedor
              _buildEmprendedorImage(),
              const SizedBox(width: 16),
              
              // Información del emprendedor
              Expanded(
                child: _buildEmprendedorInfo(),
              ),
              
              // Icono de flecha
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmprendedorImage() {
    String? imagenUrl;
    
    try {
      // Intentar obtener la imagen principal
      if (emprendedor.imagen != null && emprendedor.imagen!.isNotEmpty) {
        imagenUrl = emprendedor.imagen;
      } else if (emprendedor.imagenes != null && emprendedor.imagenes!.isNotEmpty) {
        // Si no hay imagen principal, intentar obtener de la lista de imágenes
        final imgs = emprendedor.imagenes!;
        List<String> lista = [];
        
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
          lista = imgs.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        } else {
          lista = [imgs];
        }
        
        if (lista.isNotEmpty && lista[0].isNotEmpty) {
          imagenUrl = lista[0];
        }
      }
    } catch (_) {}

    // Validar que la URL sea válida
    bool isValidUrl(String? url) {
      return url != null && (url.startsWith('http://') || url.startsWith('https://'));
    }

    if (!isValidUrl(imagenUrl)) {
      imagenUrl = 'https://via.placeholder.com/80x80.png?text=🏪';
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagenUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.store,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmprendedorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del emprendedor
        Text(
          emprendedor.nombre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Tipo de servicio
        Row(
          children: [
            Icon(
              Icons.category,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                emprendedor.tipoServicio,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Ubicación
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                emprendedor.ubicacion,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Estado y descripción
        Row(
          children: [
            // Estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: emprendedor.estado ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                emprendedor.estado ? 'Activo' : 'Inactivo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: emprendedor.estado ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Número de servicios si está disponible
            if (emprendedor.servicios != null && emprendedor.servicios!.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.work,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${emprendedor.servicios!.length} servicio${emprendedor.servicios!.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
} 