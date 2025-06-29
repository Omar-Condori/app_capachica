import 'package:flutter/material.dart';
import '../../../data/models/plan_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onTap;

  const PlanCard({
    Key? key,
    required this.plan,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del plan
            _buildImageSection(),
            
            // Contenido del plan
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y categoría
                  _buildHeaderSection(),
                  
                  const SizedBox(height: 8),
                  
                  // Descripción
                  if (plan.descripcion != null && plan.descripcion!.isNotEmpty)
                    _buildDescriptionSection(),
                  
                  const SizedBox(height: 12),
                  
                  // Información adicional
                  _buildInfoSection(),
                  
                  const SizedBox(height: 12),
                  
                  // Precio y botón
                  _buildPriceSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: plan.imagenUrl != null && plan.imagenUrl!.isNotEmpty
            ? Image.network(
                plan.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Imagen no disponible',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            plan.titulo,
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (plan.categoria != null && plan.categoria!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              plan.categoria!,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      plan.descripcion!,
      style: AppTheme.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoSection() {
    return Row(
      children: [
        // Duración
        if (plan.duracion != null)
          _buildInfoItem(
            icon: Icons.schedule,
            text: '${plan.duracion} día${plan.duracion! > 1 ? 's' : ''}',
          ),
        
        if (plan.duracion != null && plan.ubicacion != null)
          const SizedBox(width: 16),
        
        // Ubicación
        if (plan.ubicacion != null)
          Expanded(
            child: _buildInfoItem(
              icon: Icons.location_on,
              text: plan.ubicacion!,
            ),
          ),
        
        const SizedBox(width: 16),
        
        // Rating
        if (plan.rating != null)
          _buildInfoItem(
            icon: Icons.star,
            text: plan.rating!.toStringAsFixed(1),
            iconColor: Colors.amber,
          ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        // Precio
        if (plan.precio != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${plan.precio!.toStringAsFixed(2)}',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(width: 16),
        
        // Botón ver detalles
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Ver detalles',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 