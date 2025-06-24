import 'package:flutter/material.dart';
import '../../../data/models/services_capachica_model.dart';

class ServiceCard extends StatelessWidget {
  final ServicioCapachica servicio;
  final VoidCallback onTap;

  const ServiceCard({Key? key, required this.servicio, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener la imagen principal (si existe)
    String capitalizeFirst(String s) {
      if (s.isEmpty) return s;
      return s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    String? imagenUrl;
    try {
      final imgs = servicio.emprendedor.imagenes;
      List<String> lista = [];
      
      if (imgs != null && imgs.isNotEmpty) {
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
      }
      
      if (lista.isNotEmpty && lista[0].isNotEmpty) {
        imagenUrl = lista[0];
      }
    } catch (_) {}

    // Validar que la URL sea válida (http/https)
    bool isValidUrl(String? url) {
      return url != null && (url.startsWith('http://') || url.startsWith('https://'));
    }
    if (!isValidUrl(imagenUrl)) {
      imagenUrl = 'https://via.placeholder.com/400x200.png?text=Capachica';
    }

    // Obtener categoría principal
    final categoria = servicio.categorias.isNotEmpty ? servicio.categorias[0].nombre : 'Servicio';
    final categoriaColor = Colors.orange;

    // Días disponibles
    final dias = servicio.horarios.map((h) => capitalizeFirst(h.diaSemana.substring(0,3))).toSet().toList();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y chips
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(
                    imagenUrl!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://via.placeholder.com/400x200.png?text=Capachica',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoriaColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      categoria,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'S/. ${servicio.precioReferencial}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        servicio.ubicacionReferencia,
                        style: TextStyle(color: Colors.white, fontSize: 13, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(servicio.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  Text(servicio.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue, size: 20),
                      SizedBox(width: 6),
                      Text(servicio.emprendedor.nombre, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
                      SizedBox(width: 8),
                      Text('Emprendedor local', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text('DISPONIBLE:', style: TextStyle(fontSize: 13, color: Colors.green[800], fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      ...dias.take(3).map((d) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(d, style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w600, fontSize: 12)),
                      )),
                      if (dias.length > 3)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('+${dias.length - 3}', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                    ],
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: Icon(Icons.info_outline, color: Colors.white),
                      label: Text('Ver Detalles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: onTap,
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
} 