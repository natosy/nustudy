import 'package:flutter/material.dart';
import 'package:nus_study/Components/header.dart';
import 'package:nus_study/Rules/Profile.dart';
import '../Components/profile_card.dart';
import '../Components/description_card.dart';
import '../Components/history_section.dart';

///This page appears when the user is looking at another person's profile. Appears
///when the user presses the user's profile card under an active study session.
///User can view details of another participant of the study session here.
class OtherUserProfilePage extends StatelessWidget {
  final Profile profile;

  OtherUserProfilePage(this.profile);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.all(15.0),
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
                    child:
                        Header(title: '${profile.getNickname()}\'s Profile')),
              ],
            ),
            ProfileCard(
              profile: profile,
              clickable: false,
            ),
            DescriptionCard(
                title: 'About ${profile.getNickname()}',
                description: profile.getBiography()),
            HistorySection(profile: profile),
          ],
        ),
      )),
    );
  }
}
