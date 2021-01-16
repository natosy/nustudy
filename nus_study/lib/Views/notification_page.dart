import 'package:flutter/material.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/constants.dart';

class NotificationPage extends StatelessWidget {
  final String notificationMessage;
  final String errorMessage;
  final String buttonMessage;
  final bool success;

  NotificationPage(
      {@required this.notificationMessage,
      @required this.errorMessage,
      @required this.buttonMessage,
      this.success});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Header(title: notificationMessage),
            if (success != null)
              success
                  ? Icon(
                      Icons.done,
                      size: height * 15,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.error,
                      size: height * 15,
                      color: Colors.grey,
                    ),
            SizedBox(
              height: height,
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height,
            ),
            RoundedButton(
              title: buttonMessage,
              colour: kSecondaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
