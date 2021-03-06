import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

// Public exposed class
class ResendVerification extends StatefulWidget {
  /// In the constructor, require an email.
  const ResendVerification({Key key, @required this.email}) : super(key: key);

  final String email;

  @override
  _ResendVerificationState createState() => _ResendVerificationState();
}

class _ResendVerificationState extends State<ResendVerification> {
  _ResendVerificationState();

  /// States
  bool _btnEnabled = true;
  Timer _timer;
  final timeout = const Duration(seconds: 60);

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /// Show text only when the button is enabled
        Visibility(
            visible: _btnEnabled,
            child: const Text(
              'Resend ',
              style: TextStyle(color: primaryColor),
            )),
        GestureDetector(
          onTap: () async {
            _toggleTextState(false);
            // TODO
            /*await _AuthenticationRemoteDataSource.resendVerificationCode(
                context, email);*/
            // Show the text again after a period in time
            startTimeoutThenShowText();
          },
          child:

              /// Show text only when the button is enabled
              Visibility(
            visible: _btnEnabled,
            child: const Text('Verification Code',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
        )
      ],
    );
  }

  /// Toggle the text state
  /// btnEnabled is optional and the default value is true
  void _toggleTextState([bool btnEnabled = true]) {
    setState(() {
      _btnEnabled = btnEnabled;
    });
  }

  /// Starts a count down timer that executes the function after hitting 0
  Timer startTimeoutThenShowText() {
    return Timer(timeout, _toggleTextState);
  }
}
