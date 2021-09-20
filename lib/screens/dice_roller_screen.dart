import 'dart:ui';

import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/util/painter/paint_dice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import 'change_dice_screen.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({Key? key}) : super(key: key);

  @override
  _DiceRollerScreenState createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<DiceModel>(
          builder: (context, diceModel, child) => Text(
            'Total: ${diceModel.getSum()}',
            style: Globals.textStyles.caption,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const ChangeDiceScreen(),
          );
        },
        child: const Icon(Icons.mode_edit),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Consumer<DiceModel>(
          builder: (context, diceModel, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => diceModel.rollAllDice(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    diceModel.getNumberOfDice < 2 ? 'Roll die' : 'Roll dice',
                    style: Globals.textStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Consumer<DiceModel>(
        builder: (context, diceModel, child) => Center(
          child: ListView(
            children: [
              Column(
                children: [
                  Text(
                    diceModel.getNumberOfDice < 2
                        ? 'Touch die to roll.'
                        : 'Touch dice to roll them individually.',
                    style: Globals.textStyles.paragraph,
                  ),
                  for (int iCol = 0;
                      iCol < diceModel.getNumberOfDice;
                      iCol += diceModel.getNumberOfColumns)
                    Row(children: [
                      for (int iRow = 0;
                          iRow < diceModel.getNumberOfColumns &&
                              iCol + iRow + 1 <= diceModel.getNumberOfDice;
                          iRow++)
                        Expanded(
                          child: TextButton(
                            child: CustomPaint(
                              size: Size(
                                diceModel.getDiceWidth(_screenWidth),
                                diceModel.getDiceWidth(_screenWidth),
                              ),
                              painter: PaintDice(
                                dieNumber:
                                    diceModel.getArrDiceResults[iCol + iRow],
                                strokeColor:
                                    Theme.of(context).colorScheme.onSurface,
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            onPressed: () =>
                                diceModel.rollSingleDie(iCol + iRow),
                          ),
                        ),
                    ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
