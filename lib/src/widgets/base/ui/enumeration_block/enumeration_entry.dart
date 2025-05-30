import 'package:base_components/src/utils/design_system.dart';
import 'package:flutter/material.dart';

class EnumerationEntry extends StatelessWidget {
  final String? text;
  final Widget? customEntry;

  final double enumerationTopPadding;
  final double? enumerationSize;
  final CrossAxisAlignment enumerationAlignment;

  final int? order;
  final double levelSpacing;
  final int level;

  const EnumerationEntry({
    super.key,
    this.text,
    this.customEntry,
    this.enumerationTopPadding = 0,
    this.enumerationSize,
    this.enumerationAlignment = CrossAxisAlignment.start,
    this.order,
    this.levelSpacing = 12.0,
    this.level = 1,
  }) : assert(text != null || customEntry != null && level > 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: this.enumerationAlignment,
      children: [
        Padding(
            padding: EdgeInsets.only(
              top: this.enumerationTopPadding,
              left: this.levelSpacing * this.level,
              right: 12.0,
            ),
            child: this.order != null
                ? Text(
                    '${this.order.toString()}.',
                  )
                : Container(
                    height: enumerationSize ?? DesignSystem.size.x8,
                    width: enumerationSize ?? DesignSystem.size.x8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      borderRadius: BorderRadius.circular(
                          enumerationSize ?? DesignSystem.size.x8),
                    ))),
        Flexible(
          child: this.text != null
              ? Text(
                  this.text!,
                  style: const TextStyle(
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                )
              : this.customEntry!,
        ),
      ],
    );
  }
}
