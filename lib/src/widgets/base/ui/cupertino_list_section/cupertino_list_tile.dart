import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;

  final void Function()? onTap;

  final Widget? leading;
  final IconData? leadingIcon;
  final double? leadingSize;

  final Widget? additionalInfo;

  const BaseCupertinoListTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.onTap,
      this.leading,
      this.leadingIcon,
      this.leadingSize,
      this.additionalInfo});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: this.onTap,
      leading: this.leading ??
          (this.leadingIcon != null ? Icon(this.leadingIcon) : null),
      backgroundColor: Theme.of(context).cardTheme.color,
      leadingSize: this.leadingSize ?? 20,
      additionalInfo: this.additionalInfo,
      title: this.title,
      subtitle: this.subtitle,
    );
  }
}
