import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseErrorText extends StatelessWidget {
  final String error;
  final bool center;

  /// If [false] (default) we will make use of [CupertinoColors.destructiveRed]
  /// and if [true] we will use [Theme.of(context).colorScheme.error]
  final bool useThemeError;

  const BaseErrorText({
    super.key,
    required this.error,
    this.center = false,
    this.useThemeError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      this.error,
      textAlign: this.center ? TextAlign.center : null,
      style: TextStyle(
        color: this.useThemeError
            ? Theme.of(context).colorScheme.error
            : CupertinoColors.destructiveRed,
      ),
    );
  }
}
