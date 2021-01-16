import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/Components/search_widget.dart';
import 'package:nus_study/Components/text_input_field.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';

///This is the page that the user lands on when he presses the edit profile button
///on the options page. User can edit his details here.
class EditProfilePage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  int year;
  String description;
  Account account;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    account = widget.account;
    year = account.profile.getYear();
    description = account.profile.getBiography();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Header(title: 'Edit Profile'),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Username',
                      style: kTitleStyle.copyWith(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  TextInputField(
                    hintText: account.getNickName(),
                    readOnly: true,
                    onChange: (value) {},
                    errorText: null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Bio',
                      style: kTitleStyle.copyWith(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  TextInputField(
                    initialValue: account.profile.getBiography() ?? null,
                    hintText: account.profile.getBiography() ??
                        'Let people know more about you!',
                    onChange: (value) {
                      description = value;
                    },
                    unlimitedLines: true,
                    errorText: null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Year',
                      style: kTitleStyle.copyWith(
                        color: kPrimaryColor,
                      ),
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
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Modules',
                      style: kTitleStyle.copyWith(
                        color: kPrimaryColor,
                      ),
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
                      for (Module mod in account.modules)
                        if (mod.moduleCode == item.moduleCode)
                          alreadyAdded = true;
                      if (!alreadyAdded) account.modules.add(item);
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
                  for (Module mod in account.modules)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
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
                              account.modules.removeWhere((existingMod) =>
                                  mod.moduleCode == existingMod.moduleCode);
                            });
                          },
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 10),
                      RoundedButton(
                          colour: kSecondaryColor,
                          title: 'Save Changes',
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            account.editBiography(description);
                            account.profile.year = year;
                            bool updateSuccess =
                                await DataInterface.updateUserDetails();
                            if (updateSuccess) {
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('Tabs'),
                              );
                            } else {
                              setState(() {
                                showSpinner = false;
                              });
                              StatusAlert.show(
                                context,
                                margin: EdgeInsets.all(width * 50),
                                duration: Duration(seconds: 2),
                                blurPower: 100,
                                title: 'Error',
                                subtitle:
                                    'Unable to Update Details \n Please try again later',
                                configuration: IconConfiguration(
                                    icon: Icons.error, size: 100),
                              );
                            }
                          }),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
