import 'package:flutter/material.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/Components/study_session_preview_card.dart';
import 'package:nus_study/Views/study_session_page.dart';
import '../constants.dart';

///This page appears when the user presses a module under the user_module_page
///The page displays all the study sessions that are active under the specified
///module
class ModuleStudySessions extends StatefulWidget {
  final Module module;

  ModuleStudySessions({@required this.module});

  @override
  _ModuleStudySessionsState createState() => _ModuleStudySessionsState();
}

class _ModuleStudySessionsState extends State<ModuleStudySessions> {

  @override
  Widget build(BuildContext context) {
    List<ActiveStudySession> moduleStudySessions = Cache.moduleStudySessions;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 20,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                    flex: 15,
                    child: Header(title: '${widget.module.moduleCode}')),
              ],
            ),
            Expanded(
              child: moduleStudySessions.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 65),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'This module has no active Study Sessions',
                              style: kHintLabelStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: moduleStudySessions.length,
                      itemBuilder: (BuildContext cntxt, int index) {
                        return StudySessionPreviewCard(
                          studySession: moduleStudySessions[index],
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudySessionPage(
                                  studySession: moduleStudySessions[index],
                                ),
                              ),
                            ).then((value) => setState(() {}));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
