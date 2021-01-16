import 'package:flutter/material.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Views/user_study_session_page.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/views/study_session_creation_page.dart';
import 'package:nus_study/views/user_module_page.dart';
import 'package:nus_study/views/user_profile_page.dart';
import 'package:nus_study/Rules/Account.dart';

///Underlying mechanism to switch between the tab screens.
class Tabs extends StatelessWidget {
  static final id = 'tabs';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[
              UserStudySessionPage(),
              UserModulePage(),
              StudySessionCreationPage(),
              UserProfilePage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicatorColor: kPrimaryColor,
            tabs: <Tab>[
              Tab(
                icon: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                text: 'Sessions',
              ),
              Tab(
                icon: Icon(
                  Icons.class_,
                  color: Colors.white,
                ),
                text: 'Modules',
              ),
              Tab(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                text: 'Create',
              ),
              Tab(
                icon: Icon(
                  Icons.face,
                  color: Colors.white,
                ),
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
