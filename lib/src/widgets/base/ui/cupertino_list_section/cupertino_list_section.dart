import 'package:base_components/src/utils/design_system.dart';
import 'package:base_components/src/widgets/base/ui/cupertino_list_section/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  final bool hasLeading;
  final double? dividerMargin;

  const BaseCupertinoListSection(
      {super.key,
      this.tiles,
      this.customChildren,
      this.hasLeading = true,
      this.dividerMargin});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      dividerMargin: this.hasLeading
          ? this.dividerMargin ?? DesignSystem.spacing.x24
          : 14.0,
      hasLeading: this.hasLeading,
      children: this.customChildren ?? this.tiles,
    );
  }
}
