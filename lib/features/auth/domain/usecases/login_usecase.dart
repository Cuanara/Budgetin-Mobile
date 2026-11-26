import 'package:dartz/dartz.dart' show Either, Unit;
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
    required this.remember,
  });

  final String email;
  final String password;
  final bool remember;
}

class LoginUseCase implements UseCase<Unit, LoginParams> {
  LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(LoginParams p) =>
      repository.login(email: p.email, password: p.password, remember: p.remember);
}