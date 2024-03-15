import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

class BaseConstrainedBox extends StatelessWidget {
  final Widget? child;

  final double? maxWidth;

  final bool hasBasePadding;

  final EdgeInsetsGeometry? padding;

  const BaseConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth,
    this.hasBasePadding = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding ??
          EdgeInsets.symmetric(horizontal: this.hasBasePadding ? 24.0 : 0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: this.maxWidth ?? Breakpoint.sm.width),
        child: this.child,
      ),
    );
  }
}
