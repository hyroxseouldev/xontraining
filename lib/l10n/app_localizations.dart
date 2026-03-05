import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'XON Training'**
  String get appTitle;

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Welcome to XON Training'**
  String get loginHeadline;

  /// No description provided for @loginGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginGoogleButton;

  /// No description provided for @loginAppleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get loginAppleButton;

  /// No description provided for @loginLoading.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginLoading;

  /// No description provided for @loginCanceled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was canceled.'**
  String get loginCanceled;

  /// No description provided for @loginConfigError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is not configured correctly.'**
  String get loginConfigError;

  /// No description provided for @loginNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Check your connection and try again.'**
  String get loginNetworkError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeProgramsTitle.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get homeProgramsTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'You are logged in.'**
  String get homeWelcome;

  /// No description provided for @homeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load home data. Please try again.'**
  String get homeLoadFailed;

  /// No description provided for @homeNoPrograms.
  ///
  /// In en, this message translates to:
  /// **'No programs available.'**
  String get homeNoPrograms;

  /// No description provided for @homeNoActiveProgram.
  ///
  /// In en, this message translates to:
  /// **'No active program found.'**
  String get homeNoActiveProgram;

  /// No description provided for @homeCurrentProgram.
  ///
  /// In en, this message translates to:
  /// **'Current Program'**
  String get homeCurrentProgram;

  /// No description provided for @homeScheduleForDate.
  ///
  /// In en, this message translates to:
  /// **'Schedule for {date}'**
  String homeScheduleForDate(Object date);

  /// No description provided for @homeNoScheduleForDate.
  ///
  /// In en, this message translates to:
  /// **'No schedule for this date.'**
  String get homeNoScheduleForDate;

  /// No description provided for @homeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfile;

  /// No description provided for @homeProgramInfoDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get homeProgramInfoDuration;

  /// No description provided for @homeProgramInfoDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get homeProgramInfoDifficulty;

  /// No description provided for @homeProgramInfoWorkoutTime.
  ///
  /// In en, this message translates to:
  /// **'Workout Time'**
  String get homeProgramInfoWorkoutTime;

  /// No description provided for @homeProgramInfoWeeklySessions.
  ///
  /// In en, this message translates to:
  /// **'Weekly Sessions'**
  String get homeProgramInfoWeeklySessions;

  /// No description provided for @homeProgramDifficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get homeProgramDifficultyBeginner;

  /// No description provided for @homeProgramDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get homeProgramDifficultyIntermediate;

  /// No description provided for @homeProgramDifficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get homeProgramDifficultyAdvanced;

  /// No description provided for @homeProgramDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Program Detail'**
  String get homeProgramDetailTitle;

  /// No description provided for @homeProgramDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Detail view skeleton is ready.'**
  String get homeProgramDetailDescription;

  /// No description provided for @homeProgramDetailComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Detailed sections, progress, and actions will be added next.'**
  String get homeProgramDetailComingSoon;

  /// No description provided for @homeProgramDetailPurchaseRequired.
  ///
  /// In en, this message translates to:
  /// **'This page is available after purchase and activation.'**
  String get homeProgramDetailPurchaseRequired;

  /// No description provided for @homeProgramDetailNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions are available for this program yet.'**
  String get homeProgramDetailNoSessions;

  /// No description provided for @homeProgramDetailNoSessionForSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'No session for the selected date.'**
  String get homeProgramDetailNoSessionForSelectedDate;

  /// No description provided for @homeProgramDetailSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get homeProgramDetailSelectDate;

  /// No description provided for @homeProgramDetailToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeProgramDetailToday;

  /// No description provided for @homeProgramDetailIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Program ID: {id}'**
  String homeProgramDetailIdLabel(Object id);

  /// No description provided for @homeProgramDetailSessionMeta.
  ///
  /// In en, this message translates to:
  /// **'{date} · Week {week} · {day}'**
  String homeProgramDetailSessionMeta(Object date, int week, Object day);

  /// No description provided for @homeProgramDetailSessionMetaNoDay.
  ///
  /// In en, this message translates to:
  /// **'{date} · Week {week}'**
  String homeProgramDetailSessionMetaNoDay(Object date, int week);

  /// No description provided for @homeProgramDetailSessionMetaNoWeek.
  ///
  /// In en, this message translates to:
  /// **'{date} · {day}'**
  String homeProgramDetailSessionMetaNoWeek(Object date, Object day);

  /// No description provided for @homeProgramValueNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get homeProgramValueNotAvailable;

  /// No description provided for @homeProgramDurationWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks'**
  String homeProgramDurationWeeks(int weeks);

  /// No description provided for @homeProgramWorkoutMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String homeProgramWorkoutMinutes(int minutes);

  /// No description provided for @homeProgramWeeklySessions.
  ///
  /// In en, this message translates to:
  /// **'{days}x / week'**
  String homeProgramWeeklySessions(int days);

  /// No description provided for @homeSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeSignOut;

  /// No description provided for @homeSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String homeSignedInAs(Object email);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileSaving;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again.'**
  String get profileSaveFailed;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get profileNameHint;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get profileNameRequired;

  /// No description provided for @profileSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String profileSignedInAs(Object email);

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get profileMenuTitle;

  /// No description provided for @profileWorkoutRecord.
  ///
  /// In en, this message translates to:
  /// **'My Workout Performance Log'**
  String get profileWorkoutRecord;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Profile edit page skeleton is ready.'**
  String get profileEditComingSoon;

  /// No description provided for @profileEditChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get profileEditChangePhoto;

  /// No description provided for @profileEditImagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image. Please try again.'**
  String get profileEditImagePickFailed;

  /// No description provided for @profileEditImageUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Only JPG, PNG, and WEBP images are allowed.'**
  String get profileEditImageUnsupportedType;

  /// No description provided for @profileEditImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image is too large. Please select up to {maxMb}MB.'**
  String profileEditImageTooLarge(int maxMb);

  /// No description provided for @profileWorkoutRecordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Workout performance log page skeleton is ready.'**
  String get profileWorkoutRecordComingSoon;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Settings page skeleton is ready.'**
  String get settingsDescription;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed. Please try again.'**
  String get settingsActionFailed;

  /// No description provided for @settingsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get settingsAppVersion;

  /// No description provided for @settingsVersionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get settingsVersionLoading;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @settingsTermsOfServiceBody.
  ///
  /// In en, this message translates to:
  /// **'Terms of service content will be provided and updated by your organization.'**
  String get settingsTermsOfServiceBody;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy content will be provided and updated by your organization.'**
  String get settingsPrivacyPolicyBody;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all related data.'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsDeleteAccountMemberOnly.
  ///
  /// In en, this message translates to:
  /// **'Only member accounts can be deleted.'**
  String get settingsDeleteAccountMemberOnly;

  /// No description provided for @settingsDeleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account permanently?'**
  String get settingsDeleteAccountDialogTitle;

  /// No description provided for @settingsDeleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account is immediate and cannot be undone. Purchase history, workout records, profile information, offline classes you created, and class registrations will all be deleted. Your previous data cannot be restored even if you sign in again.'**
  String get settingsDeleteAccountDialogBody;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settingsDeleteAccountFailed;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @legalDocumentLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading document...'**
  String get legalDocumentLoading;

  /// No description provided for @legalDocumentLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document.'**
  String get legalDocumentLoadFailed;

  /// No description provided for @legalDocumentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version:'**
  String get legalDocumentVersionLabel;

  /// No description provided for @legalDocumentUpdatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated:'**
  String get legalDocumentUpdatedAtLabel;

  /// No description provided for @workoutRecordAdd.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get workoutRecordAdd;

  /// No description provided for @workoutRecordEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get workoutRecordEdit;

  /// No description provided for @workoutRecordDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get workoutRecordDelete;

  /// No description provided for @workoutRecordEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workout records yet.'**
  String get workoutRecordEmpty;

  /// No description provided for @workoutRecordLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load workout records.'**
  String get workoutRecordLoadFailed;

  /// No description provided for @workoutRecordSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save workout record.'**
  String get workoutRecordSaveFailed;

  /// No description provided for @workoutRecordSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout record saved.'**
  String get workoutRecordSaved;

  /// No description provided for @workoutRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Workout record deleted.'**
  String get workoutRecordDeleted;

  /// No description provided for @workoutRecordDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete workout record.'**
  String get workoutRecordDeleteFailed;

  /// No description provided for @workoutRecordMetricWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get workoutRecordMetricWeight;

  /// No description provided for @workoutRecordMetricReps.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get workoutRecordMetricReps;

  /// No description provided for @workoutRecordMetricDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get workoutRecordMetricDistance;

  /// No description provided for @workoutRecordMetricDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get workoutRecordMetricDuration;

  /// No description provided for @workoutRecordAddDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add workout record'**
  String get workoutRecordAddDialogTitle;

  /// No description provided for @workoutRecordEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit workout record'**
  String get workoutRecordEditDialogTitle;

  /// No description provided for @workoutRecordExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get workoutRecordExerciseName;

  /// No description provided for @workoutRecordMetricType.
  ///
  /// In en, this message translates to:
  /// **'Metric type'**
  String get workoutRecordMetricType;

  /// No description provided for @workoutRecordValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get workoutRecordValue;

  /// No description provided for @workoutRecordValueSeconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get workoutRecordValueSeconds;

  /// No description provided for @workoutRecordUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get workoutRecordUnit;

  /// No description provided for @workoutRecordDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get workoutRecordDate;

  /// No description provided for @workoutRecordMemo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get workoutRecordMemo;

  /// No description provided for @workoutRecordRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get workoutRecordRequired;

  /// No description provided for @workoutRecordInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number greater than 0.'**
  String get workoutRecordInvalidNumber;

  /// No description provided for @workoutRecordCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workoutRecordCancel;

  /// No description provided for @workoutRecordSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get workoutRecordSave;

  /// No description provided for @workoutRecordDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get workoutRecordDeleteDialogTitle;

  /// No description provided for @workoutRecordDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This record will be deleted permanently.'**
  String get workoutRecordDeleteDialogBody;

  /// No description provided for @workoutRecordSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by exercise or memo'**
  String get workoutRecordSearchHint;

  /// No description provided for @workoutRecordSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get workoutRecordSortNewest;

  /// No description provided for @workoutRecordSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get workoutRecordSortOldest;

  /// No description provided for @workoutRecordNoSearchResult.
  ///
  /// In en, this message translates to:
  /// **'No records match your search.'**
  String get workoutRecordNoSearchResult;

  /// No description provided for @workoutRecordUseDefaultUnit.
  ///
  /// In en, this message translates to:
  /// **'Use default unit'**
  String get workoutRecordUseDefaultUnit;

  /// No description provided for @workoutRecordUseDefaultUnitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically lock unit for each metric type'**
  String get workoutRecordUseDefaultUnitSubtitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile to continue.'**
  String get onboardingDescription;

  /// No description provided for @onboardingNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get onboardingNameLabel;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get onboardingNameHint;

  /// No description provided for @onboardingNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get onboardingNameRequired;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get onboardingSaving;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get onboardingSaveFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
