import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  final Map<String, dynamic> reserva;
  final VoidCallback onEliminar;
  final VoidCallback onEditar;

  const CartCard({
    Key? key,
    required this.reserva,
    required this.onEliminar,
    required this.onEditar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final servicio = reserva['servicio'] as Map<String, dynamic>;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y detalles principales
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del servicio
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    servicio['imagenUrl'] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error_outline),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Detalles del servicio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio['nombre'] ?? 'Sin nombre',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cantidad: ${reserva['cantidad']}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        'S/ ${reserva['precioTotal']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fecha y hora
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  '${reserva['fechaInicio']} ${reserva['horaInicio']}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Editar
                TextButton.icon(
                  onPressed: onEditar,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Editar',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botón Eliminar
                TextButton.icon(
                  onPressed: onEliminar,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Colors.red,
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
} 