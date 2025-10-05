import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

class BaseDialogAction {
  final Widget child;

  final bool isDestructiveAction;
  final bool isDefaultAction;

  final bool popOnAction;

  final void Function(bool isDontShowAgainChecked)? onPressed;

  BaseDialogAction({
    required this.child,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
    this.popOnAction = true,
    this.onPressed,
  });
}

class BaseAdaptiveDialog extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;

  final String? body;
  final Widget? bodyWidget;

  final bool enableDontShowAgainOption;

  final List<BaseDialogAction>? actions;

  final TargetPlatform? platform;

  const BaseAdaptiveDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.body,
    this.bodyWidget,
    this.enableDontShowAgainOption = false,
    this.actions,
    this.platform,
  }) : assert(body != null || bodyWidget != null);

  @override
  State<BaseAdaptiveDialog> createState() => _BaseAdaptiveDialogState();
}

class _BaseAdaptiveDialogState extends State<BaseAdaptiveDialog> {
  bool _isDontShowChecked = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(platform: this.widget.platform),
      child: AlertDialog.adaptive(
        title: this.widget.titleWidget ??
            (this.widget.title != null
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: DesignSystem.isApple(context)
                          ? DesignSystem.spacing.x8
                          : 0.0,
                    ),
                    child: Text(this.widget.title!),
                  )
                : null),
        contentPadding:
            EdgeInsets.symmetric(horizontal: DesignSystem.spacing.x24) +
                EdgeInsets.only(
                  top: this.widget.title == null &&
                          this.widget.titleWidget == null
                      ? DesignSystem.spacing.x24
                      : DesignSystem.spacing.x16,
                  bottom: DesignSystem.spacing.x12,
                ),
        backgroundColor: Theme.of(context).cardTheme.color,
        elevation: 0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            this.widget.bodyWidget ?? Text(this.widget.body!),
            if (this.widget.enableDontShowAgainOption)
              Padding(
                padding: EdgeInsets.only(top: DesignSystem.spacing.x24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    type: MaterialType.transparency,
                    child: BaseCheckbox(
                      value: _isDontShowChecked,
                      text: 'Don\'t show this again',
                      smallText: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (checked) =>
                          setState(() => _isDontShowChecked = checked!),
                    ),
                  ),
                ),
              ),
          ],
        ),
        actions: this
            .widget
            .actions
            ?.map(
              (config) => AdaptiveDialogAction(
                onPressed: () {
                  if (config.popOnAction) {
                    Navigator.of(context).pop();
                  }
                  config.onPressed?.call(_isDontShowChecked);
                },
                isDefaultAction: config.isDefaultAction,
                isDestructiveAction: config.isDestructiveAction,
                child: config.child,
              ),
            )
            .toList(),
      ),
    );
  }
}
