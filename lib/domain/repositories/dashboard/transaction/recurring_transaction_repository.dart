import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';

mixin RecurringTransactionRepository {
  Future<Either<Failure, void>> update(
      RecurringTransaction updateRecurringTransaction);
}
