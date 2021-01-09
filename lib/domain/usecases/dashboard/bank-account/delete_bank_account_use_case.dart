import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

import '../../use_case.dart';

class DeleteBankAccountUseCase extends UseCase {
  final BankAccountRepository bankAccountRepository;
  final DefaultWalletRepository defaultWalletRepository;

  DeleteBankAccountUseCase(
      {@required this.bankAccountRepository,
      @required this.defaultWalletRepository});

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return await bankAccountRepository.delete(
        defaultWallet.getOrElse(null), itemId);
  }
}
