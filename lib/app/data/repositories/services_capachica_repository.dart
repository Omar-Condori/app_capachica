import '../models/services_capachica_model.dart';
import '../providers/services_capachica_provider.dart';

class ServicesCapachicaRepository {
  final ServicesCapachicaProvider provider;

  ServicesCapachicaRepository(this.provider);

  Future<List<ServicioCapachica>> getServicios() async {
    return await provider.fetchServicios();
  }
} 