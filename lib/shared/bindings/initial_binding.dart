import 'package:budgetin_mobile/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/dio_client.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final prefs = Get.find<SharedPreferences>();
    final dioClient = DioClient(token: prefs.getString(AppConstants.tokenKey));

    Get.put<DioClient>(dioClient, permanent: true);
    Get.put<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(dioClient.dio),
      permanent: true,
    );
    Get.put<AuthLocalDataSource>(AuthLocalDataSourceImpl(prefs), permanent: true);
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remote: Get.find<AuthRemoteDataSource>(),
        local: Get.find<AuthLocalDataSource>(),
        dioClient: dioClient,
      ),
      permanent: true,
    );
  }
}