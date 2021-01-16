import 'package:flutter/material.dart';
import 'package:nus_study/components/rounded_button.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/views/welcome_screen.dart';

///User will be shown this page once his registration is successful.
class RegistrationConfirmationPage extends StatelessWidget {
  static final id = 'registration_confirmation_page';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'icon',
            child: Image(
              height: height * 20,
              image: AssetImage('images/nustudy_logo.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width * 5),
            child: Text(
              'Thank you for signing up with NUStudy!\nAn email with a confirmation link will be sent to your inbox. Please click on it to verify your account before logging in!',
              textAlign: TextAlign.center,
            ),
          ),
          RoundedButton(
              title: 'Go Back to Log In',
              colour: kPrimaryColor,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, WelcomeScreen.id, (route) => false);
              })
        ],
      ),
    );
  }
}
