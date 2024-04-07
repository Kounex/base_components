import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseErrorText extends StatelessWidget {
  final String error;
  final bool center;

  /// If [false] (default) we will make use of [CupertinoColors.destructiveRed]
  /// and if [true] we will use [Theme.of(context).colorScheme.error]
  final bool useThemeError;

  final bool dense;
  final TextStyle? style;

  const BaseErrorText(
    this.error, {
    super.key,
    this.center = true,
    this.useThemeError = false,
    this.dense = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = (this.style ??
            (this.dense
                ? Theme.of(context).textTheme.labelMedium!
                : const TextStyle()))
        .copyWith(
      color: this.useThemeError
          ? Theme.of(context).colorScheme.error
          : CupertinoColors.destructiveRed,
    );

    return Text(
      this.error,
      textAlign: this.center ? TextAlign.center : null,
      style: style,
    );
  }
}
