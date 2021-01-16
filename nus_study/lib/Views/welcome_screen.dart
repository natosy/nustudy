import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/components/rounded_button.dart';
import 'package:nus_study/views/registration_page.dart';
import 'package:nus_study/constants.dart';
import 'login_page.dart';

///User can see this screen when the application is first opened.
class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome_screen';


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showSpinner = false;

  Future<void> getAllModules() async{
    List<Module> allModules = await DataInterface.getAllModules();
    Cache.allModules = allModules;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          alignment: Alignment.center,
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
              SizedBox(height: height * 2),
              RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LogInPage.id);
                },
                title: 'Log In',
                colour: kPrimaryColor,
              ),
              RoundedButton(
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  await getAllModules();
                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.pushNamed(context, RegistrationPage.id);
                },
                title: 'Register',
                colour: kSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

