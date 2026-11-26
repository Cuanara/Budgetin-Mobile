import 'package:dartz/dartz.dart' show Either, Unit;
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => repository.logout();
}