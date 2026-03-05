import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_controller.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_resolveLoginErrorMessage(error, l10n))),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/xon_logo.png',
                height: 240,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(height: 240),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style:
                      FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor: colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                        disabledForegroundColor: colorScheme.onPrimary
                            .withValues(alpha: 0.7),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                  onPressed: authState.isLoading
                      ? null
                      : () => ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle(),
                  icon: authState.isLoading
                      ? SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/ios_dark_sq_na@3x.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.login),
                        ),
                  label: Text(
                    authState.isLoading
                        ? l10n.loginLoading
                        : l10n.loginGoogleButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolveLoginErrorMessage(Object error, AppLocalizations l10n) {
    if (error is! AppException) {
      return l10n.loginFailed;
    }

    return error.when(
      authCanceled: (cause) => l10n.loginCanceled,
      authConfiguration: (message, cause) => l10n.loginConfigError,
      authNetwork: (cause) => l10n.loginNetworkError,
      auth: (message, cause) => l10n.loginFailed,
      unknown: (message, cause) => l10n.loginFailed,
    );
  }
}
