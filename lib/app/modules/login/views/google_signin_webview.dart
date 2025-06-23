import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/login_model.dart';

class GoogleSignInWebView extends StatefulWidget {
  @override
  _GoogleSignInWebViewState createState() => _GoogleSignInWebViewState();
}

class _GoogleSignInWebViewState extends State<GoogleSignInWebView> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            print('[WebView] Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('[WebView] Page finished loading: $url');

            // El backend, tras el callback de Google, debería redirigir a una URL
            // que contenga el token de sesión de la app.
            if (url.contains('your_app_token=')) { // CAMBIAR ESTO
              _handleAuthSuccess(url);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print('[WebView] Intercepting navigation to: ${request.url}');
            if (request.url.contains('your_app_token=')) { // CAMBIAR ESTO
              _handleAuthSuccess(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _loadInitialUrl();
  }

  Future<void> _loadInitialUrl() async {
    try {
      final response = await _authProvider.getGoogleSignInUrl();
      if (response.statusCode == 200 && response.body['data']['url'] != null) {
        String authUrl = response.body['data']['url'];
        // Reemplazar las barras invertidas escapadas
        authUrl = authUrl.replaceAll(r'\/', '/');
        print('[WebView] URL de autenticación obtenida: $authUrl');
        _webViewController.loadRequest(Uri.parse(authUrl));
      } else {
        throw 'No se pudo obtener la URL de autenticación de Google del backend.';
      }
    } catch (e) {
      print('[WebView] Error al cargar la URL inicial: $e');
      Get.snackbar(
        'Error de Red',
        'No se pudo conectar con el servidor para iniciar sesión con Google.',
        backgroundColor: Color(0xFFFF9100),
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  void _handleAuthSuccess(String url) async {
    try {
      // Extraer el token de la URL
      Uri uri = Uri.parse(url);
      String? token = uri.queryParameters['token'] ??
          uri.queryParameters['access_token'] ??
          uri.fragment.split('access_token=').last.split('&').first;

      if (token != null) {
        print('[GoogleSignInWebView] Token obtenido: $token');

        // Enviar el token al backend
        final response = await _authProvider.verifyGoogleToken(token);

        if (response.status.hasError) {
          throw 'Error en la autenticación: ${response.statusText}';
        }

        final loginResponse = response.body;
        if (loginResponse?.token == null) {
          throw 'No se recibió token de sesión del servidor';
        }

        // Iniciar sesión
        await _authService.login(loginResponse!);

        Get.rawSnackbar(
          message: 'Inicio de sesión con Google exitoso',
          backgroundColor: Color(0xFFFF9100),
          borderRadius: 12,
          margin: EdgeInsets.all(16),
        );

        Get.back(); // Cerrar WebView
        Get.back(); // Volver a la pantalla anterior
      }
    } catch (e) {
      print('[GoogleSignInWebView] Error: $e');
      Get.snackbar(
        'Error',
        'No se pudo completar la autenticación: $e',
        backgroundColor: Color(0xFFFF9100),
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión con Google'),
        backgroundColor: Color(0xFFFF9100),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9100)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando autenticación de Google...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
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
}