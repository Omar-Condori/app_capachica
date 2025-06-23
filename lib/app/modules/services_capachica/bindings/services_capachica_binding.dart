import 'package:get/get.dart';
import '../../../data/providers/services_capachica_provider.dart';
import '../../../data/repositories/services_capachica_repository.dart';
import '../controllers/services_capachica_controller.dart';

class ServicesCapachicaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicesCapachicaProvider(baseUrl: 'http://10.0.2.2:8000/api'));
    Get.lazyPut(() => ServicesCapachicaRepository(Get.find()));
    Get.lazyPut(() => ServicesCapachicaController(Get.find()));
  }
} 