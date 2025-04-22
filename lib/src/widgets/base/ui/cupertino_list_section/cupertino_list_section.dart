import 'package:base_components/src/utils/design_system.dart';
import 'package:base_components/src/widgets/base/ui/cupertino_list_section/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  final bool hasLeading;

  const BaseCupertinoListSection(
      {super.key, this.tiles, this.customChildren, this.hasLeading = true});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      additionalDividerMargin: DesignSystem.spacing.x32,
      hasLeading: this.hasLeading,
      children: this.customChildren ?? this.tiles,
    );
  }
}
