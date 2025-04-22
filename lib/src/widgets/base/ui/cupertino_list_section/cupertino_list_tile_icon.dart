import 'package:base_components/src/utils/design_system.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListTileIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double? size;
  final bool border;

  const BaseCupertinoListTileIcon(
    this.icon, {
    super.key,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.size,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size ?? DesignSystem.size.x28,
      height: this.size ?? DesignSystem.size.x28,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: Theme.of(context).disabledColor,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.border.radius6),
      ),
      child: Center(child: Icon(icon, size: size, color: iconColor)),
    );
  }
}
