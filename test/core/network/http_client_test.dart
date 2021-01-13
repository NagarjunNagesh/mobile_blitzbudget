import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/network/network_helper.dart';
import 'package:mobile_blitzbudget/core/network/refresh_token_helper.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';

import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../fixtures/fixture_reader.dart';

class MockNetworkHelper extends Mock implements NetworkHelper {}

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

class MockAuthTokenRepository extends Mock implements AuthTokenRepository {}

class MockRefreshTokenHelper extends Mock implements RefreshTokenHelper {}

void main() {
  MockNetworkHelper mockNetworkHelper;
  HTTPClientImpl httpClientImpl;
  MockAccessTokenRepository mockAccessTokenRepository;
  MockAuthTokenRepository mockAuthTokenRepository;
  MockRefreshTokenHelper mockRefreshTokenHelper;
  final authTokenString =
      'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6IjdlMTRmZGViLWMyODEtNDZlMC1hM2EwLTU4ZTM1ZDY0NzQyZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MDk3NzM0MjAsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYwOTc3NzAyMCwiaWF0IjoxNjA5NzczNDIwLCJqdGkiOiIxN2EzMjM0Yy0xMWZkLTRhNDItYWIzYi05MGVhM2VhOWI3M2IiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.npmtjthQi53SSX9R2xRzuOEcsXXyD-YuQsdGwOoscbfg-f1HJ7-4SJH7KZFzUTTerQXli-82nlr9OeCoG7gWf0SSXim1O7pw2HiT5zLkmNETY-AH2uuTfJheqx85QHl55qiFfK9PfrP7JBoxb0YPYkGoquD1vR1rtEjXtXasYNknM8FyKxfr35fCW1CBFLdwPdp-5QKYh_ahIf3EVsDB7qD9-j3AvkYTAwSAhwuPAFRAcRTXRNc8XdX7sfIvFRcul4tVENdqNF5Im0bUPfWkuvaINbaRRL6gX_0Syjlfe4tzTNKXT3Xz4_CxqH5lSJOHwivcYecv7XQrDljewjNBCQ';

  setUp(() {
    mockNetworkHelper = MockNetworkHelper();
    mockAccessTokenRepository = MockAccessTokenRepository();
    mockAuthTokenRepository = MockAuthTokenRepository();
    mockRefreshTokenHelper = MockRefreshTokenHelper();
    httpClientImpl = HTTPClientImpl(
        accessTokenRepository: mockAccessTokenRepository,
        authTokenRepository: mockAuthTokenRepository,
        networkHelper: mockNetworkHelper,
        refreshTokenHelper: mockRefreshTokenHelper);

    /// Auth Token mocking
    Either<Failure, String> authEither =
        Right<Failure, String>(authTokenString);
    when(mockAuthTokenRepository.readAuthToken())
        .thenAnswer((_) => Future.value(authEither));
  });

  group('Attempt to make a valid API call', () {
    test(
      'Valid POST call',
      () async {
        final addBudgetAsString =
            fixture('responses/dashboard/budget/add_budget_info.json');
        final addBudgetAsJSON =
            jsonDecode(addBudgetAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId: addBudgetAsJSON['body-json']['walletId'] as String,
            budgetId: addBudgetAsJSON['body-json']['accountId'] as String,
            categoryType: parseDynamicAsCategoryType(
                addBudgetAsJSON['body-json']['categoryType']),
            planned:
                parseDynamicAsDouble(addBudgetAsJSON['body-json']['planned']),
            dateMeantFor:
                addBudgetAsJSON['body-json']['dateMeantFor'] as String);
        // arrange
        when(mockNetworkHelper.post(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async =>
                Future.value(http.Response(addBudgetAsString, 200)));
        // act
        await httpClientImpl.post(constants.budgetURL,
            headers: constants.headers, body: jsonEncode(budget.toJSON()));
        // assert
        verify(mockNetworkHelper.post(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Valid PUT call',
      () async {
        final addBudgetAsString =
            fixture('responses/dashboard/budget/add_budget_info.json');
        final addBudgetAsJSON =
            jsonDecode(addBudgetAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId: addBudgetAsJSON['body-json']['walletId'] as String,
            budgetId: addBudgetAsJSON['body-json']['accountId'] as String,
            categoryType: parseDynamicAsCategoryType(
                addBudgetAsJSON['body-json']['categoryType']),
            planned:
                parseDynamicAsDouble(addBudgetAsJSON['body-json']['planned']),
            dateMeantFor:
                addBudgetAsJSON['body-json']['dateMeantFor'] as String);
        // arrange
        when(mockNetworkHelper.put(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async =>
                Future.value(http.Response(addBudgetAsString, 200)));
        // act
        await httpClientImpl.put(constants.budgetURL,
            headers: constants.headers, body: jsonEncode(budget.toJSON()));
        // assert
        verify(mockNetworkHelper.put(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Valid PATCH call',
      () async {
        final addBudgetAsString =
            fixture('responses/dashboard/budget/add_budget_info.json');
        final addBudgetAsJSON =
            jsonDecode(addBudgetAsString) as Map<String, dynamic>;
        final budget = BudgetModel(
            walletId: addBudgetAsJSON['body-json']['walletId'] as String,
            budgetId: addBudgetAsJSON['body-json']['accountId'] as String,
            categoryType: parseDynamicAsCategoryType(
                addBudgetAsJSON['body-json']['categoryType']),
            planned:
                parseDynamicAsDouble(addBudgetAsJSON['body-json']['planned']),
            dateMeantFor:
                addBudgetAsJSON['body-json']['dateMeantFor'] as String);
        // arrange
        when(mockNetworkHelper.patch(constants.budgetURL,
                body: jsonEncode(budget.toJSON()), headers: constants.headers))
            .thenAnswer((_) async =>
                Future.value(http.Response(addBudgetAsString, 200)));
        // act
        await httpClientImpl.patch(constants.budgetURL,
            headers: constants.headers, body: jsonEncode(budget.toJSON()));
        // assert
        verify(mockNetworkHelper.patch(constants.budgetURL,
            body: jsonEncode(budget.toJSON()), headers: constants.headers));
      },
    );
  });

  group('All possible exceptions', () {
    test(
      'Empty Authorization Exception',
      () async {
        /// Auth Token mocking
        Either<Failure, String> failureAuth =
            Left<Failure, String>(EmptyResponseFailure());
        when(mockAuthTokenRepository.readAuthToken())
            .thenAnswer((_) => Future.value(failureAuth));

        // assert
        expect(
            () => httpClientImpl.post(constants.budgetURL,
                headers: constants.headers, body: null),
            throwsA(TypeMatcher<EmptyAuthorizationTokenException>()));
      },
    );

    test(
      'TokenExpiredException',
      () async {
        /// Throw 401 Error
        when(mockNetworkHelper.post(constants.budgetURL,
                body: null, headers: constants.headers))
            .thenAnswer((_) async => Future.value(http.Response('', 401)));

        // assert
        expect(
            () => httpClientImpl.post(constants.budgetURL,
                headers: constants.headers, body: null),
            throwsA(TypeMatcher<TokenExpiredException>()));
      },
    );

    test(
      'ClientErrorException',
      () async {
        /// Throw 400 Error
        when(mockNetworkHelper.post(constants.budgetURL,
                body: null, headers: constants.headers))
            .thenAnswer((_) async => Future.value(http.Response('', 400)));

        // assert
        expect(
            () => httpClientImpl.post(constants.budgetURL,
                headers: constants.headers, body: null),
            throwsA(TypeMatcher<ClientErrorException>()));
      },
    );

    test(
      'ServerErrorException',
      () async {
        /// Throw 500 Error
        when(mockNetworkHelper.post(constants.budgetURL,
                body: null, headers: constants.headers))
            .thenAnswer((_) async => Future.value(http.Response('', 500)));

        // assert
        expect(
            () => httpClientImpl.post(constants.budgetURL,
                headers: constants.headers, body: null),
            throwsA(TypeMatcher<ServerErrorException>()));
      },
    );

    test(
      'UnknownException',
      () async {
        /// Throw unknown Error
        when(mockNetworkHelper.post(constants.budgetURL,
                body: null, headers: constants.headers))
            .thenAnswer((_) async => Future.value(http.Response('', 601)));

        // assert
        expect(
            () => httpClientImpl.post(constants.budgetURL,
                headers: constants.headers, body: null),
            throwsA(TypeMatcher<UnknownException>()));
      },
    );
  });
}
