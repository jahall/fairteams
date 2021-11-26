import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/splash.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primaryColor: Colors.blue[700],
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
