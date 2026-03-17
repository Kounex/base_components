import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'design_system.dart';

/// Defines the layout and interaction defaults for [ModalUtils.showCustomBottomSheet].
enum BottomSheetType {
  /// The standard, native-feeling bottom sheet.
  /// By default, it is draggable, dismissible by tapping outside,
  /// and its height is determined by the content natively.
  standard,

  /// A dynamically-sized bottom sheet that fits its content.
  /// By default, it is not draggable and relies on an explicit close action
  /// or barrier tap (if `isDismissible` is specified as true).
  fixed,

  /// A large, expanded bottom sheet designed for complex layouts.
  /// By default, it takes up a significant portion of the screen (e.g. 90%),
  /// disables dragging, and cannot be dismissed by tapping outside.
  expanded,
}

class ModalUtils {
  /// Displays a unified, customizable bottom sheet.
  ///
  /// This function serves as the new unified replacement for
  /// [showBaseFixedModalBottomSheet], [showBaseModalBottomSheet],
  /// and [showExpandedModalBottomSheet].
  ///
  /// The [type] parameter dictates the layout and interactive defaults of the sheet.
  ///
  /// Additional properties:
  /// * [isDismissible]: Determines if tapping outside the sheet closes it. Defaults to `false` for `expanded` types, `true` otherwise.
  /// * [enableDrag]: Controls if the sheet can be swiped down. Defaults to `true` for [BottomSheetType.standard], `false` otherwise.
  /// * [showDragHandle]: Optionally renders a visual "drag pill" indicator. Only applicable to [BottomSheetType.standard] when drag is enabled.
  /// * [includeCloseButton]: Renders a built-in close button (`x`) at the top right corner of the sheet wrapper.
  /// * [forceExpand]: Exclusively used by [BottomSheetType.expanded] to try maximizing the bottom sheet's vertical sizing.
  /// * [popOnClose]: If a close button is rendered, this dictates whether pressing it implicitly calls `Navigator.pop`.
  /// * [onClose]: A callback triggered when the generated close button is pressed.
  /// * [additionalBottomViewInsets]: Pushes the content upwards by a specific value, typically to avoid keyboard overlap manually if needed.
  /// * [blurryBackground]: Casts a blur effect on the surface behind the active bottom sheet.
  static Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    BottomSheetType type = BottomSheetType.standard,
    bool? isDismissible,
    bool? enableDrag,
    bool showDragHandle = false,
    bool includeCloseButton = false,
    bool forceExpand = false,
    bool popOnClose = true,
    void Function(BuildContext context)? onClose,
    double additionalBottomViewInsets = 0,
    bool blurryBackground = false,
  }) async {
    final bool resolvedIsDismissible =
        isDismissible ?? (type != BottomSheetType.expanded);
    final bool resolvedEnableDrag =
        enableDrag ?? (type == BottomSheetType.standard);
    final bool isScrollControlled = type != BottomSheetType.standard;

    BoxConstraints? constraints;
    if (type == BottomSheetType.expanded) {
      constraints = BoxConstraints(
        maxHeight: forceExpand
            ? MediaQuery.of(context).size.height * (9 / 10)
            : min(
                Breakpoint.md.width,
                MediaQuery.of(context).size.height * (9 / 10),
              ),
        maxWidth: Breakpoint.sm.width,
        minWidth: Breakpoint.sm.width,
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isDismissible: resolvedIsDismissible,
      enableDrag: resolvedEnableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      constraints: constraints,
      builder: (context) {
        Widget content = builder(context);

        content = switch (type) {
          BottomSheetType.standard => SafeArea(
              child: resolvedEnableDrag && showDragHandle
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
          BottomSheetType.fixed => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                content,
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          BottomSheetType.expanded => content,
        };

        return _bottomSheetWrapper(
          context: context,
          additionalBottomViewInsets: additionalBottomViewInsets,
          blurryBackground: blurryBackground,
          includeCloseButton: includeCloseButton,
          onClose: onClose,
          popOnClose: popOnClose,
          modalWidget: content,
        );
      },
    );
  }

  static Future<T?> showFullscreen<T>({
    required BuildContext context,
    required Widget content,
    bool transparent = false,
    double tint = 0.54,
    bool blur = false,
    bool includeClose = true,
    bool barrierDismissible = false,
    void Function()? onClose,
  }) async =>
      showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        transitionBuilder: (context, animation, _, __) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOut);
          final curvedSigma = DesignSystem.sigmaBlur * curved.value;
          final curvedTint = tint * curved.value;

          return Builder(builder: (context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () =>
                        barrierDismissible ? Navigator.of(context).pop() : null,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: blur ? curvedSigma : 0,
                          sigmaY: blur ? curvedSigma : 0),
                      child: Container(
                        color: Colors.black.withValues(
                            alpha: transparent ? curvedTint : curved.value),
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: curved,
                  child: content,
                ),
                if (includeClose)
                  Positioned(
                    top: 12.0 + MediaQuery.paddingOf(context).top,
                    right: 12.0 + MediaQuery.paddingOf(context).right,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(CupertinoIcons.clear),
                    ),
                  ),
              ],
            );
          });
        },
      );

  static Future<T?> showBaseDialog<T>(
    BuildContext context,
    Widget dialog,
  ) =>
      showAdaptiveDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Align(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Breakpoint.xsm.width),
            child: dialog,
          ),
        ),
      );

  @Deprecated('Use showCustomBottomSheet instead')
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

  @Deprecated('Use showCustomBottomSheet instead')
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

  @Deprecated('Use showCustomBottomSheet instead')
  static Future<T?> showExpandedModalBottomSheet<T>(
    BuildContext context,
    Widget content, {
    bool fullscreen = false,
    bool forceExpand = false,
    bool includeCloseButton = true,
    bool popOnClose = true,
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
                  if (popOnClose) {
                    Navigator.of(context).pop();
                  }
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
    bool popOnClose = true,
    void Function(BuildContext context)? onClose,
    double additionalBottomViewInsets = 0,
  }) {
    Widget child = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(
              alpha: blurryBackground ? DesignSystem.opacityForBlur : 1,
            ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.border.radius12),
        ),
      ),
      child: Stack(
        children: [
          if (includeCloseButton)
            Positioned(
              top: DesignSystem.spacing.x12,
              right: DesignSystem.spacing.x12,
              child: Container(
                padding: EdgeInsets.only(right: DesignSystem.spacing.x4),
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled_solid),
                  onPressed: () {
                    onClose?.call(context);
                    if (popOnClose) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
          modalWidget
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
