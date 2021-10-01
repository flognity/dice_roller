import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/util/language_provider/language_text_provider.dart';
import 'package:dice_roller/util/painter/paint_dice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class DiceHistoryScreen extends StatelessWidget {
  const DiceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageTextProvider.of(context).getText('history'),
          style: Globals.textStyles.caption,
        ),
        actions: [
          Consumer<DiceModel>(
            builder: (context, diceModel, child) => IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(LanguageTextProvider.of(context)
                        .getText('delete_history')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(LanguageTextProvider.of(context)
                            .getText('ask_delete_history')),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(LanguageTextProvider.of(context)
                            .getText('cancel')
                            .toUpperCase()),
                      ),
                      TextButton(
                        onPressed: () {
                          diceModel.clearHistory();
                          Navigator.of(context).pop();
                        },
                        child: Text(LanguageTextProvider.of(context)
                            .getText('delete')
                            .toUpperCase()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<DiceModel>(
        builder: (context, diceModel, child) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final reverseIndex = diceModel.getDiceHistory.length - index - 1;
              final DateTime time =
                  diceModel.getDiceHistory[reverseIndex].time.toLocal();
              final List<int> diceArray =
                  diceModel.getDiceHistory[reverseIndex].arrDiceResults;

              String formattedDateTime = time.year.toString() +
                  '-' +
                  time.month.toString().padLeft(2, '0') +
                  '-' +
                  time.day.toString().padLeft(2, '0') +
                  ' ' +
                  time.hour.toString().padLeft(2, '0') +
                  ':' +
                  time.minute.toString().padLeft(2, '0') +
                  ':' +
                  time.second.toString().padLeft(2, '0');

              int sum = 0;
              for (int dieResult in diceArray) {
                sum += dieResult;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(formattedDateTime),
                      ),
                      Text(LanguageTextProvider.of(context).getText('total') +
                          ': ' +
                          sum.toString()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: [
                        for (int dieResult in diceArray)
                          CustomPaint(
                            size: const Size(40.0, 40.0),
                            painter: PaintDice(
                              dieNumber: dieResult,
                              strokeColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              fillColor: diceModel.getDiceColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0)
                ],
              );
            },
            itemCount: diceModel.getDiceHistory.length,
          ),
        ),
      ),
    );
  }
}
