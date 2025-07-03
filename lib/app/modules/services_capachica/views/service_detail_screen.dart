import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/services_capachica_model.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../services/auth_service.dart';
import '../../../services/reserva_service.dart';
import '../../../core/widgets/auth_redirect_dialog.dart';
import '../../../data/models/reserva_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/widgets/cart_icon_with_badge.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServicioCapachica servicio;
  const ServiceDetailScreen({Key? key, required this.servicio}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isLoggedIn = authService.isLoggedIn;

    // Imagen principal
    String? imagenUrl;
    try {
      final imgs = widget.servicio.emprendedor.imagenes;
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

    final categoria = widget.servicio.categorias.isNotEmpty ? widget.servicio.categorias[0].nombre : 'Servicio';
    final categoriaColor = Colors.orange;
    final dias = widget.servicio.horarios.map((h) => capitalizeFirst(h.diaSemana)).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.servicio.nombre),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          const CartIconWithBadge(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              child: isValidUrl(imagenUrl)
                  ? Image.network(
                      imagenUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(context),
                    )
                  : _buildPlaceholderImage(context),
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
                          widget.servicio.estado ? 'Disponible' : 'No disponible',
                          style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      Spacer(),
                      Text('S/. ${widget.servicio.precioReferencial}', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 22)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(widget.servicio.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  SizedBox(height: 6),
                  Text(widget.servicio.descripcion, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text('Capacidad: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${widget.servicio.capacidad} personas'),
                      SizedBox(width: 18),
                      Icon(Icons.location_on, color: Colors.orange, size: 20),
                      SizedBox(width: 6),
                      Text('Ubicación: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(widget.servicio.ubicacionReferencia, maxLines: 2, overflow: TextOverflow.ellipsis)),
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
                            Text(widget.servicio.emprendedor.nombre, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            Text(widget.servicio.emprendedor.tipoServicio, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                            Text(widget.servicio.emprendedor.ubicacion, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                    children: widget.servicio.horarios.map((h) => Container(
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
                            backgroundColor: Color(0xFF25D366), // Verde WhatsApp
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                          label: Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            final telefono = widget.servicio.emprendedor.telefono;
                            if (telefono != null && telefono.isNotEmpty) {
                              final url = 'https://wa.me/$telefono';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                Get.snackbar('Error', 'No se pudo abrir WhatsApp', backgroundColor: Colors.red, colorText: Colors.white);
                              }
                            } else {
                              Get.snackbar('Sin número', 'El emprendedor no tiene número de WhatsApp disponible', backgroundColor: Colors.orange, colorText: Colors.white);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Obx(() => ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: Icon(Icons.login, color: Colors.white),
                          label: Text(authService.isLoggedInRx.value ? 'Confirmar Reserva' : 'Reservar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () => _handleReservar(context, authService.isLoggedInRx.value),
                        )),
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

  void _handleReservar(BuildContext context, bool isLoggedIn) async {
    final authService = Get.find<AuthService>();
    final reservaService = Get.find<ReservaService>();
    final box = GetStorage();
    final currentRoute = '/services-capachica/detail/${widget.servicio.id}';

    if (!isLoggedIn) {
      // Guardar ruta pendiente y mostrar diálogo de login
      box.write('pending_route', currentRoute);
      Get.dialog(AuthRedirectDialog(
        onLoginPressed: () {
          Get.toNamed('/login');
        },
        onRegisterPressed: () {
          Get.toNamed('/register');
        },
      ));
      return;
    }

    // Mostrar diálogo de confirmación de reserva
    final fechaController = TextEditingController(text: DateTime.now().toIso8601String().split('T')[0]);
    final horaInicioController = TextEditingController(text: '09:00');
    final horaFinController = TextEditingController(text: '10:00');
    final notasController = TextEditingController();
    final cantidadController = TextEditingController(text: '1');
    final duracionController = TextEditingController(text: '60');

    bool horarioDisponible = false;
    String disponibilidadMensaje = '';
    bool consultado = false;

    await Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          void resetDisponibilidad() {
            setState(() {
              consultado = false;
              horarioDisponible = false;
              disponibilidadMensaje = '';
            });
          }
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Confirmar Reserva'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fechaController,
                    decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                    onChanged: (_) => resetDisponibilidad(),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: horaInicioController,
                    decoration: InputDecoration(labelText: 'Hora Inicio (HH:MM)'),
                    onChanged: (_) => resetDisponibilidad(),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: horaFinController,
                    decoration: InputDecoration(labelText: 'Hora Fin (HH:MM)'),
                    onChanged: (_) => resetDisponibilidad(),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: cantidadController,
                    decoration: InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: duracionController,
                    decoration: InputDecoration(labelText: 'Duración (minutos)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: notasController,
                    decoration: InputDecoration(labelText: 'Notas (opcional)'),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        consultado = false;
                        disponibilidadMensaje = '';
                        horarioDisponible = false;
                      });
                      List<Map<String, dynamic>> reservas = [];
                      try {
                        reservas = await reservaService.obtenerMisReservas();
                      } catch (e) {
                        // Si hay error (404, etc), asumimos que no hay reservas y el horario está disponible
                        setState(() {
                          consultado = true;
                          horarioDisponible = true;
                          disponibilidadMensaje = 'Horario disponible';
                        });
                        return;
                      }
                      final fecha = fechaController.text.trim();
                      final horaInicio = horaInicioController.text.trim();
                      final horaFin = horaFinController.text.trim();
                      bool disponible = true;
                      for (final r in reservas) {
                        if (r['fechaInicio'] == fecha) {
                          // Si hay cruce de horas
                          if (!(horaFin.compareTo(r['horaInicio']) <= 0 || horaInicio.compareTo(r['horaFin']) >= 0)) {
                            disponible = false;
                            break;
                          }
                        }
                      }
                      setState(() {
                        consultado = true;
                        horarioDisponible = disponible;
                        disponibilidadMensaje = disponible ? 'Horario disponible' : 'Horario no disponible';
                      });
                    },
                    child: Text('Ver disponibilidad de horarios'),
                  ),
                  if (consultado)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        disponibilidadMensaje,
                        style: TextStyle(
                          color: horarioDisponible ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: (consultado && horarioDisponible)
                    ? () async {
                        try {
                          final cartController = Get.find<CartController>();
                          final reserva = {
                            'id': DateTime.now().millisecondsSinceEpoch,
                            'servicioId': widget.servicio.id,
                            'emprendedorId': widget.servicio.emprendedorId,
                            'fechaInicio': fechaController.text,
                            'fechaFin': fechaController.text,
                            'horaInicio': horaInicioController.text,
                            'horaFin': horaFinController.text,
                            'duracionMinutos': int.tryParse(duracionController.text) ?? 60,
                            'cantidad': int.tryParse(cantidadController.text) ?? 1,
                            'notasCliente': notasController.text.isNotEmpty ? notasController.text : null,
                            'estado': 'pendiente',
                            'metodoPago': null,
                            'precioTotal': double.tryParse(widget.servicio.precioReferencial) ?? 0,
                            'createdAt': DateTime.now().toIso8601String(),
                            'servicio': {
                              'id': widget.servicio.id,
                              'nombre': widget.servicio.nombre,
                              'descripcion': widget.servicio.descripcion,
                              'precioReferencial': double.tryParse(widget.servicio.precioReferencial) ?? 0,
                              'imagenUrl': '', // ServicioCapachica no tiene imagenUrl
                            },
                            'emprendedor': {
                              'id': widget.servicio.emprendedor.id,
                              'nombre': widget.servicio.emprendedor.nombre,
                              'tipoServicio': widget.servicio.emprendedor.tipoServicio,
                            },
                          };
                          await cartController.agregarReserva(reserva);
                          Get.back();
                          // Mostrar diálogo de confirmación después de cerrar el formulario
                          Future.delayed(const Duration(milliseconds: 300), () {
                            cartController.mostrarDialogoConfirmacion();
                          });
                        } catch (e) {
                          Get.snackbar('Error', 'No se pudo agregar la reserva: $e', backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      }
                    : null,
                child: Text('Agregar al Carrito'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.orange[100],
      child: Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: Colors.orange[300],
        ),
      ),
    );
  }
} 