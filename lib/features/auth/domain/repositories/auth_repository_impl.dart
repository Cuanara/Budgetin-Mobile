import 'package:budgetin_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:budgetin_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dartz/dartz.dart' show Either, Right, Unit, unit;
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.dioClient,
  });

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final DioClient dioClient;

  @override
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
    required bool remember,
  }) {
    return guardCall(() async {
      final res = await remote.login(email, password);
      dioClient.setToken(res.accessToken);
      if (remember) {
        await local.saveToken(res.accessToken);
      } else {
        await local.clearToken();
      }
      return unit;
    });
  }

  @override
Future<Either<Failure, Unit>> register({
  required String name,
  required String email,
  required String password,
}) {
  return guardCall(() async {
    await remote.register(name, email, password);
    return unit;
  });
}

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remote.logout();
    } catch (_) {
      // tetap lanjut: token lokal harus dihapus walau request gagal
    }
    await local.clearToken();
    dioClient.setToken(null);
    return const Right(unit);
  }
}