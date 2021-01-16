import 'package:flutter/material.dart';
import 'package:nus_study/constants.dart';

class Header extends StatelessWidget {
  final String title;

  Header({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Text(title, style: kHeaderStyle),
      ),
    );
  }
}
