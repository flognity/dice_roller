import 'dart:ui';

import 'package:flutter/material.dart';

import '../../globals.dart';

//paint the dice
class PaintDice extends CustomPainter {
  int dieNumber;
  Color strokeColor;
  Color fillColor;
  PaintDice(
      {required this.dieNumber,
      required this.strokeColor,
      required this.fillColor});

  RRect rRectForDice(Size size) {
    return RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.05, size.width * 0.9,
            size.height * 0.9),
        bottomRight: Radius.circular(size.width * 0.15),
        bottomLeft: Radius.circular(size.width * 0.15),
        topLeft: Radius.circular(size.width * 0.15),
        topRight: Radius.circular(size.width * 0.15));
  }

  void drawCircle(
    Canvas canvas,
    double width,
    Offset offset,
    Paint stroke,
    Paint fill,
  ) {
    //draw the circle's stroke
    canvas.drawCircle(offset, width * 0.07, stroke);
    //draw the circle's filling
    canvas.drawCircle(offset, width * 0.07, fill);
  }

  @override
  void paint(Canvas canvas, Size size) {
    //define the main stroke
    Paint paintMainStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = strokeColor.withOpacity(1)
      ..strokeWidth = size.width * 0.04;
    //define the main filling
    Paint paintMainFill = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    //define the secondary filling
    Paint paintSecondFill = Paint()
      ..style = PaintingStyle.fill
      ..color = strokeColor.withOpacity(1.0);

    //draw the die border stroke and filling
    canvas.drawRRect(rRectForDice(size), paintMainStroke);
    canvas.drawRRect(rRectForDice(size), paintMainFill);

    //draw the die face circles
    switch (dieNumber) {
      case -1:
        //No dice number -> animate the dices
        //Nothing to do here...
        break;
      case 1:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.5, size.height * 0.5),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      case 2:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      case 3:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.5, size.height * 0.5),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      case 4:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      case 5:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.5, size.height * 0.5),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      case 6:
        {
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.25, size.height * 0.5),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.25),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.75),
              paintMainStroke,
              paintSecondFill);
          drawCircle(
              canvas,
              size.width,
              Offset(size.width * 0.75, size.height * 0.5),
              paintMainStroke,
              paintSecondFill);
        }
        break;
      default:
        {
          TextPainter textPainter = TextPainter(
              text: TextSpan(
                  text: dieNumber.toString(),
                  style: Globals.textStyles.dieNumber.copyWith(
                    color: strokeColor,
                    fontSize: size.width * 0.4,
                  )),
              textDirection: TextDirection.ltr)
            ..layout(maxWidth: size.width);
          textPainter.paint(
              canvas,
              Offset(
                (size.width - textPainter.width) * 0.5,
                (size.height - textPainter.height) * 0.5,
              ));
        }
        break;
    }
  }

  @override
  bool shouldRepaint(PaintDice oldDelegate) {
    bool dieChange = dieNumber != oldDelegate.dieNumber;
    bool strokeChange = strokeColor != oldDelegate.strokeColor;
    bool fillColorChange = fillColor != oldDelegate.fillColor;

    return dieChange || strokeChange || fillColorChange;
  }
}
