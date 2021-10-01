import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class SavedDiceResult {
  final DateTime time;
  final List<int> arrDiceResults;
  SavedDiceResult(this.time, this.arrDiceResults);

  SavedDiceResult.fromJson(Map<String, dynamic> json)
      : time = DateTime.parse(json['time']),
        arrDiceResults = List<int>.from(json['arrDiceResults'].map((x) => x));

  Map<String, dynamic> toJson() => {
        'time': time.toString(),
        'arrDiceResults': arrDiceResults,
      };
}

class DiceModel extends ChangeNotifier {
  /// Internal, private state
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  static bool _useAccelerometer = true;
  static ThemeMode _themeMode = ThemeMode.system; //dark or light mode
  static final List<ShakeDetector> _detectors = <ShakeDetector>[];
  static int _diceFaces = 6;
  static int _numberOfDice = 1;
  static double _rollAnimation = 1.0;
  static double _diceWidth = 300.0;
  static Color _diceColor = Globals.appTheme.colors.secondary(true);
  static List<int> _arrDiceResults = [
    for (int i = 0; i < _numberOfDice; i++) 1
  ];
  static const int _historyLength = 100;
  static List<SavedDiceResult> _diceHistory = [];

  //Read the date from the shared preferences
  DiceModel() {
    _prefs.then((SharedPreferences pref) {
      _useAccelerometer = pref.getBool('useAccelerometer') ?? true;
      //get theme mode from shared preferences as string
      String _strTheme = pref.getString('themeMode') ??
          ThemeMode.system.toString().split('.').last;
      // Convert theme to enum
      _themeMode = ThemeMode.values
          .firstWhere((e) => e.toString() == 'ThemeMode.' + _strTheme);
      _diceFaces = pref.getInt('diceFaces') ?? 6;
      _numberOfDice = pref.getInt('numberOfDice') ?? 1;
      _rollAnimation = pref.getDouble('rollAnimation') ?? 1.0;
      _diceWidth = pref.getDouble('diceWidth') ?? 300.0;
      int _intDiceColor = pref.getInt('diceColor') ??
          Globals.appTheme.colors.secondary(true).value;
      //Convert string to color
      _diceColor = Color(_intDiceColor);
      List<String> _strArrDiceResults = pref.getStringList('arrDiceResults') ??
          [for (int i = 0; i < _numberOfDice; i++) '1'];
      //convert the list to integers
      _arrDiceResults = _strArrDiceResults.map(int.parse).toList();
      //Restore the history
      restoreHistory();
      notifyListeners();
    });
  }

  void saveRollAnimation() {
    _prefs.then((SharedPreferences pref) {
      pref.setDouble('rollAnimation', _rollAnimation);
    });
  }

  void saveDiceWidth() {
    _prefs.then((SharedPreferences pref) {
      pref.setDouble('diceWidth', _diceWidth);
    });
  }

  void saveNumberOfDice() {
    _prefs.then((SharedPreferences pref) {
      pref.setInt('numberOfDice', _numberOfDice);
    });
  }

  void saveDiceFaces() {
    _prefs.then((SharedPreferences pref) {
      pref.setInt('diceFaces', _diceFaces);
    });
  }

  void saveUseAccelerometer() {
    _prefs.then((SharedPreferences pref) {
      pref.setBool('useAccelerometer', _useAccelerometer);
    });
  }

  void saveDiceColor() {
    _prefs.then((SharedPreferences pref) {
      pref.setInt('diceColor', _diceColor.value);
    });
  }

  void saveThemeMode() {
    _prefs.then((SharedPreferences pref) {
      pref.setString('themeMode', _themeMode.toString().split('.').last);
    });
  }

  void saveArrDiceResult(List<int> diceResults) {
    _prefs.then((SharedPreferences pref) {
      pref.setStringList(
          'arrDiceResults', diceResults.map((e) => e.toString()).toList());
    });
  }

  void saveHistory(List<SavedDiceResult> diceHistory) {
    _prefs.then((SharedPreferences pref) {
      pref.setStringList(
          'diceHistory',
          diceHistory
              .map((SavedDiceResult historyItem) =>
                  json.encode(historyItem.toJson()))
              .toList());
    });
  }

  void restoreHistory() {
    _prefs.then((SharedPreferences pref) {
      List<String> strHistory = pref.getStringList('diceHistory') ?? [];

      if (strHistory.isNotEmpty) {
        _diceHistory = strHistory
            .map((String historyItem) =>
                SavedDiceResult.fromJson(jsonDecode(historyItem)))
            .toList();
      }
    });
  }

  void addAccelerometerListener() {
    if (_detectors.isEmpty) {
      _detectors.add(ShakeDetector.autoStart(onPhoneShake: () {
        rollAllDice();
      }));
    }
    notifyListeners();
  }

  void setRollAnimation(double duration) {
    _rollAnimation = duration;
    saveRollAnimation();
    notifyListeners();
  }

  void removeAccelerometerListener() {
    if (_detectors.isNotEmpty) {
      for (var detector in _detectors) {
        detector.stopListening();
      }
      _detectors.clear();
    }
    notifyListeners();
  }

  double getDiceWidth(double screenWidth) {
    _diceWidth = screenWidth / _numberOfDice;
    if (_diceWidth > 300.0) {
      _diceWidth = 300.0;
    } else if (_diceWidth < 100.0) {
      _diceWidth = 100.0;
    }
    saveDiceWidth();
    return _diceWidth;
  }

  void resetDie() {
    _numberOfDice = 1;

    saveNumberOfDice();
    if (_arrDiceResults.length > 1) {
      _arrDiceResults.removeRange(1, _arrDiceResults.length);
      saveArrDiceResult(_arrDiceResults);
    }

    notifyListeners();
  }

  void addDie() {
    _numberOfDice++;
    saveNumberOfDice();
    _arrDiceResults.add(diceRoll());
    saveArrDiceResult(_arrDiceResults);
    notifyListeners();
  }

  void addDieFace() {
    _diceFaces++;
    saveDiceFaces();
    notifyListeners();
  }

  void resetDiceFaces() {
    _diceFaces = 6;
    saveDiceFaces();
    notifyListeners();
  }

  void removeDieFace() {
    if (_diceFaces > 1) {
      _diceFaces--;
      saveDiceFaces();
    }
    notifyListeners();
  }

  void removeDie() {
    if (_numberOfDice > 1) {
      _numberOfDice--;
      saveNumberOfDice();
      _arrDiceResults.removeLast();
      saveArrDiceResult(_arrDiceResults);
    }
    notifyListeners();
  }

  int diceRoll() {
    return Random().nextInt(_diceFaces) + 1;
  }

  Future<void> rollAllDice() async {
    //Set all to -1 for the dice animation
    for (int i = 0; i < _numberOfDice; i++) {
      _arrDiceResults[i] = -1;
    }
    notifyListeners();
    await Future.delayed(
        Duration(milliseconds: (_rollAnimation * 1000).round()));
    //Now, after the animation is done, actually generate the new numbers
    for (int i = 0; i < _numberOfDice; i++) {
      _arrDiceResults[i] = diceRoll();
    }
    saveArrDiceResult(_arrDiceResults);
    //add to history
    addHistory(_arrDiceResults);
    notifyListeners();
  }

  Future<void> rollSingleDie(int index) async {
    //Set die to -1 for the die animation
    _arrDiceResults[index] = -1;
    notifyListeners();
    await Future.delayed(
        Duration(milliseconds: (_rollAnimation * 1000).round()));
    //Now, after the animation is done, actually generate the new number
    _arrDiceResults[index] = diceRoll();
    saveArrDiceResult(_arrDiceResults);
    //add to history
    addHistory(_arrDiceResults);
    notifyListeners();
  }

  void toggleUseAccelerometer() {
    _useAccelerometer = !_useAccelerometer;
    saveUseAccelerometer();
    if (_useAccelerometer) {
      addAccelerometerListener();
    } else {
      removeAccelerometerListener();
    }
    notifyListeners();
  }

  void setDiceColor(Color color) {
    _diceColor = color;
    saveDiceColor();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    saveThemeMode();
    notifyListeners();
  }

  void addHistory(List<int> diceArray) {
    if (diceArray.any((element) => element < 0)) {
      //Dices are still rolling (multiple unfinished rolls are done)
      return;
    }

    //add to history
    if (_diceHistory.length >= _historyLength) {
      //remove the oldest entry
      _diceHistory.removeAt(0);
    }
    //add new entry
    _diceHistory.add(SavedDiceResult(DateTime.now(), diceArray.toList()));
    //save the history
    saveHistory(_diceHistory);
  }

  void clearHistory() {
    _diceHistory.clear();
    notifyListeners();
    //save the cleared history
    saveHistory(_diceHistory);
  }

  int? getSum() {
    int sum = 0;
    for (int dieResult in _arrDiceResults) {
      if (dieResult < 0) return null; //dice are currently rolling
      sum += dieResult;
    }
    return sum;
  }

  /// An unmodifiable view of the items
  UnmodifiableListView<int> get getDiceArray =>
      UnmodifiableListView(_arrDiceResults);

  UnmodifiableListView<SavedDiceResult> get getDiceHistory =>
      UnmodifiableListView(_diceHistory);

  ///getters
  int get getNumberOfDice => _numberOfDice;
  int get getDiceFaces => _diceFaces;
  bool get getUseAccelerometer => _useAccelerometer;
  double get getRollAnimation => _rollAnimation;
  Color get getDiceColor => _diceColor;
  ThemeMode get getThemeMode => _themeMode;
}
