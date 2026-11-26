import 'package:dartz/dartz.dart' show Either, Unit;
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  RegisterUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(RegisterParams p) =>
      repository.register(name: p.name, email: p.email, password: p.password);
}