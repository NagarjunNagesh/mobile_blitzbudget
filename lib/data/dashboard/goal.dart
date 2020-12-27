import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/network_util.dart';
import '../../utils/utils.dart';
import '../authentication.dart' as authentication;
import '../../constants.dart' as constants;
import 'common/dashboard-utils.dart' as dashboardUtils;
import '../../models/user.dart';

class GoalRestData {
  NetworkUtil _netUtil = new NetworkUtil();

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final _goalURL = authentication.baseURL + "/goals";

  /// Get Goals
  Future<void> get() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    /// Get from shared preferences
    final String _defaultWallet = _prefs.getString(constants.defaultWallet);
    final String _startsWithDate =
        await dashboardUtils.fetchStartsWithDate(_prefs);
    final String _endsWithDate = await dashboardUtils.fetchEndsWithDate(_prefs);

    // Read [_userAttributes] from User Attributes
    final String _userAttributes =
        await _storage.read(key: constants.userAttributes);
    // Decode the json user
    Map<String, dynamic> _user = jsonDecode(_userAttributes);
    developer.log('User Attributes retrieved for: ${_user["userid"]}');

    // JSON for Get goal [_jsonForGetGoal]
    Map<String, dynamic> _jsonForGetGoal = {
      "startsWithDate": _startsWithDate,
      "endsWithDate": _endsWithDate
    };

    /// Ensure that the wallet is chosen if not empty
    /// If not then use userid
    if (isNotEmpty(_defaultWallet)) {
      _jsonForGetGoal["walletId"] = _defaultWallet;
    } else {
      _jsonForGetGoal["userId"] = _user["userid"];
    }

    developer
        .log("The Map for getting the goal is  ${_jsonForGetGoal.toString()}");

    // Set Authorization header
    authentication.headers['Authorization'] =
        await _storage.read(key: constants.authToken);

    developer.log('The response from the goal is ${authentication.headers}');
    return _netUtil
        .post(_goalURL,
            body: jsonEncode(_jsonForGetGoal), headers: authentication.headers)
        .then((dynamic res) {
      debugPrint('The response from the goal is $res');
    });
  }

  /// Update Goal
  Future<void> update() {}

  /// Delete Goal
  Future<void> delete() {}
}
