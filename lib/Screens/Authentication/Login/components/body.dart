import 'package:flutter/material.dart';

import 'background.dart';
import '../../components/already_have_an_account_acheck.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../../data/rest_ds.dart';
import '../../../../Utils/utils.dart';
import '../../../../constants.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = new RestDataSource();
  TextEditingController controller;
  String username, password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  username = value;
                },
                autofocus: true),
            RoundedPassword(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "CONTINUE",
              press: () async {
                var user = await _restDataSource.attemptLogin(
                    context, username, password);
                if (user != null) {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, dashboardRoute);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, signupRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
