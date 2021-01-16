import 'package:flutter/material.dart';
import 'package:nus_study/constants.dart';
import 'package:nus_study/components/custom_card.dart';

class DescriptionCard extends StatelessWidget {
  final String title;
  final String description;

  DescriptionCard({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title ?? 'Add title',
              style: kTitleStyle,
            ),
            SizedBox(height: 5.0),
            Text(
              description==""?'Add a description under Edit Profile!':description,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
