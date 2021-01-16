import 'package:flutter/material.dart';
import 'package:nus_study/Components/custom_card.dart';
import 'package:nus_study/constants.dart';

class HistoryCard extends StatelessWidget {
  Widget child;
  Function onTap;
  DateTime dateTime;
  String creator;
  String location;
  String description;
  int participants;
  int capacity;
  String module;

  HistoryCard({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: kPrimaryColor,
      child: Container(),
    );
  }
}
