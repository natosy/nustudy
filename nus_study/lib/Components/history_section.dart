import 'package:flutter/material.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Rules/ArchivedStudySession.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Components/archived_study_session_card.dart';

class HistorySection extends StatelessWidget {
  final Profile profile;

  HistorySection({this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Header(title: '${profile.getNickname()}\'s History'),
        for (ArchivedStudySession archivedSS in profile.history.studySessions) 
          ArchivedStudySessionCard(archivedSS),
      ],
    );
  }
}
