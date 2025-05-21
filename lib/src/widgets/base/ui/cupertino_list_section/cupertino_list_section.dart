import 'package:base_components/src/widgets/base/ui/cupertino_list_section/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  final bool hasLeading;
  final double? dividerMargin;

  final Widget? header;
  final Widget? footer;

  const BaseCupertinoListSection(
      {super.key,
      this.tiles,
      this.customChildren,
      this.hasLeading = true,
      this.dividerMargin,
      this.header,
      this.footer});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      dividerMargin: this.hasLeading ? this.dividerMargin ?? 23.0 : 0,
      hasLeading: this.hasLeading,
      header: this.header,
      footer: this.footer,
      children: this.customChildren ?? this.tiles,
    );
  }
}
