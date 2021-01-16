import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Views/password_change_page.dart';
import 'package:nus_study/Views/welcome_screen.dart';
import 'package:nus_study/constants.dart';
import 'edit_profile_page.dart';

///This page is visible when the user presses on the menu button. Displays all
///the extra options available to user.

class UserProfileOptions extends StatefulWidget {
  @override
  _UserProfileOptionsState createState() => _UserProfileOptionsState();
}

class _UserProfileOptionsState extends State<UserProfileOptions> {
  final Account account = Cache.account;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.menu),
                        iconSize: width * 6,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
                SizedBox(height: height * 15),
                Column(
                  children: <Widget>[
                    Hero(
                      tag: 'icon',
                      child: Image(
                        height: height * 20,
                        image: AssetImage('images/nustudy_logo.png'),
                      ),
                    ),
                    SizedBox(height: height),
                    RoundedButton(
                      title: 'Edit Profile',
                      colour: kSecondaryColor,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        Cache.allModules = await DataInterface.getAllModules();
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()));
                      },
                    ),
                    RoundedButton(
                      title: 'Change password',
                      colour: kPrimaryColor,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordChangePage()));
                      },
                    ),
                    RoundedButton(
                      title: 'Log Out',
                      colour: Colors.redAccent,
                      onPressed: () {
                        DataInterface.signOut();
                        Cache.account = null;
                        Navigator.pushNamedAndRemoveUntil(
                            context, WelcomeScreen.id, (route) => false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

