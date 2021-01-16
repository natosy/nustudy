import 'package:flutter/material.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/components/custom_card.dart';
import '../Views/other_user_profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final String creatorNickname;
  final bool clickable;

  ProfileCard({this.profile, this.creatorNickname, this.clickable});

  @override
  Widget build(BuildContext context) {
    try {
      print(profile.toString() + "Rating is " + profile.getRating().toString());
    } catch(e){
      print(e.toString());
    }
    return CustomCard(
      function: () {
        if (Cache.account.profile != profile && clickable) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtherUserProfilePage(profile)));
        }
      },
      color: kAccentColor,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Text(
                '${profile.getNickname()[0].toUpperCase()}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        profile.getNickname(),
                        style: kTitleStyle,
                      ),
                      profile.getNickname() == creatorNickname
                          ? Text(
                              '(Creator)',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Year ${profile.getYear()}',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    RatingBar(
                      initialRating: profile.getRating(),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: kPrimaryColor,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (rating) {
                        // print(rating);
                      },
                    ),
                    Text(
                      '(${profile.getRating()})',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
