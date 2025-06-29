import 'package:get/get.dart';
import '../../../services/municipalidad_service.dart';
import '../../../data/repositories/municipalidad_repository_impl.dart';
import '../../../domain/repositories/municipalidad_repository.dart';
import '../../../domain/usecases/get_resumen_usecase.dart';

class ResumenController extends GetxController {
  // Servicios y casos de uso para el resumen
  late final MunicipalidadService _municipalidadService;
  late final MunicipalidadRepository _municipalidadRepository;
  late final GetResumenUseCase _getResumenUseCase;

  // Variables observables para el resumen
  final isLoading = false.obs;
  final resumenData = Rxn<ResumenData>();
  final resumenError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    print('ResumenController inicializado');
    
    // Inicializar servicios y casos de uso
    _municipalidadService = MunicipalidadService();
    _municipalidadRepository = MunicipalidadRepositoryImpl(_municipalidadService);
    _getResumenUseCase = GetResumenUseCase(_municipalidadRepository);
    
    // Cargar datos automáticamente al inicializar
    loadResumen();
  }

  @override
  void onClose() {
    _municipalidadService.dispose();
    super.onClose();
  }

  /// Carga los datos del resumen usando el caso de uso
  void loadResumen() async {
    try {
      print('📊 ResumenController: Iniciando carga del resumen...');
      
      // Limpiar errores previos y establecer estado de carga
      resumenError.value = null;
      isLoading.value = true;
      
      // Ejecutar el caso de uso
      final data = await _getResumenUseCase.execute();
      
      // Actualizar los datos
      resumenData.value = data;
      isLoading.value = false;
      
      print('✅ ResumenController: Resumen cargado exitosamente');
      print('📊 ResumenController: Resumen cargado con:');
      print('   - Sliders: ${data.sliders.length}');
      print('   - Municipalidades: ${data.municipalidades.length}');
      print('   - Primera municipalidad con detalles: ${data.primeraMunicipalidadDetalle != null}');
      
    } catch (e) {
      print('❌ ResumenController: Error cargando resumen: $e');
      
      // Actualizar estado de error
      resumenError.value = e.toString();
      isLoading.value = false;
    }
  }
} 