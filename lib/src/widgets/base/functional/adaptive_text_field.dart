import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomValidationTextEditingController extends TextEditingController {
  bool submitted = false;

  late String textAtSubmission;

  /// Works like validation - return an empty String to tell it is valid and otherwise
  /// the error text which should be displayed
  final String? Function(String?)? check;

  CustomValidationTextEditingController({
    this.check,
    super.text,
  });

  bool get isValid {
    this.submit();
    return this.check?.call(this.text) == null;
  }

  void submit() {
    this.submitted = true;
    this.textAtSubmission = this.text;
    this.notifyListeners();
  }
}

class BaseAdaptiveTextField extends StatefulWidget {
  final CustomValidationTextEditingController controller;
  final bool expands;
  final String? placeholder;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextAlignVertical? textAlignVertical;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double bottomPadding;
  final int minLines;
  final int? maxLines;
  final bool autocorrect;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool clearButton;

  /// By default, the error text space beneath a text field is not used when
  /// there is no error meaning that if an error is present, the text will
  /// appear beneath and use up new space. Sometimes we want to use that space
  /// all the time for better overall layout alignment
  final bool errorPaddingAlways;

  final Widget? bottom;

  final TargetPlatform? platform;

  final void Function(String text)? onChanged;

  const BaseAdaptiveTextField({
    super.key,
    required this.controller,
    this.expands = false,
    this.placeholder,
    this.focusNode,
    this.style,
    this.textAlignVertical,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.bottomPadding = 6.0,
    this.minLines = 1,
    this.maxLines,
    this.bottom,
    this.autocorrect = false,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.labelText,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.clearButton = false,
    this.errorPaddingAlways = false,
    this.platform,
    this.onChanged,
  });

  @override
  BaseAdaptiveTextFieldState createState() => BaseAdaptiveTextFieldState();
}

class BaseAdaptiveTextFieldState extends State<BaseAdaptiveTextField> {
  String? _validationText;
  late VoidCallback _textEditingListener;

  late final FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = (this.widget.focusNode ?? FocusNode())
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _textEditingListener = () {
      if (this.widget.controller.submitted && _validationText == null) {
        String? tempVal =
            this.widget.controller.check?.call(this.widget.controller.text);
        if (tempVal != _validationText) {
          setState(() => _validationText = tempVal);
        }
      }
      if (this.widget.controller.submitted &&
          this.widget.controller.textAtSubmission !=
              this.widget.controller.text) {
        this.widget.controller.submitted = false;
        setState(() => _validationText = null);
      }
    };

    this.widget.controller.addListener(_textEditingListener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseAdaptiveTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_textEditingListener);
      this.widget.controller.addListener(_textEditingListener);
      _validationText = null;
      if (this.widget.controller.submitted) {
        this.widget.controller.submit();
      }
    }
  }

  @override
  void dispose() {
    this.widget.controller.removeListener(_textEditingListener);
    super.dispose();
  }

  List<TextInputFormatter>? _textInputFormatter() {
    if (this.widget.inputFormatters != null) {
      return this.widget.inputFormatters;
    }

    if (this.widget.keyboardType == TextInputType.number) {
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }

    if (this.widget.keyboardType ==
        const TextInputType.numberWithOptions(decimal: true)) {
      return [
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget clearButton = AnimatedSwitcher(
      duration: DesignSystem.animation.defaultDurationMS250,
      child: _focusNode.hasFocus
          ? IconButton(
              onPressed: () => this.widget.controller.clear(),
              icon: const Icon(CupertinoIcons.clear_circled_solid),
              iconSize: DesignSystem.size.x18,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.all(DesignSystem.size.x4),
              constraints: BoxConstraints(
                minHeight: DesignSystem.size.x42,
                minWidth: DesignSystem.size.x42,
              ),
            )
          : const SizedBox(),
    );

    Widget textField =
        switch (this.widget.platform ?? Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => CupertinoTextField(
          focusNode: _focusNode,
          controller: this.widget.controller,
          expands: this.widget.expands,
          style: this.widget.style,
          textAlignVertical: this.widget.textAlignVertical,
          cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
          placeholder: this.widget.placeholder,
          keyboardType: this.widget.keyboardType,
          inputFormatters: _textInputFormatter(),
          minLines: this.widget.expands ? null : this.widget.minLines,
          maxLines: this.widget.expands
              ? null
              : this.widget.maxLines ?? this.widget.minLines,
          autocorrect: this.widget.autocorrect,
          obscureText: this.widget.obscureText,
          enabled: this.widget.enabled,
          readOnly: this.widget.readOnly,
          prefix: this.widget.prefix,
          suffix: this.widget.clearButton
              ? clearButton
              : this.widget.suffix ?? this.widget.suffixIcon,
          onChanged: this.widget.onChanged,
        ),
      _ => Padding(
          padding: EdgeInsets.only(bottom: DesignSystem.spacing.x4),
          child: TextFormField(
            focusNode: _focusNode,
            controller: this.widget.controller,
            expands: this.widget.expands,
            style: this.widget.style,
            textAlignVertical: this.widget.textAlignVertical,
            cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
            decoration: InputDecoration(
              hintText: this.widget.placeholder,
              labelText: this.widget.labelText,
              prefix: this.widget.prefix,
              suffix:
                  this.widget.clearButton ? clearButton : this.widget.suffix,
              suffixIcon: this.widget.suffixIcon,
              enabledBorder: _validationText != null
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                    )
                  : null,
              focusedBorder: _validationText != null
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                    )
                  : null,
              border: _validationText != null
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                    )
                  : null,
            ),
            keyboardType: this.widget.keyboardType,
            inputFormatters: _textInputFormatter(),
            minLines: this.widget.expands ? null : this.widget.minLines,
            maxLines: this.widget.expands
                ? null
                : this.widget.maxLines ?? this.widget.minLines,
            autocorrect: this.widget.autocorrect,
            obscureText: this.widget.obscureText,
            enabled: this.widget.enabled,
            readOnly: this.widget.readOnly,
            onChanged: this.widget.onChanged,
          ),
        ),
    };

    if (this.widget.expands) {
      textField = Expanded(
        child: textField,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        textField,
        this.widget.bottom ?? const SizedBox(),
        if (_validationText != null || this.widget.errorPaddingAlways)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 2.0,
                left:
                    DesignSystem.isApple(context) ? DesignSystem.spacing.x4 : 0,
                bottom: this.widget.bottomPadding,
              ),
              child: Fader(
                child: Text(
                  _validationText ?? '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: CupertinoColors.destructiveRed,
                      ),
                  // style: const TextStyle(
                  //   color: CupertinoColors.destructiveRed,
                  // ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
