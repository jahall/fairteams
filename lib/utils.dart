import 'dart:math';
import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = min(screenWidth, 500);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      )
    ]);
  }
}

Color primaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

const Color red = Color(0xFFE53935);
const Color blue = Color(0xFF1E88E5);
