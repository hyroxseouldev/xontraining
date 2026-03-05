// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'XON Training';

  @override
  String get loginHeadline => 'Welcome to XON Training';

  @override
  String get loginGoogleButton => 'Sign in with Google';

  @override
  String get loginAppleButton => 'Sign in with Apple';

  @override
  String get loginLoading => 'Signing in...';

  @override
  String get loginCanceled => 'Sign-in was canceled.';

  @override
  String get loginConfigError => 'Sign-in is not configured correctly.';

  @override
  String get loginNetworkError =>
      'Network error occurred. Check your connection and try again.';

  @override
  String get loginFailed => 'Sign-in failed. Please try again.';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeProgramsTitle => 'Programs';

  @override
  String get homeWelcome => 'You are logged in.';

  @override
  String get homeLoadFailed => 'Failed to load home data. Please try again.';

  @override
  String get homeNoPrograms => 'No programs available.';

  @override
  String get homeNoActiveProgram => 'No active program found.';

  @override
  String get homeCurrentProgram => 'Current Program';

  @override
  String homeScheduleForDate(Object date) {
    return 'Schedule for $date';
  }

  @override
  String get homeNoScheduleForDate => 'No schedule for this date.';

  @override
  String get homeProfile => 'Profile';

  @override
  String get homeProgramInfoDuration => 'Duration';

  @override
  String get homeProgramInfoDifficulty => 'Difficulty';

  @override
  String get homeProgramInfoWorkoutTime => 'Workout Time';

  @override
  String get homeProgramInfoWeeklySessions => 'Weekly Sessions';

  @override
  String get homeProgramDifficultyBeginner => 'Beginner';

  @override
  String get homeProgramDifficultyIntermediate => 'Intermediate';

  @override
  String get homeProgramDifficultyAdvanced => 'Advanced';

  @override
  String get homeProgramDetailTitle => 'Program Detail';

  @override
  String get homeProgramDetailDescription => 'Detail view skeleton is ready.';

  @override
  String get homeProgramDetailComingSoon =>
      'Detailed sections, progress, and actions will be added next.';

  @override
  String get homeProgramDetailPurchaseRequired =>
      'This page is available after purchase and activation.';

  @override
  String get homeProgramDetailNoSessions =>
      'No sessions are available for this program yet.';

  @override
  String get homeProgramDetailNoSessionForSelectedDate =>
      'No session for the selected date.';

  @override
  String get homeProgramDetailSelectDate => 'Select date';

  @override
  String get homeProgramDetailToday => 'Today';

  @override
  String homeProgramDetailIdLabel(Object id) {
    return 'Program ID: $id';
  }

  @override
  String homeProgramDetailSessionMeta(Object date, int week, Object day) {
    return '$date · Week $week · $day';
  }

  @override
  String homeProgramDetailSessionMetaNoDay(Object date, int week) {
    return '$date · Week $week';
  }

  @override
  String homeProgramDetailSessionMetaNoWeek(Object date, Object day) {
    return '$date · $day';
  }

  @override
  String get homeProgramValueNotAvailable => '-';

  @override
  String homeProgramDurationWeeks(int weeks) {
    return '$weeks weeks';
  }

  @override
  String homeProgramWorkoutMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String homeProgramWeeklySessions(int days) {
    return '${days}x / week';
  }

  @override
  String get homeSignOut => 'Sign out';

  @override
  String homeSignedInAs(Object email) {
    return 'Signed in as $email';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSave => 'Save';

  @override
  String get profileSaving => 'Saving...';

  @override
  String get profileSaveSuccess => 'Profile updated.';

  @override
  String get profileSaveFailed => 'Failed to update profile. Please try again.';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profileNameHint => 'Enter your name';

  @override
  String get profileNameRequired => 'Please enter your name.';

  @override
  String profileSignedInAs(Object email) {
    return 'Signed in as $email';
  }

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileMenuTitle => 'Menu';

  @override
  String get profileWorkoutRecord => 'My Workout Performance Log';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileEditComingSoon => 'Profile edit page skeleton is ready.';

  @override
  String get profileEditChangePhoto => 'Change Photo';

  @override
  String get profileEditImagePickFailed =>
      'Failed to select image. Please try again.';

  @override
  String get profileEditImageUnsupportedType =>
      'Only JPG, PNG, and WEBP images are allowed.';

  @override
  String profileEditImageTooLarge(int maxMb) {
    return 'Image is too large. Please select up to ${maxMb}MB.';
  }

  @override
  String get profileWorkoutRecordComingSoon =>
      'Workout performance log page skeleton is ready.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDescription => 'Settings page skeleton is ready.';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsActionFailed => 'Action failed. Please try again.';

  @override
  String get settingsAppVersion => 'App version';

  @override
  String get settingsVersionLoading => 'Loading...';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsTermsOfServiceBody =>
      'Terms of service content will be provided and updated by your organization.';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicyBody =>
      'Privacy policy content will be provided and updated by your organization.';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Permanently delete your account and all related data.';

  @override
  String get settingsDeleteAccountMemberOnly =>
      'Only member accounts can be deleted.';

  @override
  String get settingsDeleteAccountDialogTitle => 'Delete account permanently?';

  @override
  String get settingsDeleteAccountDialogBody =>
      'Deleting your account is immediate and cannot be undone. Purchase history, workout records, profile information, offline classes you created, and class registrations will all be deleted. Your previous data cannot be restored even if you sign in again.';

  @override
  String get settingsDeleteAccountCancel => 'Cancel';

  @override
  String get settingsDeleteAccountConfirm => 'Delete permanently';

  @override
  String get settingsDeleteAccountFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get settingsDeleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get legalDocumentLoading => 'Loading document...';

  @override
  String get legalDocumentLoadFailed => 'Failed to load document.';

  @override
  String get legalDocumentVersionLabel => 'Version:';

  @override
  String get legalDocumentUpdatedAtLabel => 'Updated:';

  @override
  String get workoutRecordAdd => 'Add record';

  @override
  String get workoutRecordEdit => 'Edit';

  @override
  String get workoutRecordDelete => 'Delete';

  @override
  String get workoutRecordEmpty => 'No workout records yet.';

  @override
  String get workoutRecordLoadFailed => 'Failed to load workout records.';

  @override
  String get workoutRecordSaveFailed => 'Failed to save workout record.';

  @override
  String get workoutRecordSaved => 'Workout record saved.';

  @override
  String get workoutRecordDeleted => 'Workout record deleted.';

  @override
  String get workoutRecordDeleteFailed => 'Failed to delete workout record.';

  @override
  String get workoutRecordMetricWeight => 'Weight';

  @override
  String get workoutRecordMetricReps => 'Repetitions';

  @override
  String get workoutRecordMetricDistance => 'Distance';

  @override
  String get workoutRecordMetricDuration => 'Duration';

  @override
  String get workoutRecordAddDialogTitle => 'Add workout record';

  @override
  String get workoutRecordEditDialogTitle => 'Edit workout record';

  @override
  String get workoutRecordExerciseName => 'Exercise name';

  @override
  String get workoutRecordMetricType => 'Metric type';

  @override
  String get workoutRecordValue => 'Value';

  @override
  String get workoutRecordValueSeconds => 'Seconds';

  @override
  String get workoutRecordUnit => 'Unit';

  @override
  String get workoutRecordDate => 'Date';

  @override
  String get workoutRecordMemo => 'Memo';

  @override
  String get workoutRecordRequired => 'This field is required.';

  @override
  String get workoutRecordInvalidNumber =>
      'Enter a valid number greater than 0.';

  @override
  String get workoutRecordCancel => 'Cancel';

  @override
  String get workoutRecordSave => 'Save';

  @override
  String get workoutRecordDeleteDialogTitle => 'Delete this record?';

  @override
  String get workoutRecordDeleteDialogBody =>
      'This record will be deleted permanently.';

  @override
  String get workoutRecordSearchHint => 'Search by exercise or memo';

  @override
  String get workoutRecordSortNewest => 'Newest';

  @override
  String get workoutRecordSortOldest => 'Oldest';

  @override
  String get workoutRecordNoSearchResult => 'No records match your search.';

  @override
  String get workoutRecordUseDefaultUnit => 'Use default unit';

  @override
  String get workoutRecordUseDefaultUnitSubtitle =>
      'Automatically lock unit for each metric type';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingDescription => 'Set up your profile to continue.';

  @override
  String get onboardingNameLabel => 'Name';

  @override
  String get onboardingNameHint => 'Enter your name';

  @override
  String get onboardingNameRequired => 'Please enter your name.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingSaving => 'Saving...';

  @override
  String get onboardingSaveFailed =>
      'Failed to save profile. Please try again.';
}
