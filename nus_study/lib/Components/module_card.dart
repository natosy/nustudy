import 'package:flutter/material.dart';
import 'package:nus_study/Components/custom_card.dart';
import 'package:nus_study/Rules/Module.dart';
import 'package:nus_study/constants.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final Function function;

  ModuleCard({@required this.module, this.function});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    return CustomCard(
      function: function,
      color: kAccentColor,
      child: Padding(
        padding: EdgeInsets.all(width * 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                module.moduleCode,
                style: TextStyle(
                  fontSize: width * 6,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Text(
                module.moduleTitle,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
