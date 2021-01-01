import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';

abstract class GoalRemoteDataSource {
  Future<void> get(Map<String, dynamic> contentBody);

  Future<void> update(GoalModel updateGoal);

  Future<void> add(GoalModel addGoal);
}

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final HTTPClient httpClient;

  GoalRemoteDataSourceImpl({@required this.httpClient});

  /// Get Goals
  @override
  Future<void> get(Map<String, dynamic> contentBody) async {
    developer.log('The Map for getting the goal is  ${contentBody.toString()}');

    return httpClient
        .post(constants.goalURL,
            body: jsonEncode(contentBody), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the goal is $res');
      //TODO
    });
  }

  /// Update Budget
  @override
  Future<void> update(GoalModel updateGoal) {
    developer
        .log('The Map for patching the budget is  ${updateGoal.toString()}');

    return httpClient
        .patch(constants.goalURL,
            body: jsonEncode(updateGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the budget is $res');
      //TODO
    });
  }

  /// Add Goal
  @override
  Future<void> add(GoalModel addGoal) {
    return httpClient
        .put(constants.goalURL,
            body: jsonEncode(addGoal.toJSON()), headers: constants.headers)
        .then((dynamic res) {
      debugPrint('The response from the goal is $res');
      //TODO
    });
  }
}