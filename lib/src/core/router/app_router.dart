import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/router/go_router_refresh_stream.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/onboarding_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/view/login_view.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_detail_view.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_view.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_write_view.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/presentation/view/program_coach_view.dart';
import 'package:xontraining/src/feature/home/presentation/view/home_view.dart';
import 'package:xontraining/src/feature/home/presentation/view/program_detail_view.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';
import 'package:xontraining/src/feature/notice/presentation/view/notice_detail_view.dart';
import 'package:xontraining/src/feature/notice/presentation/view/notice_view.dart';
import 'package:xontraining/src/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/profile_edit_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/profile_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/privacy_policy_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/app_version_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/rowing_record_entry_view.dart';
import 'package:xontraining/src/feature/profile/presentation/view/rowing_record_list_view.dart';
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
        path: AppRoutes.notice,
        name: AppRoutes.noticeName,
        builder: (context, state) => const NoticeView(),
      ),
      GoRoute(
        path: AppRoutes.community,
        name: AppRoutes.communityName,
        builder: (context, state) => const CommunityView(),
      ),
      GoRoute(
        path: AppRoutes.communityWrite,
        name: AppRoutes.communityWriteName,
        builder: (context, state) => const CommunityWriteView(),
      ),
      GoRoute(
        path: AppRoutes.communityDetail,
        name: AppRoutes.communityDetailName,
        redirect: (context, state) {
          final postId = state.pathParameters['postId'] ?? '';
          if (!AppRoutes.isValidUuid(postId)) {
            return AppRoutes.community;
          }
          return null;
        },
        builder: (context, state) =>
            CommunityDetailView(postId: state.pathParameters['postId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.communityEdit,
        name: AppRoutes.communityEditName,
        redirect: (context, state) {
          final postId = state.pathParameters['postId'] ?? '';
          if (!AppRoutes.isValidUuid(postId)) {
            return AppRoutes.community;
          }
          return null;
        },
        builder: (context, state) {
          String? initialContent;
          List<String> initialImageUrls = const [];
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra! as Map<String, dynamic>;
            final content = extra['content'];
            final images = extra['images'];
            if (content is String) {
              initialContent = content;
            }
            if (images is List) {
              initialImageUrls = images
                  .whereType<String>()
                  .map((url) => url.trim())
                  .where((url) => url.isNotEmpty)
                  .toList(growable: false);
            }
          }
          return CommunityWriteView(
            postId: state.pathParameters['postId'] ?? '',
            initialContent: initialContent,
            initialImageUrls: initialImageUrls,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.noticeDetail,
        name: AppRoutes.noticeDetailName,
        builder: (context, state) {
          final notice = state.extra is NoticeEntity
              ? state.extra! as NoticeEntity
              : null;
          return NoticeDetailView(
            noticeId: state.pathParameters['noticeId'] ?? '',
            initialNotice: notice,
          );
        },
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
        path: AppRoutes.programCoach,
        name: AppRoutes.programCoachName,
        builder: (context, state) => const ProgramCoachView(),
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
        path: AppRoutes.workoutRecordEntry,
        name: AppRoutes.workoutRecordEntryName,
        redirect: (context, state) {
          final exerciseKey = state.pathParameters['exercise'] ?? '';
          if (!AppRoutes.isSupportedWorkoutExercise(exerciseKey)) {
            return AppRoutes.workoutRecord;
          }
          return null;
        },
        builder: (context, state) => WorkoutRecordEntryView(
          exerciseKey: state.pathParameters['exercise'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.workoutRecordList,
        name: AppRoutes.workoutRecordListName,
        redirect: (context, state) {
          final exerciseKey = state.pathParameters['exercise'] ?? '';
          if (!AppRoutes.isSupportedWorkoutExercise(exerciseKey)) {
            return AppRoutes.workoutRecord;
          }
          return null;
        },
        builder: (context, state) => WorkoutRecordListView(
          exerciseKey: state.pathParameters['exercise'] ?? '',
        ),
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
  static const String notice = '/notices';
  static const String community = '/community';
  static const String communityWrite = '/community/write';
  static const String communityDetail = '/community/post/:postId';
  static const String communityEdit = '/community/post/:postId/edit';
  static const String noticeDetail = '/notices/:noticeId';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String workoutRecord = '/profile/workout-record';
  static const String workoutRecordEntry =
      '/profile/workout-record/:exercise/new';
  static const String workoutRecordList =
      '/profile/workout-record/:exercise/list';
  static const String settings = '/settings';
  static const String appVersion = '/settings/app-version';
  static const String termsOfService = '/settings/terms';
  static const String privacyPolicy = '/settings/privacy';
  static const String programDetail = '/program/:programId';
  static const String programCoach = '/program/:programId/coach';
  static const String onboarding = '/onboarding';

  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String noticeName = 'notice';
  static const String communityName = 'community';
  static const String communityDetailName = 'communityDetail';
  static const String communityWriteName = 'communityWrite';
  static const String communityEditName = 'communityEdit';
  static const String noticeDetailName = 'noticeDetail';
  static const String profileName = 'profile';
  static const String profileEditName = 'profileEdit';
  static const String workoutRecordName = 'workoutRecord';
  static const String workoutRecordEntryName = 'workoutRecordEntry';
  static const String workoutRecordListName = 'workoutRecordList';
  static const String settingsName = 'settings';
  static const String appVersionName = 'appVersion';
  static const String termsOfServiceName = 'termsOfService';
  static const String privacyPolicyName = 'privacyPolicy';
  static const String programDetailName = 'programDetail';
  static const String programCoachName = 'programCoach';
  static const String onboardingName = 'onboarding';

  static final RegExp _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{12}$',
  );

  static const Set<String> supportedWorkoutExercises = {
    'rowing',
    'running',
    'ski',
    'squat',
    'deadlift',
    'bench_press',
  };

  static bool isValidUuid(String value) => _uuidRegex.hasMatch(value);

  static bool isSupportedWorkoutExercise(String value) =>
      supportedWorkoutExercises.contains(value);
}
