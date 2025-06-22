import 'package:get/get.dart';
import '../models/login_model.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://127.0.0.1:8000/api';
    httpClient.timeout = Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }

  Future<Response<LoginResponse>> login(LoginRequest loginRequest) async {
    return await post<LoginResponse>(
      '/login',
      loginRequest.toJson(),
      decoder: (data) => LoginResponse.fromJson(data),
    );
  }
}