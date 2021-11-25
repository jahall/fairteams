import 'dart:math';
import 'package:flutter/material.dart';

const Color red = Color(0xFFD32F2F); // Colors.red[700]
const Color blue = Color(0xFF1976D2); // Colors.blue[700]

Color primaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color secondaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.secondary;
}

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
