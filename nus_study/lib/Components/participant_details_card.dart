import 'package:flutter/material.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Components/profile_card.dart';
import 'package:nus_study/constants.dart';

class ParticipantDetailsCard extends StatefulWidget {
  final List<Profile> profileList;
  final int capacity;

  ParticipantDetailsCard({
    @required this.profileList,
    @required this.capacity,
  });

  @override
  _ParticipantDetailsCardState createState() => _ParticipantDetailsCardState();
}

class _ParticipantDetailsCardState extends State<ParticipantDetailsCard> {
  @override
  Widget build(BuildContext context) {
    String creatorNickname = widget.profileList.first.nickname;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Participant Details',
              style: kSubTitleStyle,
            ),
            Text(
              '${widget.profileList.length}/${widget.capacity}',
              style: kSubTitleStyle,
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.profileList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return ProfileCard(
                  clickable: true,
                  profile: widget.profileList[index],
                  creatorNickname: creatorNickname,
                );
              }),
        ),
      ],
    );
  }
}
