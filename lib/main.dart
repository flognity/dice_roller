import 'package:dice_roller/screens/dice_roller_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'globals.dart';
import 'models/dice_model.dart';

void main() {
  runApp(const DiceRollerApp());
}

class DiceRollerApp extends StatelessWidget {
  const DiceRollerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiceModel(),
      child: MaterialApp(
        title: Globals.appName,
        theme: Globals.appTheme.getTheme(isDarkTheme: false),
        darkTheme: Globals.appTheme.getTheme(isDarkTheme: true),
        home: const DiceRollerScreen(),
      ),
    );
  }
}
