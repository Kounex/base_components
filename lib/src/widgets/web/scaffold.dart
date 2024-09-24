import 'package:base_components/base_components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class WebScaffold extends StatelessWidget {
  final Iterable<Widget> children;

  final double? horizontalPadding;
  final double? verticalPadding;

  final bool fadeIn;
  final bool staggered;

  /// In case we want the content to be constrained to a specific width
  final bool constrained;
  final double? maxWidth;

  const WebScaffold({
    super.key,
    required this.children,
    this.horizontalPadding,
    this.verticalPadding,
    this.fadeIn = false,
    this.staggered = true,
    this.constrained = false,
    this.maxWidth,
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
          child: Center(
            child: BaseConstrainedBox(
              maxWidth: this.maxWidth ?? double.infinity,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: fadeIn
                        ? SliverChildListDelegate.fixed(
                            [
                              SizedBox(
                                height: (this.verticalPadding ??
                                        DesignSystem.spacing.x24) +
                                    MediaQuery.paddingOf(context).top,
                              ),
                              ...List.from(
                                children.mapIndexed(
                                  (index, child) => Fader(
                                    delay: this.staggered
                                        ? Duration(milliseconds: 75 * index)
                                        : Duration.zero,
                                    child: child,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: this.verticalPadding ??
                                    DesignSystem.spacing.x24,
                              ),
                            ],
                          )
                        : SliverChildBuilderDelegate(
                            (context, index) =>
                                index == 0 || index == children.length + 1
                                    ? SizedBox(
                                        height: (this.verticalPadding ??
                                                DesignSystem.spacing.x24) +
                                            MediaQuery.paddingOf(context).top,
                                      )
                                    : children.elementAt(index - 1),
                            childCount: children.length + 2,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
