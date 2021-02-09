import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/fetch_goal_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

class MockEndsWithDateRepository extends Mock
    implements EndsWithDateRepository {}

class MockStartsWithDateRepository extends Mock
    implements StartsWithDateRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  FetchGoalUseCase fetchGoalUseCase;
  MockGoalRepository mockGoalRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;
  MockEndsWithDateRepository mockEndsWithDateRepository;
  MockStartsWithDateRepository mockStartsWithDateRepository;
  MockUserAttributesRepository mockUserAttributesRepository;

  final goalModelAsString =
      fixture('models/get/goal/emergency_fund_model.json');
  final goalModelAsJSON = jsonDecode(goalModelAsString) as Map<String, dynamic>;
  final goal = GoalModel(
      walletId: goalModelAsJSON['walletId'] as String,
      goalId: goalModelAsJSON['goalId'] as String,
      goalType: parseDynamicAsGoalType(goalModelAsJSON['goal_type']),
      targetType: parseDynamicAsTargetType(goalModelAsJSON['target_type']),
      monthlyContribution:
          parseDynamicAsDouble(goalModelAsJSON['monthly_contribution']),
      targetAmount: parseDynamicAsDouble(goalModelAsJSON['final_amount']),
      targetDate: goalModelAsJSON['preferable_target_date'] as String,
      targetId: goalModelAsJSON['target_id'] as String);

  final goalResponseModelAsString =
      fixture('responses/dashboard/goal/fetch_goal_info.json');
  final goalResponseModelAsJSON =
      jsonDecode(goalResponseModelAsString) as Map<String, dynamic>;

  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  var goalResponseModel = convertToResponseModel(goalResponseModelAsJSON);

  setUp(() {
    mockGoalRepository = MockGoalRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    mockEndsWithDateRepository = MockEndsWithDateRepository();
    mockStartsWithDateRepository = MockStartsWithDateRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    fetchGoalUseCase = FetchGoalUseCase(
        goalRepository: mockGoalRepository,
        defaultWalletRepository: mockDefaultWalletRepository,
        endsWithDateRepository: mockEndsWithDateRepository,
        startsWithDateRepository: mockStartsWithDateRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Fetch', () {
    var now = DateTime.now();
    var dateString = now.toIso8601String();
    final userId = 'User#2020-12-21T20:32:06.003Z';

    test('Success', () async {
      Either<Failure, void> addGoalMonad = Right<Failure, void>('');
      Either<Failure, String> dateStringMonad =
          Right<Failure, String>(dateString);

      when(mockGoalRepository.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      Either<Failure, GoalResponse> fetchGoalMonad =
          Right<Failure, GoalResponse>(goalResponseModel);

      when(mockGoalRepository.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: dateString,
              userId: null))
          .thenAnswer((_) => Future.value(fetchGoalMonad));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isRight(), true);
      verify(mockGoalRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: dateString,
          userId: null));
    });

    test('Default Wallet Empty: Failure', () async {
      Either<Failure, void> addGoalMonad = Right<Failure, void>('');
      final user = User(userId: userId);
      Either<Failure, User> userMonad = Right<Failure, User>(user);
      Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());

      when(mockGoalRepository.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      Either<Failure, GoalResponse> fetchGoalMonad =
          Right<Failure, GoalResponse>(goalResponseModel);

      when(mockGoalRepository.fetch(
              startsWithDate: dateString,
              endsWithDate: dateString,
              defaultWallet: null,
              userId: userId))
          .thenAnswer((_) => Future.value(fetchGoalMonad));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isRight(), true);
      verify(mockGoalRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });

    test('Default Wallet Empty && User Attribute Failure: Failure', () async {
      Either<Failure, void> addGoalMonad = Right<Failure, void>('');
      Either<Failure, String> dateFailure =
          Left<Failure, String>(FetchDataFailure());
      Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());

      when(mockGoalRepository.add(goal))
          .thenAnswer((_) => Future.value(addGoalMonad));
      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateFailure));
      when(mockEndsWithDateRepository.readEndsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockStartsWithDateRepository.readStartsWithDate())
          .thenAnswer((_) => Future.value(dateString));
      when(mockUserAttributesRepository.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final goalResponse = await fetchGoalUseCase.fetch();

      expect(goalResponse.isLeft(), true);
      verifyNever(mockGoalRepository.fetch(
          startsWithDate: dateString,
          endsWithDate: dateString,
          defaultWallet: null,
          userId: userId));
    });
  });
}

GoalResponseModel convertToResponseModel(
    Map<String, dynamic> goalResponseModelAsJSON) {
  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  var responseGoals = goalResponseModelAsJSON['Goal'] as List;
  var convertedGoals = List<Goal>.from(responseGoals?.map<dynamic>(
          (dynamic model) =>
              GoalModel.fromJSON(model as Map<String, dynamic>)) ??
      <Goal>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  var responseBankAccounts = goalResponseModelAsJSON['BankAccount'] as List;
  var convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  var responseDate = goalResponseModelAsJSON['Date'] as List;
  var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model as Map<String, dynamic>)) ??
      <Date>[]);

  dynamic responseWallet = goalResponseModelAsJSON['Wallet'];
  Wallet convertedWallet;

  /// Check if the response is a string or a list
  ///
  /// If string then convert them into a wallet
  /// If List then convert them into list of wallets and take the first wallet.
  if (responseWallet is Map) {
    convertedWallet =
        WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
  } else if (responseWallet is List) {
    var convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
        (dynamic model) =>
            WalletModel.fromJSON(model as Map<String, dynamic>)));

    convertedWallet = convertedWallets[0];
  }

  final goalResponseModel = GoalResponseModel(
      goals: convertedGoals,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
  return goalResponseModel;
}
