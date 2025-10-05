import 'package:base_components/base_components.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseAdaptiveSlider extends StatelessWidget {
  final double value;

  final double min;
  final double max;
  final int? divisions;

  final double? softMin;
  final double? softMax;

  final bool intMode;

  final bool feedback;

  final void Function(double value)? onChanged;

  const BaseAdaptiveSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.softMin,
    this.softMax,
    this.intMode = true,
    this.feedback = true,
    this.divisions,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localMin = softMin ?? min;
    final localMax = softMax ?? max;

    return DesignSystem.isApple(context)
        ? FutureBuilder<IosDeviceInfo>(
            future: DeviceInfoPlugin().iosInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (DesignSystem.isLiquidGlass(snapshot.data!)) {
                  return CNSlider(
                    value: this.value,
                    onChanged: (newValue) {
                      if (this.onChanged != null) {
                        if (newValue.toInt() != value.toInt() &&
                            newValue.toInt() >= localMin &&
                            newValue.toInt() <= localMax) {
                          if (this.feedback) {
                            HapticFeedback.lightImpact();
                          }
                          this.onChanged!.call(newValue);
                        }
                      }
                    },
                    min: this.min,
                    max: this.max,
                    step: this.divisions != null
                        ? this.max - this.min / this.divisions!
                        : null,
                  );
                }
                return CupertinoSlider(
                  value: this.value,
                  onChanged: this.onChanged != null
                      ? (newValue) {
                          if (newValue.toInt() != value.toInt() &&
                              newValue.toInt() >= localMin &&
                              newValue.toInt() <= localMax) {
                            if (this.feedback) {
                              HapticFeedback.lightImpact();
                            }
                            this.onChanged!.call(newValue);
                          }
                        }
                      : null,
                  min: this.min,
                  max: this.max,
                  divisions: this.divisions,
                );
              }
              return const SizedBox.shrink();
            },
          )
        : Slider(
            value: this.value,
            onChanged: this.onChanged != null
                ? (newValue) {
                    if (newValue.toInt() != value.toInt() &&
                        newValue.toInt() >= localMin &&
                        newValue.toInt() <= localMax) {
                      if (this.feedback) {
                        HapticFeedback.lightImpact();
                      }
                      this.onChanged!.call(newValue);
                    }
                  }
                : null,
            min: this.min,
            max: this.max,
            divisions: this.divisions,
          );
  }
}
