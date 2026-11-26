import 'package:budgetin_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:budgetin_mobile/features/auth/presentation/screens/password_updated_screen.dart';
import 'package:budgetin_mobile/features/auth/presentation/screens/reset_link_sent_screen.dart';
import 'package:budgetin_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:budgetin_mobile/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:budgetin_mobile/features/dashboard/presentation/screen/home_screen.dart';
import 'package:budgetin_mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => const VerifyEmailScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordSent,
      page: () => const ResetLinkSentScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.passwordUpdated,
      page: () => const PasswordUpdatedScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: AuthBinding(),
    ),
  ];
}
