import 'package:get/get.dart';

import 'package:auth_ui_app/features/authentication/screens/login/login.dart';
import 'package:auth_ui_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:auth_ui_app/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:auth_ui_app/features/authentication/screens/splash/splash.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_dashboard.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_dashboard_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String forgetPassword = '/forget-password';
  static const String dashboard = '/dashboard';
  static const String managerDashboard = '/manager-dashboard';

  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/splash', page: () => const SplashScreen()),
    GetPage(name: '/SplashScreen', page: () => const SplashScreen()),
    GetPage(name: '/onboarding', page: () => const OnBoardingScreen()),
    GetPage(name: '/OnBoardingScreen', page: () => const OnBoardingScreen()),
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/LoginScreen', page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => const LoginScreen()), // Redirect to login
    GetPage(name: '/SignupScreen', page: () => const LoginScreen()), // Redirect to login
    GetPage(name: '/forget-password', page: () => const ForgetPasswordScreen()),
    GetPage(name: '/ForgetPasswordScreen', page: () => const ForgetPasswordScreen()),
    GetPage(name: '/dashboard', page: () => const HrmDashboardScreen()),
    GetPage(name: '/HrmDashboardScreen', page: () => const HrmDashboardScreen()),
    GetPage(name: '/manager-dashboard', page: () => const ManagerDashboardScreen()),
    GetPage(name: '/ManagerDashboardScreen', page: () => const ManagerDashboardScreen()),
  ];
}
