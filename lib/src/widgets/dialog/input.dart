import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base/functional/adaptive_text_field.dart';
import 'adaptive_dialog/adaptive_dialog.dart';

class BaseInputDialog extends StatefulWidget {
  final String title;
  final String body;

  final String? inputText;
  final String? inputPlaceholder;

  final bool clearButton;
  final bool clearButtonVisibleWithoutFocus;

  final String? deleteText;
  final String? cancelText;
  final String? saveText;

  final void Function(String?)? onSave;
  final void Function()? onDelete;

  /// Works like validation - return an empty String to tell it is valid and otherwise
  /// the error text which should be displayed (prevents the 'Ok' dialog callback)
  final String? Function(String?)? inputCheck;

  const BaseInputDialog({
    super.key,
    required this.title,
    required this.body,
    this.onSave,
    this.onDelete,
    this.deleteText,
    this.cancelText,
    this.saveText,
    this.inputText,
    this.inputPlaceholder,
    this.inputCheck,
    this.clearButton = true,
    this.clearButtonVisibleWithoutFocus = true,
  });

  @override
  _BaseInputDialogState createState() => _BaseInputDialogState();
}

class _BaseInputDialogState extends State<BaseInputDialog> {
  late final CustomValidationTextEditingController _controller;

  @override
  void initState() {
    _controller = CustomValidationTextEditingController(
      text: this.widget.inputText ?? '',
      check: this.widget.inputCheck,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseAdaptiveDialog(
      title: this.widget.title,
      bodyWidget: Column(
        children: [
          Text(this.widget.body),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: BaseAdaptiveTextField(
              controller: _controller,
              placeholder: this.widget.inputPlaceholder,
              clearButton: this.widget.clearButton,
              clearButtonVisibleWithoutFocus:
                  this.widget.clearButtonVisibleWithoutFocus,
            ),
          ),
        ],
      ),
      actions: [
        if (this.widget.onDelete != null)
          BaseDialogAction(
            child: Text(this.widget.deleteText ?? 'Delete'),
            isDestructiveAction: true,
            onPressed: (_) {
              this.widget.onDelete!();
            },
          ),
        BaseDialogAction(
          isDefaultAction: true,
          child: Text(this.widget.cancelText ?? 'Cancel'),
        ),
        BaseDialogAction(
          child: Text(this.widget.saveText ?? 'Save'),
          popOnAction: false,
          onPressed: (_) {
            bool valid = true;
            if (this.widget.inputCheck != null) {
              valid = _controller.isValid;
            }
            if (valid) {
              this.widget.onSave?.call(_controller.textAtSubmission.isNotEmpty
                  ? _controller.textAtSubmission
                  : null);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
