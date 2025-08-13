import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_dialog/adaptive_dialog.dart';

class BaseConfirmationDialog extends StatelessWidget {
  final String? title;
  final String? body;
  final Widget? bodyWidget;
  final bool popDialogOnOk;
  final bool isYesDestructive;

  final String yesText;
  final String noText;

  final bool enableDontShowAgainOption;

  final TargetPlatform? platform;

  final void Function(bool isDontShowAgainChecked) onYes;

  const BaseConfirmationDialog({
    super.key,
    this.title,
    this.body,
    this.bodyWidget,
    required this.onYes,
    this.popDialogOnOk = true,
    this.isYesDestructive = false,
    this.yesText = 'Yes',
    this.noText = 'No',
    this.enableDontShowAgainOption = false,
    this.platform,
  }) : assert(body != null && bodyWidget == null ||
            body == null && bodyWidget != null);

  @override
  Widget build(BuildContext context) {
    return BaseAdaptiveDialog(
      title: this.title ?? 'Warning',
      body: this.body ??
          'Are you sure you want to do this? This action can\'t be undone!',
      bodyWidget: this.bodyWidget,
      enableDontShowAgainOption: this.enableDontShowAgainOption,
      platform: this.platform,
      actions: [
        BaseDialogAction(
          child: Text(this.noText),
          isDefaultAction: true,
        ),
        BaseDialogAction(
          onPressed: this.onYes,
          popOnAction: this.popDialogOnOk,
          child: Text(this.yesText),
          isDestructiveAction: this.isYesDestructive,
        ),
      ],
    );
    // AlertDialog.adaptive(
    //   title: Padding(
    //     padding: const EdgeInsets.only(bottom: 8.0),
    //     child: Text(this.widget.title),
    //   ),
    //   content: Column(
    //     children: [
    //       this.widget.bodyWidget ?? Text(this.widget.body!),
    //       if (this.widget.enableDontShowAgainOption)
    //         Padding(
    //           padding: const EdgeInsets.only(top: 14.0),
    //           child: Transform.translate(
    //             offset: const Offset(-4, 0),
    //             child: Row(
    //               children: [
    //                 Material(
    //                   type: MaterialType.transparency,
    //                   child: BaseCheckbox(
    //                     value: _dontShowChecked,
    //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                     onChanged: (checked) =>
    //                         setState(() => _dontShowChecked = checked!),
    //                   ),
    //                 ),
    //                 const Text('Don\'t show this again'),
    //               ],
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    //   actions: [
    //     AdaptiveDialogAction(
    //       isDefaultAction: true,
    //       onPressed: () => Navigator.of(context).pop(),
    //       child: Text(this.widget.noText),
    //     ),
    //     AdaptiveDialogAction(
    //       isDestructiveAction: this.widget.isYesDestructive,
    //       onPressed: () {
    //         if (this.widget.popDialogOnOk) Navigator.of(context).pop();
    //         this.widget.onOk(_dontShowChecked);
    //       },
    //       child: Text(this.widget.okText),
    //     ),
    //   ],
    // );
  }
}
