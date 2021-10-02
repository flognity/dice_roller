import 'package:dice_roller/models/ad_state.dart';
import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/util/language_provider/language_text_provider.dart';
import 'package:dice_roller/util/painter/paint_dice.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class DiceHistoryScreen extends StatefulWidget {
  final List<SavedDiceResult> diceHistory;
  final Color diceColor;

  const DiceHistoryScreen(
      {required this.diceHistory, required this.diceColor, Key? key})
      : super(key: key);

  @override
  State<DiceHistoryScreen> createState() => _DiceHistoryScreenState();
}

class _DiceHistoryScreenState extends State<DiceHistoryScreen> {
  final List<BannerAd?> _bannerAdList = [];
  static const int _bannerInterval = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((InitializationStatus status) {
      setState(() {
        for (int i = 0; i <= widget.diceHistory.length / _bannerInterval; i++) {
          _bannerAdList.add(BannerAd(
            adUnitId: adState.bannerAdUnitIdDiceScreen,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: adState.bannerAdListener,
          )..load());
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (BannerAd? bannerAd in _bannerAdList) {
      bannerAd?.dispose();
    }
  }

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final reverseIndex = widget.diceHistory.length - index - 1;
            final DateTime time =
                widget.diceHistory[reverseIndex].time.toLocal();
            final List<int> diceArray =
                widget.diceHistory[reverseIndex].arrDiceResults;

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

            Widget _historyItemWidget = Column(
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
                            fillColor: widget.diceColor,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0)
              ],
            );

            Widget _finalWidget;
            if (_bannerAdList.isNotEmpty && index % _bannerInterval == 0) {
              //show banner
              int bannerIndex = index ~/ _bannerInterval;
              _finalWidget = Column(
                children: [
                  _historyItemWidget,
                  if (_bannerAdList[bannerIndex] == null)
                    const SizedBox(height: 50.0)
                  else
                    SizedBox(
                      height: 50.0,
                      child: AdWidget(ad: _bannerAdList[bannerIndex]!),
                    )
                ],
              );
            } else {
              _finalWidget = _historyItemWidget;
            }

            return _finalWidget;
          },
          itemCount: widget.diceHistory.length,
        ),
      ),
    );
  }
}
