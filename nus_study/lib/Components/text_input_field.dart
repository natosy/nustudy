import 'package:flutter/material.dart';
import 'package:nus_study/constants.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final Function onChange;
  final String errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool unlimitedLines;
  final String hintText;
  final bool readOnly;
  final String initialValue;

  TextInputField(
      {this.initialValue,
      this.readOnly,
      this.hintText,
      this.labelText,
      this.onChange,
      this.errorText,
      this.obscureText,
      this.keyboardType,
      this.unlimitedLines});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height, horizontal: width * 7.5),
      child: TextFormField(
        maxLines: (unlimitedLines == true) ? null : 1,
        onChanged: onChange,
        initialValue: initialValue,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        decoration: kTextFieldDecoration.copyWith(
          labelText: labelText,
          errorText: errorText,
          hintText: hintText,
        ),
      ),
    );
  }
}
