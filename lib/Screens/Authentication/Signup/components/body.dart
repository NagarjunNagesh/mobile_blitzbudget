import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';
import '../../Login/login_screen.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../../data/rest_ds.dart';
import '../../../../constants.dart';
import '../../../../routes.dart';

class Body extends StatelessWidget {
  RestDataSource _restDataSource = RestDataSource();
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
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
              text: "SIGNUP",
              press: () async {
                await _restDataSource.signupUser(context, username, password);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, loginRoute);
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}