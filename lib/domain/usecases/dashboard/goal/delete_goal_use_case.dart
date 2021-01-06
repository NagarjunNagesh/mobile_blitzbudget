import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

class DeleteGoalUseCase {
  DeleteItemRepository deleteItemRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return await deleteItemRepository.delete(
        defaultWallet.getOrElse(null), itemId);
  }
}