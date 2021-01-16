import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/views/registration_confirmation_page.dart';
import 'package:nus_study/components/search_widget.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/components/text_input_field.dart';
import 'package:nus_study/components/rounded_button.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:status_alert/status_alert.dart';

///User comes to this page by pressing on register button on the welcome screen
///User can Register his account on this page.
class RegistrationPage extends StatefulWidget {
  static final String id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String username;
  String studentNumber;
  int year;
  String email;
  List<Module> modules = List();
  String password;
  String passwordCopy;

  bool termsAndConditions = false;
  bool showSpinner = false;

  bool usernameExists(String username) {
    return DataInterface.usernameExists(username);
  }

  bool studentNumberExists(String studentNumber) {
    return DataInterface.studentNumberExists(studentNumber);
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


  bool passwordAndCheckboxValidated() {
    bool passwordEnough = password == null ? false : password.length > 5;
    bool passwordMatch = password == passwordCopy;
    return termsAndConditions && passwordEnough && passwordMatch;
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height,
                  ),
                  Hero(
                    tag: 'icon',
                    child: Image(
                      height: height * 15,
                      image: AssetImage('images/nustudy_logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: height,
                  ),
                  TextInputField(
                    labelText: 'Username',
                    onChange: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    errorText: usernameExists(username)
                        ? 'This username is already in use.'
                        : null,
                  ),
                  TextInputField(
                    labelText: 'Student Number (e.g. e0123456)',
                    onChange: (value) {
                      setState(() {
                        studentNumber = value;
                      });
                    },
                    errorText: studentNumberExists(studentNumber)
                        ? 'This Student Number is already in use.'
                        : null,
                  ),
                  TextInputField(
                    labelText: 'NUSNET email',
                    keyboardType: TextInputType.emailAddress,
                    onChange: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    errorText: emailCheck(email)
                        ? null
                        : 'Please type in a valid email',
                  ),
                  SizedBox(
                    height: height,
                  ),
                  Text(
                    'Year',
                    style: kTitleStyle.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                  ListTile(
                    title: Text('1'),
                    leading: Radio(
                      value: 1,
                      onChanged: (int value) {
                        setState(() {
                          year = value;
                        });
                      },
                      groupValue: year,
                    ),
                  ),
                  ListTile(
                    title: Text('2'),
                    leading: Radio(
                      value: 2,
                      groupValue: year,
                      onChanged: (int value) {
                        setState(() {
                          year = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('3'),
                    leading: Radio(
                      value: 3,
                      onChanged: (int value) {
                        setState(() {
                          year = value;
                        });
                      },
                      groupValue: year,
                    ),
                  ),
                  ListTile(
                    title: Text('4'),
                    leading: Radio(
                      value: 4,
                      groupValue: year,
                      onChanged: (int value) {
                        setState(() {
                          year = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: height,
                  ),
                  Text(
                    'Modules',
                    style: kTitleStyle.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                  SearchWidget<Module>(
                    dataList: Cache.allModules,
                    hideSearchBoxWhenItemSelected: false,
                    listContainerHeight: MediaQuery.of(context).size.height / 4,
                    queryBuilder: (String query, List<Module> list) {
                      return list
                          .where((Module module) =>
                              '${module.moduleCode} ${module.moduleTitle}'
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                          .toList();
                    },
                    onItemSelected: (item) {
                      bool alreadyAdded = false;
                      for (Module mod in modules)
                        if (mod.moduleCode == item.moduleCode)
                          alreadyAdded = true;
                      if (!alreadyAdded) modules.add(item);
                      print(modules);
                      setState(() {});
                    },
                    popupListItemBuilder: (Module module) {
                      return Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '${module.moduleCode} ${module.moduleTitle}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    },
                    selectedItemBuilder:
                        (Module item, void Function() deleteSelectedItem) {},
                    // // widget customization
                    // noItemsFoundWidget: NoItemsFound(),
                    // textFieldBuilder: (TextEditingController controller,
                    //     FocusNode focusNode) {
                    //   return MyTextField(controller, focusNode);
                    // },
                  ),
                  for (Module mod in modules)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Text(
                              '${mod.moduleCode} ${mod.moduleTitle}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 22),
                          color: Colors.grey[700],
                          onPressed: () {
                            setState(() {
                              modules.removeWhere((existingMod) =>
                                  mod.moduleCode == existingMod.moduleCode);
                            });
                            print(modules);
                          },
                        ),
                      ],
                    ),
                  TextInputField(
                    labelText: 'Password',
                    obscureText: true,
                    onChange: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    errorText: password == null
                        ? null
                        : password.length < 6
                            ? 'Password needs to be longer than 6 characters.'
                            : null,
                  ),
                  TextInputField(
                    labelText: 'Confirm Password',
                    obscureText: true,
                    onChange: (value) {
                      setState(() {
                        passwordCopy = value;
                      });
                    },
                    errorText: password == passwordCopy
                        ? null
                        : 'Passwords do not match.',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: termsAndConditions,
                        onChanged: (newBool) {
                          setState(() {
                            termsAndConditions = newBool;
                          });
                        },
                      ),
                      Text('I agree to the '),
                      GestureDetector(
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Center(
                              child: Text('Terms & Conditions'),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 10),
                      RoundedButton(
                        onPressed: () async {
                          if (passwordAndCheckboxValidated()) {
                            setState(() {
                              showSpinner = true;
                            });
                            bool nickNameExists =
                                await DataInterface.nicknameExists(
                                    nickname: username);
                            if (!nickNameExists) {
                              bool NUSNETIDExists =
                                  await DataInterface.NUSNETIDExists(
                                      NUSNETID: studentNumber);
                              if (!NUSNETIDExists) {
                                Account acc = Account(
                                    nickname: username,
                                    NUSNETID: studentNumber,
                                    email: email,
                                    password: password,
                                    biography: "",
                                    year: year,
                                    modules: modules);
                                DataInterface.addAccount(acc);
                                bool successRegistration =
                                    await DataInterface.createUser(
                                        email: email,
                                        password: password,
                                        account: acc);
                                if (successRegistration) {
                                  Navigator.pushReplacementNamed(
                                      context, RegistrationConfirmationPage.id);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  print("registration failed");
                                  StatusAlert.show(
                                    context,
                                    margin: EdgeInsets.all(width * 50),
                                    duration: Duration(seconds: 2),
                                    blurPower: 100,
                                    title: 'Error',
                                    subtitle: 'Registration failed',
                                    configuration: IconConfiguration(
                                        icon: Icons.error, size: 100),
                                  );
                                }
                              } else {
                                setState(() {
                                  showSpinner = false;
                                });
                                print("NUSNETID exists");
                                StatusAlert.show(
                                  context,
                                  margin: EdgeInsets.all(width * 50),
                                  duration: Duration(seconds: 2),
                                  blurPower: 100,
                                  title: 'Error',
                                  subtitle:
                                      'NUSNETID already exists! Change NUSNETID to something else',
                                  configuration: IconConfiguration(
                                      icon: Icons.error, size: 100),
                                );
                              }
                            } else {
                              setState(() {
                                showSpinner = false;
                              });
                              print("username exists");
                              StatusAlert.show(
                                context,
                                margin: EdgeInsets.all(width * 50),
                                duration: Duration(seconds: 2),
                                blurPower: 100,
                                title: 'Error',
                                subtitle:
                                    'Username already exists! Change username to something else',
                                configuration: IconConfiguration(
                                    icon: Icons.error, size: 100),
                              );
                            }
                          } else {
                            print("Unable to create account");
                            StatusAlert.show(
                              context,
                              margin: EdgeInsets.all(width * 50),
                              duration: Duration(seconds: 2),
                              blurPower: 100,
                              title: 'Error',
                              subtitle:
                                  'Unable to create account \n Check the input fields again',
                              configuration: IconConfiguration(
                                  icon: Icons.error, size: 100),
                            );
                          }
                        },
                        title: 'Register',
                        colour: kPrimaryColor,
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
