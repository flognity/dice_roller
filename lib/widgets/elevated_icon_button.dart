import 'package:flutter/material.dart';

class ElevatedIconButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  const ElevatedIconButton(
      {required this.onPressed, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          icon,
          size: 35.0,
        ),
      ),
    );
  }
}
