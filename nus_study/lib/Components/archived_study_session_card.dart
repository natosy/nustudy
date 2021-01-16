import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nus_study/Components/custom_card.dart';
import 'package:nus_study/Components/rounded_button.dart';
import 'package:nus_study/Database/cache.dart';
import 'package:nus_study/Rules/ArchivedStudySession.dart';
import 'package:nus_study/Views/study_session_rating_screen.dart';
import '../constants.dart';

class ArchivedStudySessionCard extends StatefulWidget {

  final ArchivedStudySession archivedSS;

  ArchivedStudySessionCard(this.archivedSS);

  @override
  _ArchivedStudySessionCardState createState() => _ArchivedStudySessionCardState();
}

class _ArchivedStudySessionCardState extends State<ArchivedStudySessionCard> {

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Module',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Rating',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.archivedSS.getTitle(),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '${widget.archivedSS.getModule().moduleCode}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '${widget.archivedSS.getDate()}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          widget.archivedSS.getVenue().getName(),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            RatingBar(
                              initialRating: widget.archivedSS.getRating(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                              EdgeInsets.symmetric(horizontal: 1.0),
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
                              '(${widget.archivedSS.getRating()})',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.archivedSS.participantToRate(Cache.account.profile))
            RoundedButton(
                title: 'Rate',
                colour: kPrimaryColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSRatingScreen(
                            archivedStudySession: widget.archivedSS,
                            profile: Cache.account.profile),
                      )).then((value) => setState(() {}));
                })
        ],
      ),
      function: () {},
    );
  }
}

