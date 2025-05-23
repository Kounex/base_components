import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'enumeration_entry.dart';

class EnumerationBlock extends StatelessWidget {
  final String? title;

  final bool ordered;
  final List<String>? entries;
  final double? enumerationSize;
  final CrossAxisAlignment enumerationAlignment;

  final List<EnumerationEntry>? customEntries;

  final double entrySpacing;

  const EnumerationBlock({
    super.key,
    this.title,
    this.ordered = false,
    this.entries,
    this.enumerationSize,
    this.customEntries,
    this.enumerationAlignment = CrossAxisAlignment.start,
    this.entrySpacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> usedEntries = List.from(
      (this.entries?.mapIndexed((index, text) => EnumerationEntry(
                  text: text,
                  enumerationSize: this.enumerationSize,
                  order: this.ordered ? index : null)) ??
              this.customEntries ??
              [])
          .expand((entry) => [
                entry,
                SizedBox(height: this.entrySpacing),
              ]),
    );

    if (usedEntries.isNotEmpty) usedEntries.removeLast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (this.title != null) ...[
          Text(this.title!),
          const SizedBox(height: 6.0),
        ],
        ...usedEntries,
        // if (usedEntries.isNotEmpty) SizedBox(height: 6.0),
      ],
    );
  }
}
