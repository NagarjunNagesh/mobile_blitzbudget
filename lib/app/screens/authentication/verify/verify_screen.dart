import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../widgets/dashboard_widget.dart';
import 'components/body.dart';

class VerifyScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const VerifyScreen(
      {Key key,
      @required this.email,
      @required this.password,
      this.useVerifyURL = true,
      this.showResendVerificationCode = true})
      : super(key: key);

  static const title = 'Verify email';
  final String email, password;
  final bool useVerifyURL;
  final bool showResendVerificationCode;

  /// ===========================================================================
  /// Non-shared code below because on iOS, the settings tab is nested inside of
  /// the profile tab as a button in the nav bar.
  /// ===========================================================================
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Body(
          email: email,
          password: password,
          useVerifyURL: useVerifyURL,
          showResendVerificationCode: showResendVerificationCode),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.transparent)),
      ),
      child: Body(
          email: email,
          password: password,
          useVerifyURL: useVerifyURL,
          showResendVerificationCode: showResendVerificationCode),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
