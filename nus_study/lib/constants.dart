import 'package:flutter/material.dart';

const kAccentColor = Color(0xFFffbd4a);
const kPrimaryColor = Color(0xFFF57C00);
//const kSecondaryColor = Color(0xFF03989e);
const kSecondaryColor = Color(0xFF303F9F);
const kLogoGrey = Color(0xFF424242);

ThemeData appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  accentColor: kPrimaryColor,
  toggleableActiveColor: kSecondaryColor,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    ),
    margin: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    color: kLogoGrey,
    // shadowColor: Colors.white,
    // elevation: 30,
  ),
);

const kTextFieldDecoration = InputDecoration(
  // hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kHeaderStyle = TextStyle(
  color: kPrimaryColor,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kTitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const kSubTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const kHintLabelStyle =
    TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold);
