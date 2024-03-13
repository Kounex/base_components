import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../base_components.dart';

class WebScaffold extends StatelessWidget {
  final Iterable<Widget> children;

  final double? horizontalPadding;
  final double? verticalPadding;

  final bool fadeIn;
  final bool staggered;

  const WebScaffold({
    super.key,
    required this.children,
    this.horizontalPadding,
    this.verticalPadding,
    this.fadeIn = false,
    this.staggered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        // final rb = context.findRenderObject() as RenderBox;
        // final result = BoxHitTestResult();
        // rb.hitTest(result, position: e.position);

        // for (final e in result.path) {
        //   if (e.target is RenderEditable) {
        //     return;
        //   }
        // }

        // FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: this.horizontalPadding ?? DesignSystem.spacing.x24),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: fadeIn
                    ? SliverChildListDelegate.fixed(
                        List.from(
                          children.mapIndexed(
                            (index, child) => Fader(
                              delay: this.staggered
                                  ? Duration(milliseconds: 75 * index)
                                  : Duration.zero,
                              child: child,
                            ),
                          ),
                        ),
                      )
                    : SliverChildBuilderDelegate(
                        (context, index) =>
                            index == 0 || index == children.length + 1
                                ? SizedBox(
                                    height: this.verticalPadding ??
                                        DesignSystem.spacing.x24,
                                  )
                                : children.elementAt(index - 1),
                        childCount: children.length + 2,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
