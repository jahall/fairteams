import 'dart:async';
import 'package:flutter/material.dart';

import 'package:fairteams/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Home(title: 'Fair Teams')));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage('assets/brand.png'));
  }
}
