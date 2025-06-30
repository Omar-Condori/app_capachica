import 'package:flutter/material.dart';
import '../../../data/models/plan_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.background.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del plan
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: plan.imagenUrl != null && plan.imagenUrl!.isNotEmpty
                      ? Image.network(
                          plan.imagenUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y precio
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            plan.titulo,
                            style: AppTheme.lightTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (plan.precio != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${plan.precio!.toStringAsFixed(2)}',
                              style: AppTheme.lightTextTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Descripción
                    if (plan.descripcion != null && plan.descripcion!.isNotEmpty)
                      Text(
                        plan.descripcion!,
                        style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // Información adicional
                    Row(
                      children: [
                        if (plan.duracion != null) ...[
                          _infoChip(Icons.schedule, '${plan.duracion} días'),
                          const SizedBox(width: 8),
                        ],
                        if (plan.ubicacion != null) ...[
                          _infoChip(Icons.location_on, plan.ubicacion!),
                          const SizedBox(width: 8),
                        ],
                        if (plan.rating != null) ...[
                          _infoChip(Icons.star, plan.rating!.toStringAsFixed(1), color: Colors.amber),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Botón de ver más
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Ver detalles',
                          style: AppTheme.lightTextTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 48, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              'Imagen no disponible',
              style: AppTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.lightTextTheme.bodySmall?.copyWith(
              color: color ?? AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 