import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:flutter/foundation.dart';
import 'exceptions.dart';
import 'failure.dart';

Future<Either<Failure, T>> guardCall<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(
      e.message,
      statusCode: e.statusCode,
      fieldErrors: e.fieldErrors,
    ));
  } catch (e, s) {
    debugPrint('guardCall error: $e\n$s');
    return Left(const UnexpectedFailure('Terjadi kesalahan tak terduga.'));
  }
}