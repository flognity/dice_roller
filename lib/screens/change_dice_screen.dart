import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/widgets/elevated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class ChangeDiceScreen extends StatelessWidget {
  const ChangeDiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiceModel>(
      builder: (context, diceModel, child) => Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Number of dice',
              style: Globals.textStyles.caption,
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedIconButton(
                  icon: Icons.remove,
                  onPressed: () {
                    diceModel.removeDie();
                  },
                ),
                Text(
                  '${diceModel.getNumberOfDice}',
                  style: Globals.textStyles.caption,
                ),
                ElevatedIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    diceModel.addDie();
                  },
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: Globals.textStyles.button,
                ))
          ],
        ),
      ),
    );
  }
}
