import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<AuthRepository>();
    Get.lazyPut(() => LoginUseCase(repo));
    Get.lazyPut(() => RegisterUseCase(repo));
    Get.lazyPut(() => LogoutUseCase(repo));
    Get.lazyPut(
      () => AuthController(
        loginUseCase: Get.find(),
        registerUseCase: Get.find(),
        logoutUseCase: Get.find(),
      ),
    );
  }
}