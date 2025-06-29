import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_screen.dart';
import '../modules/login/views/google_signin_webview.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_screen.dart';
import '../modules/services_capachica/bindings/services_capachica_binding.dart';
import '../modules/services_capachica/views/services_capachica_screen.dart';
import '../modules/resumen/bindings/resumen_binding.dart';
import '../modules/resumen/views/resumen_screen.dart';
import '../modules/planes/bindings/planes_binding.dart';
import '../modules/planes/views/planes_screen.dart';
import '../modules/planes/bindings/plan_detalle_binding.dart';
import '../modules/planes/views/plan_detalle_screen.dart';
import 'app_routes.dart';

class FadeScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transitionDuration: const Duration(milliseconds: 600),
      customTransition: FadeScaleTransition(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.GOOGLE_SIGNIN_WEBVIEW,
      page: () => GoogleSignInWebView(),
    ),
    GetPage(
      name: AppRoutes.SERVICES_CAPACHICA,
      page: () => ServicesCapachicaScreen(),
      binding: ServicesCapachicaBinding(),
    ),
    GetPage(
      name: AppRoutes.RESUMEN,
      page: () => ResumenScreen(),
      binding: ResumenBinding(),
      transitionDuration: const Duration(milliseconds: 400),
      customTransition: FadeScaleTransition(),
    ),
    GetPage(
      name: AppRoutes.PLANES,
      page: () => PlanesScreen(),
      binding: PlanesBinding(),
      transitionDuration: const Duration(milliseconds: 400),
      customTransition: FadeScaleTransition(),
    ),
    GetPage(
      name: AppRoutes.PLAN_DETALLE,
      page: () => PlanDetalleScreen(),
      binding: PlanDetalleBinding(),
      transitionDuration: const Duration(milliseconds: 400),
      customTransition: FadeScaleTransition(),
    ),
  ];
}

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const GOOGLE_SIGNIN_WEBVIEW = _Paths.GOOGLE_SIGNIN_WEBVIEW;
  static const SERVICES_CAPACHICA = _Paths.SERVICES_CAPACHICA;
  static const RESUMEN = _Paths.RESUMEN;
  static const PLANES = _Paths.PLANES;
  static const PLAN_DETALLE = _Paths.PLAN_DETALLE;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const GOOGLE_SIGNIN_WEBVIEW = '/google-signin-webview';
  static const SERVICES_CAPACHICA = '/services-capachica';
  static const RESUMEN = '/resumen';
  static const PLANES = '/planes';
  static const PLAN_DETALLE = '/plan-detalle';
}
