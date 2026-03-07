import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_controller.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

enum _LoginProvider { google, apple }

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    const loginButtonHeight = 50.0;
    final googleFontSize = loginButtonHeight * 0.43;
    final activeProvider = useState<_LoginProvider?>(null);
    final isLoading = authState.isLoading;
    final isGoogleLoading =
        isLoading && activeProvider.value == _LoginProvider.google;
    final isAppleLoading =
        isLoading && activeProvider.value == _LoginProvider.apple;
    final isAppleSignInAvailable =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final logoHeight = LayoutBreakpoints.isTablet(context) ? 320.0 : 240.0;

    useEffect(() {
      if (!isLoading) {
        activeProvider.value = null;
      }
      return null;
    }, [isLoading]);

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
                height: logoHeight,
                errorBuilder: (context, error, stackTrace) =>
                    SizedBox(height: logoHeight),
              ),
              const Spacer(),
              if (isAppleSignInAvailable)
                SizedBox(
                  width: double.infinity,
                  height: loginButtonHeight,
                  child: SignInWithAppleButton(
                    height: loginButtonHeight,
                    text: isAppleLoading
                        ? l10n.loginLoading
                        : l10n.loginAppleButton,
                    borderRadius: BorderRadius.circular(8),

                    onPressed: isLoading
                        ? null
                        : () {
                            activeProvider.value = _LoginProvider.apple;
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithApple();
                          },
                    style: SignInWithAppleButtonStyle.black,
                  ),
                ),
              if (isAppleSignInAvailable) const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style:
                      FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.black.withValues(
                          alpha: 0.5,
                        ),
                        disabledForegroundColor: Colors.white.withValues(
                          alpha: 0.8,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size.fromHeight(loginButtonHeight),
                        textStyle: TextStyle(
                          fontSize: googleFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                  onPressed: isLoading
                      ? null
                      : () {
                          activeProvider.value = _LoginProvider.google;
                          ref
                              .read(authControllerProvider.notifier)
                              .signInWithGoogle();
                        },
                  icon: isGoogleLoading
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/google-logo.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.login),
                        ),
                  label: Text(
                    isGoogleLoading
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
