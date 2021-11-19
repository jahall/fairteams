import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: child,
      )
    ]);
  }
}
