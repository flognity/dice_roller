import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class DiceModel extends ChangeNotifier {
  /// Internal, private state
  static int _diceFaces = 6;
  static int _numberOfDice = 1;
  static int _numberOfColumns = 3;
  static double diceWidth = 300.0;
  final List<int> _arrDiceResults = [for (int i = 0; i < _numberOfDice; i++) 1];

  void adjustNumberOfColumns() {
    if (_numberOfDice < 4) {
      _numberOfColumns = _numberOfDice;
    }
  }

  double getDiceWidth(double screenWidth) {
    double diceWidth = screenWidth / _numberOfColumns;
    if (diceWidth > 300.0) {
      diceWidth = 300.0;
    }
    return diceWidth;
  }

  //MediaQuery.of(context).size.width

  void addDie() {
    _numberOfDice++;
    _arrDiceResults.add(diceRoll());
    adjustNumberOfColumns();
    notifyListeners();
  }

  void removeDie() {
    if (_numberOfDice > 1) {
      _numberOfDice--;
      _arrDiceResults.removeLast();
      adjustNumberOfColumns();
    }
    notifyListeners();
  }

  int diceRoll() {
    return Random().nextInt(_diceFaces) + 1;
  }

  void rollAllDice() {
    for (int i = 0; i < _numberOfDice; i++) {
      _arrDiceResults[i] = diceRoll();
    }
    notifyListeners();
  }

  void rollSingleDie(int index) {
    _arrDiceResults[index] = diceRoll();
    notifyListeners();
  }

  int getSum() {
    int sum = 0;
    for (int dieNumber in _arrDiceResults) {
      sum += dieNumber;
    }
    return sum;
  }

  /// An unmodifiable view of the items
  UnmodifiableListView<int> get getArrDiceResults =>
      UnmodifiableListView(_arrDiceResults);

  ///getters and setters
  int get getNumberOfDice => _numberOfDice;
  set setNumberOfDice(int value) => {_numberOfDice = value};
  int get getDiceFaces => _diceFaces;
  set setDiceFaces(int value) => {_diceFaces = value};
  int get getNumberOfColumns => _numberOfColumns;
}
