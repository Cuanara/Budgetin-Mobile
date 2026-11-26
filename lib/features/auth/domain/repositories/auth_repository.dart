import 'package:dartz/dartz.dart' show Either, Unit;
import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
    required bool remember,
  });

  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();
}