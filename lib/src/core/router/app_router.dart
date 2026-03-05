import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/router/go_router_refresh_stream.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/onboarding_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/view/login_view.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/presentation/view/home_view.dart';
import 'package:xontraining/src/feature/home/presentation/view/program_detail_view.dart';
import 'package:xontraining/src/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/profile_edit_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/profile_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/privacy_policy_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/app_version_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/settings_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/terms_of_service_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/workout_record_view.dart';

part 'app_router.g.dart';

@riverpod
GoRouterRefreshStream _routerRefresh(Ref ref) {
  final supabase = ref.read(supabaseClientProvider);
  final notifier = GoRouterRefreshStream(supabase.auth.onAuthStateChange);
  ref.onDispose(notifier.dispose);
  return notifier;
}

@riverpod
GoRouter goRouter(Ref ref) {
  final supabase = ref.read(supabaseClientProvider);
  final refreshListenable = ref.watch(_routerRefreshProvider);
  final onboardingState = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isLoggedIn = supabase.auth.currentSession != null;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;
      final isOnboardingRoute = state.matchedLocation == AppRoutes.onboarding;

      if (!isLoggedIn && !isLoginRoute) {
        return AppRoutes.login;
      }

      if (!isLoggedIn && isLoginRoute) {
        return null;
      }

      if (onboardingState.isLoading) {
        return null;
      }

      final isOnboardingCompleted = onboardingState.asData?.value ?? false;

      if (!isOnboardingCompleted && !isOnboardingRoute) {
        return AppRoutes.onboarding;
      }

      if (isOnboardingCompleted && (isLoginRoute || isOnboardingRoute)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.programDetail,
        name: AppRoutes.programDetailName,
        builder: (context, state) {
          final program = state.extra is ProgramEntity
              ? state.extra! as ProgramEntity
              : null;
          return ProgramDetailView(
            programId: state.pathParameters['programId'] ?? '',
            program: program,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        name: AppRoutes.profileEditName,
        builder: (context, state) => const ProfileEditView(),
      ),
      GoRoute(
        path: AppRoutes.workoutRecord,
        name: AppRoutes.workoutRecordName,
        builder: (context, state) => const WorkoutRecordView(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: AppRoutes.appVersion,
        name: AppRoutes.appVersionName,
        builder: (context, state) => const AppVersionView(),
      ),
      GoRoute(
        path: AppRoutes.termsOfService,
        name: AppRoutes.termsOfServiceName,
        builder: (context, state) => const TermsOfServiceView(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        name: AppRoutes.privacyPolicyName,
        builder: (context, state) => const PrivacyPolicyView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingView(),
      ),
    ],
  );
}

abstract final class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String workoutRecord = '/profile/workout-record';
  static const String settings = '/settings';
  static const String appVersion = '/settings/app-version';
  static const String termsOfService = '/settings/terms';
  static const String privacyPolicy = '/settings/privacy';
  static const String programDetail = '/program/:programId';
  static const String onboarding = '/onboarding';

  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String profileEditName = 'profileEdit';
  static const String workoutRecordName = 'workoutRecord';
  static const String settingsName = 'settings';
  static const String appVersionName = 'appVersion';
  static const String termsOfServiceName = 'termsOfService';
  static const String privacyPolicyName = 'privacyPolicy';
  static const String programDetailName = 'programDetail';
  static const String onboardingName = 'onboarding';
}
