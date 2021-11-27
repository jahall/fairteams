import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/splash.dart';

MaterialColor swatch = const MaterialColor(
  // Generated from https://maketintsandshades.com/#1976D2
  0xff1976d2, // Colors.blue[700]
  <int, Color>{
    50: Color(0xff75ade4),
    100: Color(0xff75ade4),
    200: Color(0xff5e9fe0),
    300: Color(0xff4791db),
    400: Color(0xff3084d7),
    500: Color(0xff1976d2), // Colors.blue[700]
    600: Color(0xff176abd),
    700: Color(0xff145ea8),
    800: Color(0xff125393),
    900: Color(0xff0f477e),
  },
);

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: swatch,
      fontFamily: 'Montserrat',
      floatingActionButtonTheme:
          // this defaults to the secondary color otherwise
          FloatingActionButtonThemeData(backgroundColor: Colors.blue[700]),
    );
    // necessary awkward way to specify secondary color
    // https://docs.flutter.dev/release/breaking-changes/theme-data-accent-properties
    theme = theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.green[700]));
    return MaterialApp(
      title: 'Fair Teams',
      theme: theme,
      home: const Splash(),
    );
  }
}
