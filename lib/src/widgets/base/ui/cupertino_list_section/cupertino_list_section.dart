import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../base_components.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  final Color? backgroundColor;

  final bool useSeparators;

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
      this.useSeparators = true,
      this.hasLeading = true,
      this.dividerMargin,
      this.header,
      this.footer,
      this.footerText})
      : assert(tiles != null || customChildren != null);

  @override
  Widget build(BuildContext context) {
    final children = (this.customChildren ?? this.tiles)!;

    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      // dividerMargin: this.hasLeading ? (this.dividerMargin ?? 23.0) : 0,
      // hasLeading: this.hasLeading,
      dividerMargin: 0,
      additionalDividerMargin: 0,
      separatorColor: backgroundColor ?? Theme.of(context).cardColor,
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
      children: [
        for (final (index, tile) in children.indexed) ...[
          tile,
          if (index < children.length - 1)
            Padding(
              padding: EdgeInsets.only(
                  top: DesignSystem.spacing.x2,
                  left: this.hasLeading
                      ? DesignSystem.spacing.x64 + DesignSystem.spacing.x2
                      : DesignSystem.spacing.x24),
              child: Divider(
                color: CupertinoColors.separator.resolveFrom(context),
                height: 0,
                thickness: 0.5,
              ),
            ),
        ],
      ],
    );
  }
}
