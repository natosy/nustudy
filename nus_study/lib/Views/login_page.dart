import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/components/text_input_field.dart';
import 'package:status_alert/status_alert.dart';
import 'notification_page.dart';
import 'tabs.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/components/rounded_button.dart';
import 'package:nus_study/Rules/Account.dart';

///This is the Login Page which appears after the welcome screen. User can use
///his account to login from here.
class LogInPage extends StatefulWidget {
  static final String id = 'login_page';

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email;
  String password;
  Account account;
  bool showSpinner = false;

  bool validateFields() {
    return emailCheck(email) && password != null && password != "";
  }

  bool emailCheck(String text) {
    if (text != null) {
      bool emailValid = RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(text);
      return emailValid;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'icon',
                    child: Image(
                      height: height * 20,
                      image: AssetImage('images/nustudy_logo.png'),
                    ),
                  ),
                  TextInputField(
                    labelText: 'Email',
                    onChange: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    errorText: emailCheck(email)
                        ? null
                        : 'Please type in a valid email',
                  ),
                  TextInputField(
                    labelText: 'Password',
                    obscureText: true,
                    onChange: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  RoundedButton(
                    onPressed: () async {
                      if (validateFields()) {
                        setState(() {
                          showSpinner = true;
                        });
                        bool loginSuccess = await DataInterface.loginUser(
                            email: email, password: password);
                        if (loginSuccess) {
                          Account account =
                              await DataInterface.getUserCollection();
                          if (account != null) {
                            Cache.account = account;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(name: 'Tabs'),
                                builder: (context) => Tabs(),
                              ),
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationPage(
                                    success: false,
                                    notificationMessage:
                                        'Oh no! An error occured.',
                                    buttonMessage: 'Go Back',
                                    errorMessage:
                                        'Unable to get account information'),
                              ),
                            );
                            // StatusAlert.show(
                            //   context,
                            //   margin: EdgeInsets.all(width * 50),
                            //   duration: Duration(seconds: 2),
                            //   blurPower: 100,
                            //   title: 'Error',
                            //   subtitle:
                            //       'Unable to Log In \n Unable to get account information',
                            //   configuration: IconConfiguration(
                            //       icon: Icons.error, size: 100),
                            // );
                          }
                        } else {
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(
                                  success: false,
                                  notificationMessage:
                                      'Oh no! An error occured.',
                                  buttonMessage: 'Go Back',
                                  errorMessage:
                                      'Unable to Log In \n Invalid email/password'),
                            ),
                          );
                          // StatusAlert.show(
                          //   context,
                          //   margin: EdgeInsets.all(width * 50),
                          //   duration: Duration(seconds: 2),
                          //   blurPower: 100,
                          //   title: 'Error',
                          //   subtitle:
                          //       'Unable to Log In \n Invalid email/password',
                          //   configuration:
                          //       IconConfiguration(icon: Icons.error, size: 100),
                          // );
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                success: false,
                                notificationMessage: 'Error',
                                buttonMessage: 'Go Back',
                                errorMessage:
                                    'Unable to Log In \n Please fill in the fields correctly'),
                          ),
                        );
                        // StatusAlert.show(
                        //   context,
                        //   margin: EdgeInsets.all(width * 50),
                        //   duration: Duration(seconds: 2),
                        //   blurPower: 100,
                        //   title: 'Error',
                        //   subtitle:
                        //       'Unable to Log In \n Please fill in fields correctly',
                        //   configuration:
                        //       IconConfiguration(icon: Icons.error, size: 100),
                        // );
                      }
                    },
                    title: 'Log In',
                    colour: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
