import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCard extends StatefulWidget {
  final Widget child;
  final bool centerChild;

  final bool expanded;
  final bool expandable;
  final bool expandOnHeaderClick;
  final void Function(bool expanded)? onExpand;

  final Widget? above;
  final Widget? below;

  final bool constrained;
  final CrossAxisAlignment constrainedAlignment;
  final MainAxisSize? mainAxisSize;

  final Color? backgroundColor;
  final bool paintBorder;
  final Color? borderColor;

  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;

  final Widget? trailingTitleWidget;

  final double? topPadding;
  final double? rightPadding;
  final double? bottomPadding;
  final double? leftPadding;

  final EdgeInsetsGeometry? paddingChild;
  final EdgeInsetsGeometry? titlePadding;

  final CrossAxisAlignment titleCrossAlignment;

  final double elevation;

  final double? borderRadius;

  const BaseCard({
    super.key,
    required this.child,
    this.expanded = false,
    this.expandable = false,
    this.expandOnHeaderClick = false,
    this.onExpand,
    this.above,
    this.below,
    this.centerChild = true,
    this.constrained = true,
    this.constrainedAlignment = CrossAxisAlignment.start,
    this.mainAxisSize,
    this.backgroundColor,
    this.paintBorder = false,
    this.borderColor,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.trailingTitleWidget,
    this.paddingChild,
    this.topPadding,
    this.rightPadding,
    this.bottomPadding,
    this.leftPadding,
    this.titlePadding,
    this.titleCrossAlignment = CrossAxisAlignment.center,
    this.elevation = 1.0,
    this.borderRadius,
  });

  @override
  State<BaseCard> createState() => _BaseCardState();
}

class _BaseCardState extends State<BaseCard> {
  int _expandedTurn = 0;

  @override
  void initState() {
    super.initState();

    _expandedTurn = this.widget.expanded ? 0 : 1;
  }

  @override
  void didUpdateWidget(covariant BaseCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.expanded != oldWidget.expanded &&
        this.widget.expanded != (_expandedTurn % 2 == 0)) {
      setState(() => _expandedTurn++);
    }
  }

  void _expand() => this.widget.expandable
      ? () => setState(() {
            _expandedTurn++;
            this.widget.onExpand?.call(_expandedTurn % 2 == 0);
          })
      : null;

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: this.widget.backgroundColor != null &&
              this.widget.backgroundColor!.value == Colors.transparent.value
          ? Colors.transparent
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            this.widget.borderRadius ?? DesignSystem.border.radius12),
        side: this.widget.paintBorder
            ? BorderSide(color: this.widget.borderColor ?? Colors.transparent)
            : BorderSide.none,
      ),
      color: this.widget.backgroundColor ?? Theme.of(context).cardTheme.color,
      elevation: this.widget.elevation,
      margin: EdgeInsets.only(
        top: this.widget.topPadding ?? DesignSystem.spacing.x18,
        right: this.widget.rightPadding ?? DesignSystem.spacing.x16,
        bottom: this.widget.bottomPadding ?? DesignSystem.spacing.x18,
        left: this.widget.leftPadding ?? DesignSystem.spacing.x16,
      ),
      child: Column(
        mainAxisAlignment: this.widget.centerChild
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: this.widget.centerChild
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: this.widget.mainAxisSize ?? MainAxisSize.min,
        children: [
          if (this.widget.titleWidget != null || this.widget.title != null)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: this.widget.expandOnHeaderClick ? _expand : null,
              child: Padding(
                padding: this.widget.titlePadding ??
                    EdgeInsets.only(
                      left: DesignSystem.spacing.x24,
                      right: DesignSystem.spacing.x24,
                      top: DesignSystem.spacing.x12,
                      bottom: DesignSystem.spacing.x12,
                    ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: this.widget.titleWidget == null
                            ? Text(
                                this.widget.title!,
                                style: this.widget.titleStyle ??
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            : this.widget.titleWidget!),
                    if (this.widget.trailingTitleWidget != null)
                      Row(
                        children: [
                          if (this.widget.trailingTitleWidget
                              case var trailingTitleWidget?)
                            trailingTitleWidget,
                          if (this.widget.expandable)
                            AnimatedRotation(
                              duration:
                                  DesignSystem.animation.defaultDurationMS250,
                              turns: _expandedTurn / 2,
                              curve: Curves.easeInCubic,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(32),
                                onTap: !this.widget.expandOnHeaderClick
                                    ? _expand
                                    : null,
                                // behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  height: 32.0,
                                  width: 32.0,
                                  child: Icon(
                                    CupertinoIcons.chevron_up,
                                    color: this.widget.onExpand == null &&
                                            !this.widget.expandable
                                        ? Theme.of(context).disabledColor
                                        : null,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          AnimatedAlign(
            duration: DesignSystem.animation.defaultDurationMS250,
            heightFactor: _expandedTurn % 2 == 0 ? 1.0 : 0.0,
            alignment: const Alignment(0, -1),
            curve: Curves.easeInCubic,
            child: AnimatedOpacity(
              duration: DesignSystem.animation.defaultDurationMS250,
              opacity: _expandedTurn % 2 == 0 ? 1.0 : 0.0,
              curve: Curves.easeInCubic,
              child: Column(
                children: [
                  if (this.widget.titleWidget != null ||
                      this.widget.title != null)
                    const BaseDivider(),
                  Padding(
                    padding: this.widget.paddingChild ??
                        EdgeInsets.all(DesignSystem.spacing.x18),
                    child: this.widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (!this.widget.constrained) return card;

    return Center(
      child: BaseConstrainedBox(
        child: Column(
          crossAxisAlignment: this.widget.constrainedAlignment,
          mainAxisSize: this.widget.mainAxisSize ?? MainAxisSize.min,
          children: [
            if (this.widget.above != null) this.widget.above!,
            card,
            if (this.widget.below != null) this.widget.below!,
          ],
        ),
      ),
    );
  }
}
