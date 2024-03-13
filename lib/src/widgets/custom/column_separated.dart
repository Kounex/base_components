import 'package:flutter/material.dart';

import '../base/ui/divider.dart';

class CustomColumnSeparated extends StatelessWidget {
  final Iterable<Widget> children;

  final EdgeInsets padding;
  final bool useSymmetricOutsidePadding;

  final EdgeInsets paddingSeparator;
  final EdgeInsets additionalPaddingSeparator;

  final Widget? customSeparator;

  const CustomColumnSeparated({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(0),
    this.useSymmetricOutsidePadding = false,
    this.paddingSeparator = const EdgeInsets.symmetric(vertical: 12.0),
    this.additionalPaddingSeparator = const EdgeInsets.all(0.0),
    this.customSeparator,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: this.useSymmetricOutsidePadding
          ? EdgeInsets.symmetric(vertical: this.paddingSeparator.vertical / 2)
          : this.padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: this.children.length,
      separatorBuilder: (context, index) => Padding(
        padding: this.paddingSeparator + this.additionalPaddingSeparator,
        child: const BaseDivider(),
      ),
      itemBuilder: (context, index) => this.children.elementAt(index),
    );
  }
}
