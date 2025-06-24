import 'package:flutter/material.dart';
import '../../../data/models/services_capachica_model.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServicioCapachica servicio;
  const ServiceDetailScreen({Key? key, required this.servicio}) : super(key: key);

  String capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Imagen principal
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
      imagenUrl = 'https://via.placeholder.com/600x300.png?text=Capachica';
    }

    final categoria = servicio.categorias.isNotEmpty ? servicio.categorias[0].nombre : 'Servicio';
    final categoriaColor = Colors.orange;
    final dias = servicio.horarios.map((h) => capitalizeFirst(h.diaSemana)).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(servicio.nombre),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              child: Image.network(
                imagenUrl!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://via.placeholder.com/600x300.png?text=Capachica',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
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
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          servicio.estado ? 'Disponible' : 'No disponible',
                          style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      Spacer(),
                      Text('S/. ${servicio.precioReferencial}', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 22)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(servicio.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  SizedBox(height: 6),
                  Text(servicio.descripcion, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text('Capacidad: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${servicio.capacidad} personas'),
                      SizedBox(width: 18),
                      Icon(Icons.location_on, color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text('Ubicación: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(servicio.ubicacionReferencia, maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  SizedBox(height: 18),
                  // Emprendedor
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue, size: 28),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(servicio.emprendedor.nombre, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            Text(servicio.emprendedor.tipoServicio, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                            Text(servicio.emprendedor.ubicacion, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.verified, color: Colors.orange, size: 22),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  // Horarios de disponibilidad
                  Text('Horarios de Disponibilidad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.orange[800])),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: servicio.horarios.map((h) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.green, size: 16),
                              SizedBox(width: 6),
                              Text(capitalizeFirst(h.diaSemana), style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green[900])),
                              SizedBox(width: 10),
                              Text('Disponible', style: TextStyle(color: Colors.green[700], fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text('${h.horaInicio} - ${h.horaFin}', style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                        ],
                      ),
                    )).toList(),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: Icon(Icons.chat, color: Colors.white),
                          label: Text('Contactar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: Icon(Icons.login, color: Colors.white),
                          label: Text('Reservar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 