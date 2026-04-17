import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/app_update/infra/usecase/check_force_update_usecase.dart';
import 'package:xontraining/src/core/app_update/presentation/view/force_update_view.dart';

class AppUpdateGate extends ConsumerWidget {
  const AppUpdateGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(appUpdateCheckProvider);

    return updateState.when(
      data: (result) {
        if (!result.requiresForceUpdate) {
          return child;
        }

        final minimumVersion = result.minimumVersion;
        final storeUrl = result.storeUrl;
        if (minimumVersion == null || storeUrl == null) {
          return child;
        }

        return ForceUpdateView(
          currentVersion: result.currentVersion,
          minimumVersion: minimumVersion,
          storeUrl: storeUrl,
        );
      },
      loading: () => child,
      error: (error, stackTrace) => child,
    );
  }
}
