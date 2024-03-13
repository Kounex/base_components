import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptive_dialog/adaptive_dialog.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? body;
  final Widget? bodyWidget;
  final bool popDialogOnOk;
  final bool isYesDestructive;

  final String yesText;
  final String noText;

  final bool enableDontShowAgainOption;

  final void Function(bool isDontShowAgainChecked) onYes;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.body,
    this.bodyWidget,
    required this.onYes,
    this.popDialogOnOk = true,
    this.isYesDestructive = false,
    this.yesText = 'Yes',
    this.noText = 'No',
    this.enableDontShowAgainOption = false,
  }) : assert(body != null && bodyWidget == null ||
            body == null && bodyWidget != null);

  @override
  Widget build(BuildContext context) {
    return BaseAdaptiveDialog(
      title: this.title,
      body: this.body,
      bodyWidget: this.bodyWidget,
      enableDontShowAgainOption: this.enableDontShowAgainOption,
      actions: [
        DialogActionConfig(
          child: Text(this.noText),
          isDefaultAction: true,
        ),
        DialogActionConfig(
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
