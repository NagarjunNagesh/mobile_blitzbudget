/*
 if (isEmpty(email)) {
      displayDialog(context, 'Empty Email', 'The email cannot be empty');
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, 'Invalid Email', 'The email is not valid');
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, 'Empty Password', 'The password cannot be empty');
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, 'Invalid Password', 'The password is not valid');
      return null;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();

    /// Navigate to the second screen using a named route.
      /// Show resend verification code is false
      /// User verification URL as false
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => VerifyScreen(
              email: email,
              password: password,
              useVerifyURL: false,
              showResendVerificationCode: false),
        ),
      );

      return;
*/