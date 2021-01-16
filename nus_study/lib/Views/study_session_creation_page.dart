import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Components/search_widget.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/Rules/Venue.dart';
import 'package:nus_study/Views/notification_page.dart';
import 'package:nus_study/components/header.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/Components/text_input_field.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:status_alert/status_alert.dart';

//TODO: with AutomaticKeepAliveClientMixin<NameOfPage> for tabs and shift all to stateful widgets

///User can come to this page to create a new study session. This comes under Tabs.
class StudySessionCreationPage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _StudySessionCreationPageState createState() =>
      _StudySessionCreationPageState();
}

class _StudySessionCreationPageState extends State<StudySessionCreationPage>
    with AutomaticKeepAliveClientMixin<StudySessionCreationPage> {
  ///Basically keeps the tab alive so that the state is saved when navigating between tabs
  ///Required method for AutomaticKeepAliveClientMixin.
  @override
  bool get wantKeepAlive => true;

  List<Text> venueText = [];
  Venue venue; //Cache.venues[0];
  List<Text> moduleText = [];
  Module module = Cache.account.modules[0];
  DateTime dateTime = DateTime.now();
  String title;
  String description;

  List<Icon> capacityCount = [];
  int capacity = 0;

  bool showSpinner = false;

  Icon personIcon = Icon(
    Icons.person,
    color: Colors.white,
  );

  void addPersonIcon() {
    if (capacity != 10) {
      capacity++;
      capacityCount.add(personIcon);
    }
  }

  void removePersonIcon() {
    if (capacity != 0) {
      capacity--;
      capacityCount.removeLast();
    }
  }

  @override
  void initState() {
    super.initState();
    getVenueText();
    getModulesText();
  }

  void getVenueText() {
    for (Venue venue in Cache.venues) {
      venueText.add(Text(
        venue.getName(),
        style: TextStyle(color: Colors.white),
      ));
    }
  }

  void getModulesText() {
    for (Module mod in widget.account.modules) {
      moduleText.add(Text(
        '${mod.moduleCode} ${mod.moduleTitle}',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white),
      ));
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Header(title: 'Create A Study Session'),
                //TODO:TextField for Title
                TextInputField(
                  initialValue: title,
                  labelText: 'Title',
                  onChange: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                //TODO:Description
                TextInputField(
                  initialValue: description,
                  labelText: 'Description',
                  onChange: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                SizedBox(height: height * 5),
                Text(
                  'Module',
                  style: kTitleStyle.copyWith(
                    color: kAccentColor,
                  ),
                ),
                //TODO:Module DDButton, choices for users own modules only

                SizedBox(
                  height: height * 15,
                  child: Padding(
                    padding: EdgeInsets.all(width * 2),
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      children: moduleText,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          module = widget.account.modules[value];
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: height * 5),

                Text(
                  'Location',
                  style: kTitleStyle.copyWith(
                    color: kAccentColor,
                  ),
                ),

                //TODO:DDButton for location, all locations
                SearchWidget<Venue>(
                  dataList: Cache.venues,
                  hideSearchBoxWhenItemSelected: false,
                  listContainerHeight: MediaQuery.of(context).size.height / 4,
                  queryBuilder: (String query, List<Venue> list) {
                    return list
                        .where((Venue venue) => venue
                            .getName()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  },
                  onItemSelected: (item) {
                    setState(() {
                      venue = item;
                    });
                  },
                  popupListItemBuilder: (Venue venue) {
                    return Container(
                      padding: EdgeInsets.all(width * 3),
                      child: Text(
                        venue.getName(),
                        style:
                            TextStyle(fontSize: width * 4, color: Colors.black),
                      ),
                    );
                  },
                  selectedItemBuilder:
                      (Venue item, void Function() deleteSelectedItem) {},
                  // // widget customization
                  // noItemsFoundWidget: NoItemsFound(),
                  // textFieldBuilder: (TextEditingController controller,
                  //     FocusNode focusNode) {
                  //   return MyTextField(controller, focusNode);
                  // },
                ),
                // SizedBox(
                //   height: height * 15,
                //   child: Padding(
                //     padding: EdgeInsets.all(width * 2),
                //     child: CupertinoPicker(
                //       itemExtent: 32.0,
                //       children: venueText,
                //       onSelectedItemChanged: (value) {
                //         setState(() {
                //           venue = Cache.venues[value];
                //         });
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(height: height),
                venue == null
                    ? Text('No Location selected yet')
                    : Text('Location: ${venue.getName()}'),
                SizedBox(height: height * 5),

                Text(
                  'Date and Time',
                  style: kTitleStyle.copyWith(
                    color: kAccentColor,
                  ),
                ),
                //TODO:CupertinoDateTimePicker, min date today, min 1 hour ceiled after time now
                SizedBox(
                  height: height * 15,
                  child: Padding(
                    padding: EdgeInsets.all(width * 2),
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (value) {
                          setState(() {
                            dateTime = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 5),
                Text(
                  'Capacity',
                  style: kTitleStyle.copyWith(
                    color: kAccentColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: capacityCount,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.remove,
                      ),
                      onPressed: () {
                        setState(() {
                          removePersonIcon();
                        });
                      },
                    ),
                    Text(
                      capacity == 0 ? '0' : '$capacity',
                      style: TextStyle(
                        fontSize: width * 5,
                      ),
                    ),
                    FlatButton(
                      child: Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        setState(() {
                          addPersonIcon();
                        });
                      },
                    ),
                  ],
                ),
                RoundedButton(
                  title: 'Create Study Session',
                  colour: kPrimaryColor,
                  onPressed: () {
                    if (title == null ||
                        description == null ||
                        title == '' ||
                        description == '' ||
                        capacity < 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                notificationMessage: 'Error',
                                errorMessage: capacity < 3
                                    ? 'Make sure that the capacity field is filled in properly'
                                    : 'Make sure all the fields are filled in',
                                buttonMessage: 'Go Back')),
                      );

                      // StatusAlert.show(
                      //   context,
                      //   margin: EdgeInsets.all(width * 50),
                      //   duration: Duration(seconds: 2),
                      //   blurPower: 100,
                      //   title: 'Error',
                      //   subtitle: capacity < 2
                      //       ? 'Make sure that the capacity field is filled in properly'
                      //       : 'Make sure all the fields are filled in',
                      //   configuration:
                      //       IconConfiguration(icon: Icons.error, size: 100),
                      // );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Scaffold(
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Confirm creation of Study Session?'),
                                SizedBox(height: height * 2),
                                RoundedButton(
                                    title: 'Yes',
                                    colour: kSecondaryColor,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      ActiveStudySession ass = widget.account
                                          .createStudySession(
                                              venue,
                                              module,
                                              title,
                                              description,
                                              capacity,
                                              dateTime);
                                      bool aSSCreateSuccess = await DataInterface
                                          .createActiveStudySession(ass);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      if (aSSCreateSuccess) {
//                                    bool cacheAccountAssListUpdated = await DataInterface.getUpdatedJoinedSS();
//                                    if(cacheAccountAssListUpdated) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NotificationPage(
                                                success: true,
                                                notificationMessage: 'Successful',
                                                errorMessage:
                                                    'You have successfully created a study session!',
                                                buttonMessage: 'Go Back'),
                                          ),
                                        );

                                        // StatusAlert.show(
                                        //   context,
                                        //   margin: EdgeInsets.all(width * 50),
                                        //   duration: Duration(seconds: 2),
                                        //   blurPower: 100,
                                        //   title: 'Successful',
                                        //   subtitle:
                                        //       'You have successfully created a study session!',
                                        //   configuration: IconConfiguration(
                                        //       icon: Icons.check, size: 100),
                                        // );
//                                    } else{
//                                      setState(() {
//                                        showSpinner = false;
//                                      });
//                                      StatusAlert.show(
//                                        context,
//                                        margin: EdgeInsets.all(width * 50),
//                                        duration: Duration(seconds: 2),
//                                        blurPower: 100,
//                                        title: 'Error',
//                                        subtitle:
//                                        'Study Session Successfully Created. \n You need to login again to see your updated Active Study Sessions',
//                                        configuration:
//                                        IconConfiguration(icon: Icons.error, size: 100),
//                                      );
//                                    }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotificationPage(
                                                  success: false,
                                                  notificationMessage: 'Error',
                                                  errorMessage:
                                                      'Unable to create Study Session',
                                                  buttonMessage: 'Go Back')),
                                        );
                                        // StatusAlert.show(
                                        //   context,
                                        //   margin: EdgeInsets.all(width * 50),
                                        //   duration: Duration(seconds: 2),
                                        //   blurPower: 100,
                                        //   title: 'Error',
                                        //   subtitle:
                                        //       'Unable to create Study Session',
                                        //   configuration: IconConfiguration(
                                        //       icon: Icons.error, size: 100),
                                        // );
                                      }
                                    }),
                                RoundedButton(
                                    title: 'No',
                                    colour: Colors.redAccent,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
