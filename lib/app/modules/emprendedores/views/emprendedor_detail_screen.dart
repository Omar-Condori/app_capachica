import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/emprendedor_model.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cart_bottom_sheet.dart';
import '../../../core/controllers/cart_controller.dart';
import '../controllers/emprendedores_controller.dart';
import '../../../core/widgets/cart_icon_with_badge.dart';

class EmprendedorDetailScreen extends StatefulWidget {
  final Emprendedor emprendedor;
  
  const EmprendedorDetailScreen({
    Key? key,
    required this.emprendedor,
  }) : super(key: key);

  @override
  State<EmprendedorDetailScreen> createState() => _EmprendedorDetailScreenState();
}

class _EmprendedorDetailScreenState extends State<EmprendedorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoadingServicios = false;
  bool _isLoadingRelaciones = false;
  List<ServicioEmprendedor> _servicios = [];
  List<RelacionEmprendedor> _relaciones = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAdditionalData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAdditionalData() async {
    await Future.wait([
      _loadServicios(),
      _loadRelaciones(),
    ]);
  }

  Future<void> _loadServicios() async {
    setState(() {
      _isLoadingServicios = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _servicios = widget.emprendedor.servicios ?? [];
        _isLoadingServicios = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar servicios: $e';
        _isLoadingServicios = false;
      });
    }
  }

  Future<void> _loadRelaciones() async {
    setState(() {
      _isLoadingRelaciones = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _relaciones = widget.emprendedor.relaciones ?? [];
        _isLoadingRelaciones = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar relaciones: $e';
        _isLoadingRelaciones = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.emprendedor.nombre,
          style: AppTheme.lightTextTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          const CartIconWithBadge(),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Información'),
            Tab(text: 'Servicios'),
            Tab(text: 'Contacto'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInformacionTab(),
          _buildServiciosTab(),
          _buildContactoTab(),
        ],
      ),
    );
  }

  Widget _buildInformacionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmprendedorImage(),
          const SizedBox(height: 20),
          _buildBasicInfo(),
          const SizedBox(height: 20),
          if (widget.emprendedor.descripcion != null && widget.emprendedor.descripcion!.isNotEmpty)
            _buildDescription(),
          const SizedBox(height: 20),
          _buildStatusCard(),
          const SizedBox(height: 20),
          if (_relaciones.isNotEmpty) _buildRelacionesSection(),
        ],
      ),
    );
  }

  Widget _buildEmprendedorImage() {
    String? imagenUrl;
    
    try {
      if (widget.emprendedor.imagen != null && widget.emprendedor.imagen!.isNotEmpty) {
        imagenUrl = widget.emprendedor.imagen;
      } else if (widget.emprendedor.imagenes != null && widget.emprendedor.imagenes!.isNotEmpty) {
        final imgs = widget.emprendedor.imagenes!;
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

    bool isValidUrl(String? url) {
      return url != null && (url.startsWith('http://') || url.startsWith('https://'));
    }

    if (!isValidUrl(imagenUrl)) {
      imagenUrl = 'https://via.placeholder.com/400x200.png?text=🏪';
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imagenUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.store,
              color: AppColors.primary,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.emprendedor.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.category, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.emprendedor.tipoServicio,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.emprendedor.ubicacion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
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

  Widget _buildDescription() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.emprendedor.descripcion!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: widget.emprendedor.estado ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.emprendedor.estado ? 'Emprendedor Activo' : 'Emprendedor Inactivo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.emprendedor.estado ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelacionesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Información Adicional',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._relaciones.map((relacion) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${relacion.tipo}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      relacion.valor,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildServiciosTab() {
    if (_isLoadingServicios) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando servicios...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_servicios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay servicios disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Este emprendedor aún no ha registrado servicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _servicios.length,
      itemBuilder: (context, index) {
        final servicio = _servicios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        servicio.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: servicio.estado ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        servicio.estado ? 'Disponible' : 'No disponible',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: servicio.estado ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  servicio.descripcion,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'S/. ${servicio.precioReferencial}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${servicio.capacidad} personas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        servicio.ubicacionReferencia,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (servicio.categorias.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: servicio.categorias.map((categoria) => Chip(
                      label: Text(
                        categoria.nombre,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_phone, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Información de Contacto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (widget.emprendedor.telefono != null && widget.emprendedor.telefono!.isNotEmpty)
                    _buildContactItem(
                      Icons.phone,
                      'Teléfono',
                      widget.emprendedor.telefono!,
                      () => _makePhoneCall(widget.emprendedor.telefono!),
                    ),
                  
                  if (widget.emprendedor.email != null && widget.emprendedor.email!.isNotEmpty)
                    _buildContactItem(
                      Icons.email,
                      'Email',
                      widget.emprendedor.email!,
                      () => _sendEmail(widget.emprendedor.email!),
                    ),
                  
                  _buildContactItem(
                    Icons.location_on,
                    'Ubicación',
                    widget.emprendedor.ubicacion,
                    () => _openLocation(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _contactEmprendedor(),
                      icon: const Icon(Icons.message),
                      label: const Text('Contactar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _shareEmprendedor(),
                      icon: const Icon(Icons.share),
                      label: const Text('Compartir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phone) {
    Get.snackbar(
      'Llamar',
      'Llamando a $phone',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  void _sendEmail(String email) {
    Get.snackbar(
      'Email',
      'Enviando email a $email',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  void _openLocation() {
    Get.snackbar(
      'Ubicación',
      'Abriendo ubicación en mapa',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  void _contactEmprendedor() {
    Get.snackbar(
      'Contacto',
      'Contactando con ${widget.emprendedor.nombre}',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  void _shareEmprendedor() {
    Get.snackbar(
      'Compartir',
      'Compartiendo información de ${widget.emprendedor.nombre}',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }
} 