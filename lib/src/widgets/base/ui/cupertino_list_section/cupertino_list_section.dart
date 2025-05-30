import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../base_components.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  final Color? backgroundColor;

  final bool hasLeading;
  final double? dividerMargin;

  final Widget? header;
  final Widget? footer;

  final String? footerText;

  const BaseCupertinoListSection(
      {super.key,
      this.tiles,
      this.customChildren,
      this.backgroundColor,
      this.hasLeading = true,
      this.dividerMargin,
      this.header,
      this.footer,
      this.footerText});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      decoration: BoxDecoration(
          color: this.backgroundColor ?? Theme.of(context).cardColor),
      margin: EdgeInsets.zero,
      dividerMargin: this.hasLeading ? (this.dividerMargin ?? 23.0) : 0,
      hasLeading: this.hasLeading,
      header: this.header,
      footer: this.footer ??
          (this.footerText != null
              ? Padding(
                  padding: EdgeInsets.only(top: DesignSystem.spacing.x8),
                  child: Text(
                    this.footerText!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: CupertinoColors.secondaryLabel
                              .resolveFrom(context),
                        ),
                  ),
                )
              : null),
      children: this.customChildren ?? this.tiles,
    );
  }
}
