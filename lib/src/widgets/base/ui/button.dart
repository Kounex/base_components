import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final String? text;
  final Widget? child;

  final bool loading;

  final Widget? icon;

  final bool secondary;

  final Color? color;

  /// Used to override the [minimumSize] (will be 0 "extra" width) so the
  /// width of the button can be more granulary set with the [padding] property
  final bool shrinkWidth;

  final VoidCallback? onPressed;
  final bool isDestructive;

  final EdgeInsetsGeometry? padding;

  const BaseButton({
    super.key,
    this.text,
    this.child,
    this.loading = false,
    this.icon,
    this.secondary = false,
    this.color,
    this.shrinkWidth = false,
    this.onPressed,
    this.isDestructive = false,
    this.padding,
  }) : assert(child != null || text != null);

  @override
  Widget build(BuildContext context) {
    final child = switch (true) {
      _ when this.loading => BaseProgressIndicator(size: DesignSystem.size.x24),
      _ => this.child ??
          FittedBox(
            child: Text(this.text!),
          ),
    };

    final ButtonStyle style = ElevatedButton.styleFrom(
      padding: this.padding,
      elevation: 0,
      backgroundColor: this.isDestructive
          ? CupertinoColors.destructiveRed
          : this.secondary
              ? Colors.transparent
              : this.color ??
                  Theme.of(context).buttonTheme.colorScheme!.secondary,
      minimumSize: this.shrinkWidth ? const Size(0, 36) : null,
      side: !this.isDestructive && this.secondary
          ? BorderSide(
              color: this.color ??
                  Theme.of(context).buttonTheme.colorScheme!.secondary,
              width: 1.0,
            )
          : null,
      foregroundColor: DesignSystem.surroundingAwareAccent(
        surroundingColor: this.isDestructive
            ? CupertinoColors.destructiveRed
            : this.secondary
                ? Theme.of(context).cardTheme.color
                : this.color ??
                    Theme.of(context).buttonTheme.colorScheme!.secondary,
      ),
    );

    return this.icon != null
        ? ElevatedButton.icon(
            style: style,
            icon: this.icon!,
            label: child,
            onPressed: this.loading ? null : this.onPressed,
          )
        : ElevatedButton(
            style: style,
            onPressed: this.loading ? null : this.onPressed,
            child: child,
          );
  }
}
