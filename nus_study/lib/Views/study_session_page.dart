import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/Database/NUSDatabase.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/Account.dart';
import 'package:nus_study/Rules/ActiveStudySession.dart';
import 'package:nus_study/Rules/ArchivedStudySession.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Components/participant_details_card.dart';
import 'package:nus_study/Views/notification_page.dart';
import 'package:status_alert/status_alert.dart';
import '../Components/study_session_page_card.dart';
import 'package:nus_study/components/header.dart';
import 'package:nus_study/constants.dart';
import 'study_session_rating_screen.dart';

///User can come here by pressing on a study session card. This page shows the
///details of the study session.
class StudySessionPage extends StatefulWidget {
  static final String id = 'study_session_page';
  final ActiveStudySession studySession;
  final Account account = Cache.account;

  StudySessionPage({this.studySession});

  @override
  _StudySessionPageState createState() => _StudySessionPageState();
}

class _StudySessionPageState extends State<StudySessionPage> {
  void removeStudySessionForAllParticipants() {
    ActiveStudySession ass = widget.studySession;
    List<String> usernames;
    for (Profile participant in ass.getParticipants()) {
      usernames.add(participant.getNickname());
    }
    print(usernames);
    for (Account account in NUSDatabase.accounts) {
      if (usernames.contains(account.getNickName())) {
        account.removeStudySession(widget.studySession);
        print(account.getNickName());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showSpinner = false;
    ActiveStudySession studySession = widget.studySession;
    ParticipantDetailsCard participantInformation = ParticipantDetailsCard(
      profileList: studySession.getParticipants(),
      capacity: studySession.getCapacity(),
    );
    for(Profile p in studySession.getParticipants()){
      print(p);
    }
    bool isParticipant = studySession.getParticipants().any(
        (profile) => profile.getNickname() == widget.account.getNickName());
    bool isCreator =
        studySession.getCreatorID() == widget.account.getNUSNETID();

    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
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
                      child: Header(title: '${studySession.getTitle()}')),
                ],
              ),
              StudySessionDetailsCard(
                studySession: studySession,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: participantInformation,
              ),
              if (!isCreator)
                RoundedButton(
                    title: isParticipant
                        ? 'Leave Study Session'
                        : 'Join Study Session',
                    colour: isParticipant ? Colors.redAccent : kSecondaryColor,
                    onPressed: () async{
                      setState(() {
                        showSpinner = true;
                      });
                      //TODO: If I spam press I can add glitchy number of self participant profiles in the cache database(low priority issue)
                      if(isParticipant){
                        bool leaveSuccess = await DataInterface.leaveActiveStudySession(activeStudySession: studySession);
                        if(leaveSuccess){
                          setState(() {
                            DataInterface.leaveSession(studySession);
                            studySession.removeParticipant(widget.account.getProfile());
                          });
                          print("Successfully left Session");
                          setState(() {
                            showSpinner = false;
                          });
                        } else{
                          setState(() {
                            showSpinner = false;
                          });
                          StatusAlert.show(
                            context,
                            margin: EdgeInsets.all(width * 50),
                            duration: Duration(seconds: 2),
                            blurPower: 100,
                            title: 'Error',
                            subtitle: 'Try Leaving Study Session again later.',
                            configuration:
                            IconConfiguration(icon: Icons.error, size: 100),
                          );
                        }
                      }else{
                        bool joinSuccess = await DataInterface.joinActiveStudySession(activeStudySession: studySession);
                        if(joinSuccess){
                          setState(() {
                            DataInterface.joinSession(studySession);
                            studySession.addParticipant(widget.account.getProfile());
                          });
                          print("Successfully joined Session");
                          setState(() {
                            showSpinner = false;
                          });
                        } else{
                          setState(() {
                            showSpinner = false;
                          });
                          StatusAlert.show(
                            context,
                            margin: EdgeInsets.all(width * 50),
                            duration: Duration(seconds: 2),
                            blurPower: 100,
                            title: 'Error',
                            subtitle: 'Try Joining Study Session again later.',
                            configuration:
                            IconConfiguration(icon: Icons.error, size: 100),
                          );
                        }
                      }
                    }),
              if (isCreator)
                RoundedButton(
                  title: 'End Study Session',
                  colour: DateTime.now().isAfter(studySession.getDateTime())
                      ? Colors.red
                      : Colors.grey,
                  onPressed: () async{
                    if (DateTime.now().isAfter(studySession.getDateTime())) {
                      setState(() {
                        showSpinner = true;
                      });
                      bool successArchive = await DataInterface.createArchivedStudySession(studySession);
                      bool endSS = await DataInterface.endActiveStudySession(studySession);
                      if(successArchive && endSS) {
                        setState(() {
                          showSpinner = false;
                        });
                        ArchivedStudySession ass =
                        studySession.createArchivedStudySession();
                        for (Profile participant
                        in studySession.getParticipants()) {
                          participant.addToHistory(ass);
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SSRatingScreen(
                                    archivedStudySession: ass,
                                    profile: widget.account.profile,
                                  ),
                            ));
                      } else{
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                success: false,
                                notificationMessage: 'Error',
                                buttonMessage: 'Go Back',
                                errorMessage:
                                'Unable to End Study Session \n Please Try Again Later'),
                          ),
                        );
                      }
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
