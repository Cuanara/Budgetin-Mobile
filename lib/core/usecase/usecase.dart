import 'package:dartz/dartz.dart' show Either;
import '../errors/failure.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams {
  const NoParams();
}