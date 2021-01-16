import 'package:flutter/material.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/views/login_page.dart';
import 'package:nus_study/views/registration_confirmation_page.dart';
import 'package:nus_study/views/registration_page.dart';
import 'views/tabs.dart';
import 'views/welcome_screen.dart';
import 'constants.dart';

void main() {
  DataInterface.getUpdatedVenues();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: WelcomeScreen.id,
      routes: {
        LogInPage.id: (context) => LogInPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Tabs.id: (context) => Tabs(),
        RegistrationConfirmationPage.id: (context) =>
            RegistrationConfirmationPage(),
        // StudySessionPage.id: (context) => StudySessionPage(
        //       creator: natosy,
        //       location: 'COM 1',
        //       dateTime: DateTime.now(),
        //       description: 'Studying for 2040S midterms blah blah blah blah blah.',
        //       participants: 1,
        //       capacity: 5,
        //       module: '2040S',
        //     ),
      },
    );
  }
}
