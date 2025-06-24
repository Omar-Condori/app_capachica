import 'package:get/get.dart';
import '../../../data/models/services_capachica_model.dart';
import '../../../data/repositories/services_capachica_repository.dart';

class ServicesCapachicaController extends GetxController {
  final ServicesCapachicaRepository repository;
  ServicesCapachicaController(this.repository);

  var servicios = <ServicioCapachica>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServicios();
  }

  void fetchServicios() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await repository.getServicios();
      servicios.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
} 