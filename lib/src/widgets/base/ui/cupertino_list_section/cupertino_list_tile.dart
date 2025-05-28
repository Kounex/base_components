import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;

  final Color? backgroundColor;

  final void Function()? onTap;

  final Widget? leading;

  final IconData? leadingIcon;
  final bool leadingIconBorder;
  final Color? leadingIconColor;
  final Color? leadingIconBackgroundColor;

  final double? leadingSize;
  final double leadingToTitle;

  final Widget? additionalInfo;

  const BaseCupertinoListTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.backgroundColor,
      this.onTap,
      this.leading,
      this.leadingIcon,
      this.leadingIconBorder = false,
      this.leadingIconColor,
      this.leadingIconBackgroundColor,
      this.leadingSize,
      this.leadingToTitle = 16.0,
      this.additionalInfo});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: this.onTap,
      // leading: this.leading ??
      //     (this.leadingIcon != null
      //         ? BaseCupertinoListTileIcon(
      //             this.leadingIcon!,
      //             iconColor: this.leadingIconColor ?? Colors.white,
      //             backgroundColor:
      //                 this.leadingIconBackgroundColor ?? Colors.blue,
      //             border: this.leadingIconBorder,
      //           )
      //         : null),
      backgroundColor:
          this.backgroundColor ?? Theme.of(context).cardTheme.color,
      leadingSize: this.leadingSize ?? DesignSystem.size.x28,
      additionalInfo: this.additionalInfo,
      title: Row(
        children: [
          this.leading ??
              (this.leadingIcon != null
                  ? BaseCupertinoListTileIcon(
                      this.leadingIcon!,
                      iconColor: this.leadingIconColor ?? Colors.white,
                      backgroundColor:
                          this.leadingIconBackgroundColor ?? Colors.blue,
                      border: this.leadingIconBorder,
                    )
                  : const SizedBox()),
          SizedBox(width: DesignSystem.spacing.x12),
          this.title,
        ],
      ),
      subtitle: this.subtitle,
    );
  }
}
