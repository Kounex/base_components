import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/animation/fader.dart';
import 'design_system.dart';

// A translucent color that is painted on top of the blurred backdrop as the
// dialog's background color
// Extracted from https://developer.apple.com/design/resources/.
const Color kDialogColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xCCF2F2F2),
  darkColor: Color(0xBF1E1E1E),
);

const double kDialogBlurAmount = 20.0;

class ModalUtils {
  static Future<T?> showFullscreen<T>({
    required BuildContext context,
    required Widget content,
    void Function()? onClose,
  }) async =>
      showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => Fader(
          child: Material(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                content,
                Positioned(
                  top: 12.0 + MediaQuery.paddingOf(context).top,
                  right: 12.0 + MediaQuery.paddingOf(context).right,
                  child: IconButton(
                    onPressed: () {
                      onClose?.call();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  static Future<T?> showBaseDialog<T>(
    BuildContext context,
    Widget dialog,
  ) =>
      showAdaptiveDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Breakpoint.xsm.width),
          child: dialog,
        ),
      );

  static Future<T?> showBaseFixedModalBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    bool useRootNavigator = true,
    bool barrierDismissible = false,
    double? maxWidth,
    double additionalBottomViewInsets = 0,
  }) async =>
      showModalBottomSheet(
        context: context,
        useRootNavigator: useRootNavigator,
        isDismissible: barrierDismissible,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => _bottomSheetWrapper(
          context: context,
          additionalBottomViewInsets: additionalBottomViewInsets,
          modalWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              builder(context),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
          maxHeight: MediaQuery.sizeOf(context).height / 1.5,
          maxWidth: min(MediaQuery.sizeOf(context).width,
              maxWidth ?? Breakpoint.sm.width),
        ),
      );

  static Future<T?> showBaseModalBottomSheet<T>(
    BuildContext context,
    Widget content, {
    bool enableDrag = true,
    bool showDragHandle = true,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        useRootNavigator: true,
        enableDrag: enableDrag,
        builder: (context) => SafeArea(
          child: enableDrag && showDragHandle
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: DesignSystem.spacing.x8),
                        content,
                      ],
                    ),
                    Positioned(
                      top: DesignSystem.spacing.x12,
                      child: Container(
                        height: 5.0,
                        width: 36.0,
                        decoration: BoxDecoration(
                          color: CupertinoColors.inactiveGray.darkColor,
                          borderRadius: BorderRadius.circular(
                            DesignSystem.border.radius6,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : content,
        ),
      );

  static Future<T?> showExpandedModalBottomSheet<T>(
    BuildContext context,
    Widget content, {
    bool fullscreen = false,
    bool forceExpand = false,
    bool includeCloseButton = true,
    void Function()? onClose,
  }) =>
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        constraints: !fullscreen
            ? BoxConstraints(
                maxHeight: forceExpand
                    ? MediaQuery.of(context).size.height * (9 / 10)
                    : min(992, MediaQuery.of(context).size.height * (9 / 10)),
                maxWidth: Breakpoint.sm.width,
                minWidth: Breakpoint.sm.width,
              )
            : null,
        builder: (context) => Stack(
          children: [
            content,
            Positioned(
              top: DesignSystem.spacing.x18,
              right: DesignSystem.spacing.x18,
              child: IconButton(
                onPressed: () {
                  onClose?.call();
                  Navigator.of(context).pop();
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
            ),
          ],
        ),
      );

  static Widget _bottomSheetWrapper({
    required BuildContext context,
    required Widget modalWidget,
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
    bool blurryBackground = false,
    bool includeCloseButton = false,
    double additionalBottomViewInsets = 0,
  }) {
    Widget child = Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .cardColor
            .withOpacity(blurryBackground ? DesignSystem.opacityForBlur : 1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.border.radius12),
        ),
      ),
      child: Stack(
        children: [
          if (includeCloseButton)
            Positioned(
              top: 4.0,
              right: 4.0,
              child: Container(
                padding: EdgeInsets.only(right: DesignSystem.spacing.x4),
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled_solid),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
                top: includeCloseButton ? DesignSystem.spacing.x24 : 0),
            child: modalWidget,
          ),
        ],
      ),
    );

    if (blurryBackground) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignSystem.sigmaBlur,
            sigmaY: DesignSystem.sigmaBlur,
          ),
          child: child,
        ),
      );
    }

    // child = Align(
    //   alignment: Alignment.bottomCenter,
    //   child: ConstrainedBox(
    //     constraints: BoxConstraints(
    //       maxHeight: maxHeight,
    //       maxWidth: maxWidth,
    //     ),
    //     child: child,
    //   ),
    // );

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom +
                (MediaQuery.viewInsetsOf(context).bottom > 0
                    ? additionalBottomViewInsets
                    : 0),
          ),
          child: child,
        ),
      ),
    );
  }
}
