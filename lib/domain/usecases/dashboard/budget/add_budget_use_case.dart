import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

import '../../use_case.dart';

class AddBudgetUseCase extends UseCase {
  final BudgetRepository budgetRepository;

  AddBudgetUseCase({@required this.budgetRepository});
  Future<Either<Failure, void>> add({@required Budget addBudget}) async {
    return await budgetRepository.add(addBudget);
  }
}
