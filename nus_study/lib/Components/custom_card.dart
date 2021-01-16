import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final Function function;

  CustomCard({this.child, this.color, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function ?? () {},
      child: Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: child,
        ),
      ),
    );
  }
}
