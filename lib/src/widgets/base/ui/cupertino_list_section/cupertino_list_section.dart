import 'package:base_components/src/widgets/base/ui/cupertino_list_section/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCupertinoListSection extends StatelessWidget {
  final List<BaseCupertinoListTile>? tiles;
  final List<Widget>? customChildren;

  const BaseCupertinoListSection({super.key, this.tiles, this.customChildren});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      children: this.customChildren ?? this.tiles,
    );
  }
}
