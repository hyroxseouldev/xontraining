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
  String get homeNotice => 'News';

  @override
  String get noticeTitle => 'News';

  @override
  String get noticeLoadFailed => 'Failed to load news. Please try again.';

  @override
  String get noticeLoadMoreFailed => 'Failed to load more news.';

  @override
  String get noticeRetry => 'Retry';

  @override
  String get noticeEmpty => 'No news yet.';

  @override
  String get noticeNoContent => 'No content.';

  @override
  String get communityTitle => 'Community';

  @override
  String get communityWrite => 'Write';

  @override
  String get communityWritePost => 'Write Post';

  @override
  String get communityEditPost => 'Edit Post';

  @override
  String get communitySave => 'Save';

  @override
  String get communitySaving => 'Saving...';

  @override
  String get communityRetry => 'Retry';

  @override
  String get communityLoadFailed =>
      'Failed to load community posts. Please try again.';

  @override
  String get communityMembershipRequired =>
      'Community is available only for members with an active pass.';

  @override
  String get communityEmpty => 'No posts yet.';

  @override
  String get communityActionFailed => 'Action failed. Please try again.';

  @override
  String get communityContentHint => 'Share your thoughts.';

  @override
  String get communityWriteGuidelineTitle => 'Community Guidelines';

  @override
  String get communityWriteGuidelineBody =>
      'Please communicate respectfully. Profanity, personal attacks, hate speech, and defamatory content are not allowed. Repeated violations may result in restricted community access.';

  @override
  String get communityContentRequired => 'Please enter post content.';

  @override
  String get communityContentRestricted =>
      'This content includes restricted terms and cannot be posted.';

  @override
  String get communityEdit => 'Edit';

  @override
  String get communityDelete => 'Delete';

  @override
  String get communityCancel => 'Cancel';

  @override
  String get communityDeletePostTitle => 'Delete this post?';

  @override
  String get communityDeletePostBody =>
      'This post will be deleted permanently.';

  @override
  String get communityComments => 'Comments';

  @override
  String get communityCommentHint => 'Write a comment';

  @override
  String get communityCommentGuideline => 'No profanity or personal attacks.';

  @override
  String get communityCommentSend => 'Send';

  @override
  String get communityCommentRequired => 'Please enter a comment.';

  @override
  String get communityCommentRestricted =>
      'This comment includes restricted terms and cannot be posted.';

  @override
  String get communityCommentLoadFailed => 'Failed to load comments.';

  @override
  String get communityCommentEmpty => 'No comments yet.';

  @override
  String get communityCommentDeleted => 'Comment deleted.';

  @override
  String get communityCoachBadge => 'Coach';

  @override
  String get communityReport => 'Report';

  @override
  String get communityReportTitle => 'Report';

  @override
  String get communityReportReason => 'Reason';

  @override
  String get communityReportReasonSpam => 'Spam or advertising';

  @override
  String get communityReportReasonHate => 'Hate or discrimination';

  @override
  String get communityReportReasonSexual => 'Sexual content';

  @override
  String get communityReportReasonHarassment => 'Harassment or threats';

  @override
  String get communityReportReasonOther => 'Other';

  @override
  String get communityReportDetail => 'Details (optional)';

  @override
  String get communityReportDetailHint => 'Tell us more about this report.';

  @override
  String get communityReportSubmit => 'Submit report';

  @override
  String get communityReportSubmitted => 'Report submitted.';

  @override
  String get communityHide => 'Hide';

  @override
  String get communityHidePostTitle => 'Hide this post?';

  @override
  String get communityHidePostBody =>
      'Hidden posts will not appear in your feed.';

  @override
  String get communityPostHidden => 'Post hidden.';

  @override
  String get communityBlockUser => 'Block author';

  @override
  String get communityBlockUserTitle => 'Block this author?';

  @override
  String get communityBlockUserBody =>
      'Blocked users\' posts and comments will no longer be shown.';

  @override
  String get communityUserBlocked => 'User blocked.';

  @override
  String get communityAddImages => 'Add Images';

  @override
  String get communityImageUnsupportedType =>
      'Only JPG, PNG, and WEBP are supported.';

  @override
  String get communityImagePickFailed => 'Failed to select images.';

  @override
  String get communityImageUploadFailed => 'Failed to upload images.';

  @override
  String communityImageCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String communityImageLimitReached(int max) {
    return 'You can upload up to $max images.';
  }

  @override
  String communityImageTooLarge(int maxMb) {
    return 'Each image must be ${maxMb}MB or less.';
  }

  @override
  String communityTimeAgoSeconds(int seconds) {
    return '${seconds}s ago';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '${hours}h ago';
  }

  @override
  String communityTimeAgoDays(int days) {
    return '${days}d ago';
  }

  @override
  String communityTimeAgoWeeks(int weeks) {
    return '${weeks}w ago';
  }

  @override
  String noticePublishedAt(Object date) {
    return 'Published $date';
  }

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
  String get homeProgramDetailSessionTypeRest => 'Rest';

  @override
  String get homeProgramDetailScheduled => 'Scheduled';

  @override
  String get homeProgramDetailScheduledDescription =>
      'This session is not open yet.';

  @override
  String homeProgramDetailScheduledAt(Object dateTime) {
    return 'Opens at $dateTime';
  }

  @override
  String get homeProgramDetailRestDescription =>
      'Today is a recovery day. Follow light recovery activities and take enough rest.';

  @override
  String get homeCoachInfoAction => 'Coach';

  @override
  String get homeCoachInfoTitle => 'Coach Info';

  @override
  String get homeCoachInfoEmpty => 'Coach information is not available yet.';

  @override
  String get homeCoachInfoName => 'Name';

  @override
  String get homeCoachInfoCareer => 'Career';

  @override
  String get homeCoachInfoInstagram => 'Instagram';

  @override
  String get homeCoachInfoInstagramOpenFailed => 'Could not open Instagram.';

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
  String get profileGenderLabel => 'Gender';

  @override
  String get profileGenderHint => 'Select your gender';

  @override
  String get profileGenderRequired => 'Please select your gender.';

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
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

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
  String get settingsCommunitySupport => 'Community report support';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Deactivate your account and block sign-in.';

  @override
  String get settingsDeleteAccountMemberOnly =>
      'Coach and owner accounts cannot be deactivated.';

  @override
  String get settingsDeleteAccountDialogTitle => 'Deactivate this account?';

  @override
  String get settingsDeleteAccountDialogBody =>
      'Your account will be deactivated immediately and sign-in will be blocked. Account and service usage data will be retained according to policy and applicable laws.';

  @override
  String get settingsDeleteAccountCancel => 'Cancel';

  @override
  String get settingsDeleteAccountConfirm => 'Deactivate account';

  @override
  String get settingsDeleteAccountFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get settingsDeleteAccountSuccess =>
      'Your account has been deactivated.';

  @override
  String get settingsContactOpenFailed =>
      'Unable to open contact app. Please check your email app.';

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
  String get workoutRecordValueSeconds => 'Time (mm:ss)';

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
  String get workoutRecordInvalidDurationFormat =>
      'Enter time in mm:ss format, e.g. 18:55.';

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
  String get workoutRecordTemplateRowing => 'Rowing';

  @override
  String get workoutRecordTemplateRunning => 'Running';

  @override
  String get workoutRecordTemplateSki => 'Ski';

  @override
  String get workoutRecordTemplateSquat => 'Squat';

  @override
  String get workoutRecordTemplateDeadlift => 'Deadlift';

  @override
  String get workoutRecordTemplateBenchPress => 'Bench Press';

  @override
  String get workoutRecordTemplateCardioDescription =>
      'Record distance, duration, and date.';

  @override
  String get workoutRecordTemplateStrengthDescription =>
      'Record weight, reps, and date.';

  @override
  String get workoutRecordViewRecords => 'View records';

  @override
  String get workoutRecordViewLeaderboard => 'View leaderboard';

  @override
  String workoutRecordEntryTitle(Object exercise) {
    return 'Add $exercise record';
  }

  @override
  String workoutRecordListTitle(Object exercise) {
    return '$exercise records';
  }

  @override
  String get workoutRecordDistance => 'Distance';

  @override
  String get workoutRecordPreset => 'Preset';

  @override
  String get workoutRecordDuration => 'Duration (mm:ss)';

  @override
  String get workoutRecordWeight => 'Weight';

  @override
  String get workoutRecordReps => 'Reps';

  @override
  String workoutRecordEmptyByExercise(Object exercise) {
    return 'No $exercise records yet.';
  }

  @override
  String workoutRecordDistanceAndDuration(Object distance, Object duration) {
    return 'Distance $distance · Duration $duration';
  }

  @override
  String workoutRecordStrengthWeightAndReps(Object weight, Object reps) {
    return 'Weight $weight · Reps $reps';
  }

  @override
  String workoutRecordLeaderboardTitle(Object exercise) {
    return '$exercise leaderboard';
  }

  @override
  String get workoutRecordLeaderboardFilterPreset => 'Preset';

  @override
  String get workoutRecordLeaderboardEmpty => 'No leaderboard records yet.';

  @override
  String get workoutRecordLeaderboardLoadFailed =>
      'Failed to load leaderboard.';

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
  String get onboardingGenderLabel => 'Gender';

  @override
  String get onboardingGenderHint => 'Select your gender';

  @override
  String get onboardingGenderRequired => 'Please select your gender.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingSaving => 'Saving...';

  @override
  String get onboardingSaveFailed =>
      'Failed to save profile. Please try again.';
}
