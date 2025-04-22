import 'package:flutter/material.dart';

class BaseCupertinoListTileIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const BaseCupertinoListTileIcon(
    this.icon, {
    super.key,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size),
      ),
      child: Center(child: Icon(icon, size: size, color: iconColor)),
    );
  }
}
