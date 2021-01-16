import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/Components/text_input_field.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';

///This is the page that opens up when the usr presses change password under options.
///Here the user has a dedicated page to change his password.
class PasswordChangePage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  String enteredCurrentPassword;
  String enteredNewPassword;
  String enteredNewPasswordCopy;


  bool canChangePassword() {
    return enteredNewPassword != null &&
        enteredCurrentPassword!=null &&
        enteredNewPassword.length > 5 &&
        enteredNewPassword == enteredNewPasswordCopy;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    Account account = widget.account;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Header(title: 'Change Password'),
                TextInputField(
                  labelText: 'Current Password',
                  obscureText: true,
                  onChange: (value) {
                    setState(() {
                      enteredCurrentPassword = value;
                    });
                  },
                ),
                TextInputField(
                  labelText: 'New Password',
                  obscureText: true,
                  onChange: (value) {
                    setState(() {
                      enteredNewPassword = value;
                    });
                  },
                  errorText: enteredNewPassword == null ||
                          enteredNewPassword.length > 5
                      ? null
                      : 'Password must be longer than 6 characters',
                ),
                TextInputField(
                  labelText: 'Confirm New Password',
                  obscureText: true,
                  onChange: (value) {
                    setState(() {
                      enteredNewPasswordCopy = value;
                    });
                  },
                  errorText: enteredNewPasswordCopy == null ||
                          enteredNewPasswordCopy == enteredNewPassword
                      ? null
                      : 'Passwords do not match',
                ),
                RoundedButton(
                    colour: kPrimaryColor,
                    title: 'Save password',
                    onPressed: () async {
                      if (canChangePassword()) {
                        bool changeSuccess = await DataInterface.changePassword(newPassword: enteredNewPasswordCopy);
                        if(changeSuccess) {
                          account.password = enteredNewPassword;
                          StatusAlert.show(
                            context,
                            margin: EdgeInsets.all(width * 50),
                            duration: Duration(seconds: 2),
                            blurPower: 100,
                            title: 'Successful',
                            subtitle:
                            'You have successfully changed your password!',
                            configuration: IconConfiguration(
                                icon: Icons.check, size: 100),
                          );
                          print("I happened after the Status alert was supposed to show");
                          Future.delayed(Duration(seconds: 3),(){
                            Navigator.pop(context);
                            print("I happened inside the future");
                          });
                        } else{
                          StatusAlert.show(
                            context,
                            margin: EdgeInsets.all(width * 50),
                            duration: Duration(seconds: 2),
                            blurPower: 100,
                            title: 'Error',
                            subtitle: 'Try Again later.',
                            configuration:
                            IconConfiguration(icon: Icons.error, size: 100),
                          );
                        }
                      } else {
                        StatusAlert.show(
                          context,
                          margin: EdgeInsets.all(width * 50),
                          duration: Duration(seconds: 2),
                          blurPower: 100,
                          title: 'Error',
                          subtitle: 'Unable to change password.',
                          configuration:
                              IconConfiguration(icon: Icons.error, size: 100),
                        );
                      }
                    }),
                RoundedButton(
                  colour: Colors.black,
                  title: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
