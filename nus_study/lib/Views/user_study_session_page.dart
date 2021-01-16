import 'package:flutter/material.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Components/study_session_preview_card.dart';
import 'package:nus_study/Views/study_session_page.dart';
import 'package:nus_study/components/header.dart';
import 'package:nus_study/constants.dart';

///Is the home page when login occurs. Displays all of users current active study
///sessions. Comes under Tabs.
class UserStudySessionPage extends StatefulWidget {
  final Account account = Cache.account;

  @override
  _UserStudySessionPageState createState() => _UserStudySessionPageState();
}

class _UserStudySessionPageState extends State<UserStudySessionPage> {
// Explanation on AutomaticKeepAliveClientMixin<>
//  with AutomaticKeepAliveClientMixin<UserStudySessionPage>
//  Basically keeps the tab alive so that the state is saved when navigating between tabs
//  Required method for AutomaticKeepAliveClientMixin.
//  @override
//  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    List<ActiveStudySession> userStudySessions =
        widget.account.getUserStudySessions();
    // for (ActiveStudySession studySession in userStudySessions) {
    //   if (studySession.isEnded) widget.account.removeStudySession(studySession);
    // }
    return Column(
      children: <Widget>[
        Header(title: 'Study Sessions'),
        Expanded(
          child: userStudySessions.length == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 65),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'You have no active Study Sessions',
                          style: kHintLabelStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Search for one under Modules tab or Create one',
                          style: kHintLabelStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: userStudySessions.length,
                  itemBuilder: (BuildContext cntxt, int index) {
                    return StudySessionPreviewCard(
                      studySession: userStudySessions[index],
                      function: () {
                        if (!userStudySessions[index].isEnded) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudySessionPage(
                                studySession: userStudySessions[index],
                              ),
                            ),
                          ).then((_){
                            setState(() {});
                          });
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
