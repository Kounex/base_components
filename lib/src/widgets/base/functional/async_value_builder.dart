import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/progress_indicator.dart';

class BaseAsyncValueBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;

  final bool skipLoadingOnReload;
  final bool skipLoadingOnRefresh;

  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;

  final String? loadingText;

  const BaseAsyncValueBuilder({
    super.key,
    required this.asyncValue,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
    required this.data,
    this.error,
    this.loading,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    //  return AnimatedSwitcher(
    //   duration: DesignSystem.animation.defaultDurationMS250 * 2,
    //   transitionBuilder: (child, animation) => SizeTransition(
    //     sizeFactor: animation,
    //     child: FadeTransition(
    //       opacity: Tween(
    //         begin: 0.0,
    //         end: 1.0,
    //       ).animate(
    //         CurvedAnimation(
    //           parent: animation,
    //           curve: const Interval(
    //             0.5,
    //             1.0,
    //           ),
    //         ),
    //       ),
    //       child: child,
    //     ),
    //   ),
    //   child: this.asyncValue.when(
    //         skipLoadingOnReload: this.skipLoadingOnReload,
    //         skipLoadingOnRefresh: this.skipLoadingOnRefresh,
    //         data: (data) => Center(
    //           key: const ValueKey('data'),
    //           child: this.data(data),
    //         ),
    //         error: (error, stackTrace) => Center(
    //           key: const ValueKey('error'),
    //           child: this.error != null
    //               ? this.error!.call(error, stackTrace)
    //               : Text(
    //                   error.toString(),
    //                 ),
    //         ),
    //         loading: () => Center(
    //           key: const ValueKey('loading'),
    //           child: this.loading != null
    //               ? this.loading!.call()
    //               : const CircularProgressIndicator(),
    //         ),
    //       ),
    // );
    return this.asyncValue.when(
          skipLoadingOnReload: this.skipLoadingOnReload,
          skipLoadingOnRefresh: this.skipLoadingOnRefresh,
          data: this.data,
          error: this.error ??
              (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
          loading: this.loading ??
              () => Center(
                    child: BaseProgressIndicator(
                      text: this.loadingText,
                    ),
                  ),
        );
  }
}
