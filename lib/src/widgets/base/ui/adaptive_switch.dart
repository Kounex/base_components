import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/design_system.dart';
import '../../../utils/modal.dart';
import '../../dialog/info.dart';

class BaseAdaptiveSwitch extends StatelessWidget {
  final bool value;
  final Color? activeColor;
  final dynamic Function(bool)? onChanged;
  final String? disabledChangeInfo;

  const BaseAdaptiveSwitch({
    super.key,
    required this.value,
    this.activeColor,
    this.onChanged,
    this.disabledChangeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: this.onChanged == null && this.disabledChangeInfo != null
          ? (_) => ModalUtils.showBaseDialog(
                context,
                BaseInfoDialog(body: this.disabledChangeInfo!),
              )
          : null,
      child: DesignSystem.isApple(context)
          ? CupertinoSwitch(
              value: this.value,
              activeTrackColor: this.activeColor ??
                  Theme.of(context)
                      .switchTheme
                      .trackColor
                      ?.resolve({WidgetState.selected}),
              onChanged: this.onChanged,
            )
          : Switch(
              value: this.value,
              onChanged: this.onChanged,
            ),
    );
  }
}
