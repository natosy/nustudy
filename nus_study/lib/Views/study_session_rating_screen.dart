import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nus_study/Database/database_cache_interface.dart';
import 'package:nus_study/Rules/ArchivedStudySession.dart';
import 'package:nus_study/Components/header.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nus_study/Rules/Profile.dart';
import 'package:nus_study/Views/notification_page.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/Components/rounded_button.dart';

///Study session rating screen will appear on users screen once user has ended
///the study session. Here the user can input the rating for the study session.
class SSRatingScreen extends StatefulWidget {
  final ArchivedStudySession archivedStudySession;
  final Profile profile;

  SSRatingScreen({this.archivedStudySession, this.profile});

  @override
  _SSRatingScreenState createState() => _SSRatingScreenState();
}

class _SSRatingScreenState extends State<SSRatingScreen> {
  double userRating = 3;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Header(title: 'Rate Your Study Session'),
              Column(
                children: <Widget>[
                  Text('How would you rate the study session?'),
                  SizedBox(height: height * 2),
                  RatingBar(
                    itemSize: 30,
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: kAccentColor,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        userRating = rating;
                      });
                    },
                  ),
                ],
              ),
              RoundedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  bool ratingSuccess = await DataInterface.rateStudySession(widget.archivedStudySession, userRating);
                  if(ratingSuccess) {
                    widget.archivedStudySession
                        .addToRating(userRating, widget.profile);
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.pop(context);
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
                            'Unable to Rate Study Session \n Please Try Again Later'),
                      ),
                    );
                  }
                },
                colour: kSecondaryColor,
                title: 'Submit',
              )
            ],
          ),
        ),
      ),
    );
  }
}
