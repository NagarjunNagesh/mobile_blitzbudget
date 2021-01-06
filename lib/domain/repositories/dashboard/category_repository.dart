import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

abstract class CategoryRepository {
  Future<Either<Failure, void>> delete(String walletId, String category);
}