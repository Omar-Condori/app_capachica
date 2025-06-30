import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plan_detalle_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/theme_toggle_button.dart';

class PlanDetalleScreen extends GetView<PlanDetalleController> {
  const PlanDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Plan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          const ThemeToggleButton(),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (controller.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error al cargar detalles', style: AppTheme.lightTextTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(controller.errorMessage.value, style: AppTheme.lightTextTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.loadDetalle,
                    icon: Icon(Icons.refresh),
                    label: Text('Reintentar'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ),
          );
        } else if (controller.planDetalle.value == null) {
          return Center(child: Text('No hay datos para mostrar', style: AppTheme.lightTextTheme.bodyLarge));
        }
        final detalle = controller.planDetalle.value!;
        return RefreshIndicator(
          onRefresh: controller.loadDetalle,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Imagen principal
              if (detalle.plan.imagenUrl != null && detalle.plan.imagenUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    detalle.plan.imagenUrl!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 220,
                      color: AppColors.primary.withValues(alpha: 0.08),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 64, color: AppColors.primary),
                            SizedBox(height: 8),
                            Text('Imagen no disponible', style: AppTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Título y precio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      detalle.plan.titulo,
                      style: AppTheme.lightTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (detalle.plan.precio != null)
                    Text(
                      '\$${detalle.plan.precio!.toStringAsFixed(2)}',
                      style: AppTheme.lightTextTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Descripción
              if (detalle.plan.descripcion != null && detalle.plan.descripcion!.isNotEmpty)
                Text(detalle.plan.descripcion!, style: AppTheme.lightTextTheme.bodyMedium),
              const SizedBox(height: 12),
              // Info básica
              Row(
                children: [
                  if (detalle.plan.duracion != null)
                    _infoIcon(Icons.schedule, '${detalle.plan.duracion} días'),
                  if (detalle.plan.ubicacion != null) ...[
                    const SizedBox(width: 16),
                    _infoIcon(Icons.location_on, detalle.plan.ubicacion!),
                  ],
                  if (detalle.plan.rating != null) ...[
                    const SizedBox(width: 16),
                    _infoIcon(Icons.star, detalle.plan.rating!.toStringAsFixed(1), color: Colors.amber),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              // Itinerario
              if (detalle.itinerario.isNotEmpty) ...[
                Text('Itinerario', style: AppTheme.lightTextTheme.titleLarge),
                const SizedBox(height: 8),
                ...detalle.itinerario.map((item) => ListTile(
                  leading: Icon(Icons.event_note, color: AppColors.primary),
                  title: Text(item.titulo, style: AppTheme.lightTextTheme.bodyLarge),
                  subtitle: Text(item.descripcion ?? ''),
                  trailing: Text(item.horaInicio != null ? '${item.horaInicio} - ${item.horaFin}' : ''),
                )),
                const SizedBox(height: 16),
              ],
              // Incluye / No incluye
              if (detalle.incluye.isNotEmpty || detalle.noIncluye.isNotEmpty) ...[
                Text('Incluye', style: AppTheme.lightTextTheme.titleLarge),
                const SizedBox(height: 8),
                ...detalle.incluye.map((inc) => ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(inc.nombre),
                  subtitle: inc.descripcion != null ? Text(inc.descripcion!) : null,
                )),
                if (detalle.noIncluye.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('No incluye', style: AppTheme.lightTextTheme.titleLarge),
                  ...detalle.noIncluye.map((inc) => ListTile(
                    leading: Icon(Icons.cancel, color: Colors.red),
                    title: Text(inc.nombre),
                    subtitle: inc.descripcion != null ? Text(inc.descripcion!) : null,
                  )),
                ],
                const SizedBox(height: 16),
              ],
              // Información adicional
              if (detalle.informacionAdicional != null && detalle.informacionAdicional!.isNotEmpty) ...[
                Text('Información adicional', style: AppTheme.lightTextTheme.titleLarge),
                const SizedBox(height: 8),
                ...detalle.informacionAdicional!.entries.map((e) => ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.primary),
                  title: Text(e.key),
                  subtitle: Text(e.value),
                )),
                const SizedBox(height: 16),
              ],
              // Emprendedores asociados
              if (controller.emprendedores.isNotEmpty) ...[
                Text('Emprendedores asociados', style: AppTheme.lightTextTheme.titleLarge),
                const SizedBox(height: 8),
                ...controller.emprendedores.map((emp) => Card(
                  child: ListTile(
                    leading: emp.imagenUrl != null && emp.imagenUrl!.isNotEmpty
                        ? CircleAvatar(backgroundImage: NetworkImage(emp.imagenUrl!))
                        : CircleAvatar(child: Icon(Icons.person)),
                    title: Text(emp.nombre),
                    subtitle: Text(emp.categoria ?? ''),
                    trailing: emp.rating != null ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(emp.rating!.toStringAsFixed(1)),
                      ],
                    ) : null,
                  ),
                )),
              ],
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            icon: Icon(Icons.shopping_bag, color: Colors.white),
            label: Text('Reservar este plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: Implementar lógica de reserva
              Get.snackbar(
                'Reserva',
                'Función de reserva en desarrollo',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoIcon(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: AppTheme.lightTextTheme.bodyMedium),
      ],
    );
  }
} 