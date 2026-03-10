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

  /// No description provided for @homeNotice.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get homeNotice;

  /// No description provided for @noticeTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get noticeTitle;

  /// No description provided for @noticeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load news. Please try again.'**
  String get noticeLoadFailed;

  /// No description provided for @noticeLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more news.'**
  String get noticeLoadMoreFailed;

  /// No description provided for @noticeRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get noticeRetry;

  /// No description provided for @noticeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No news yet.'**
  String get noticeEmpty;

  /// No description provided for @noticeNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content.'**
  String get noticeNoContent;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get communityWrite;

  /// No description provided for @communityWritePost.
  ///
  /// In en, this message translates to:
  /// **'Write Post'**
  String get communityWritePost;

  /// No description provided for @communityEditPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get communityEditPost;

  /// No description provided for @communitySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get communitySave;

  /// No description provided for @communitySaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get communitySaving;

  /// No description provided for @communityRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get communityRetry;

  /// No description provided for @communityLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load community posts. Please try again.'**
  String get communityLoadFailed;

  /// No description provided for @communityMembershipRequired.
  ///
  /// In en, this message translates to:
  /// **'Community is available only for members with an active pass.'**
  String get communityMembershipRequired;

  /// No description provided for @communityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get communityEmpty;

  /// No description provided for @communityActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed. Please try again.'**
  String get communityActionFailed;

  /// No description provided for @communityContentHint.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts.'**
  String get communityContentHint;

  /// No description provided for @communityWriteGuidelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Guidelines'**
  String get communityWriteGuidelineTitle;

  /// No description provided for @communityWriteGuidelineBody.
  ///
  /// In en, this message translates to:
  /// **'Please communicate respectfully. Profanity, personal attacks, hate speech, and defamatory content are not allowed. Repeated violations may result in restricted community access.'**
  String get communityWriteGuidelineBody;

  /// No description provided for @communityContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter post content.'**
  String get communityContentRequired;

  /// No description provided for @communityContentRestricted.
  ///
  /// In en, this message translates to:
  /// **'This content includes restricted terms and cannot be posted.'**
  String get communityContentRestricted;

  /// No description provided for @communityEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get communityEdit;

  /// No description provided for @communityDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get communityDelete;

  /// No description provided for @communityCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get communityCancel;

  /// No description provided for @communityDeletePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this post?'**
  String get communityDeletePostTitle;

  /// No description provided for @communityDeletePostBody.
  ///
  /// In en, this message translates to:
  /// **'This post will be deleted permanently.'**
  String get communityDeletePostBody;

  /// No description provided for @communityComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get communityComments;

  /// No description provided for @communityCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get communityCommentHint;

  /// No description provided for @communityCommentGuideline.
  ///
  /// In en, this message translates to:
  /// **'No profanity or personal attacks.'**
  String get communityCommentGuideline;

  /// No description provided for @communityCommentSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get communityCommentSend;

  /// No description provided for @communityCommentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a comment.'**
  String get communityCommentRequired;

  /// No description provided for @communityCommentRestricted.
  ///
  /// In en, this message translates to:
  /// **'This comment includes restricted terms and cannot be posted.'**
  String get communityCommentRestricted;

  /// No description provided for @communityCommentLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments.'**
  String get communityCommentLoadFailed;

  /// No description provided for @communityCommentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get communityCommentEmpty;

  /// No description provided for @communityCommentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted.'**
  String get communityCommentDeleted;

  /// No description provided for @communityCoachBadge.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get communityCoachBadge;

  /// No description provided for @communityReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get communityReport;

  /// No description provided for @communityReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get communityReportTitle;

  /// No description provided for @communityReportReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get communityReportReason;

  /// No description provided for @communityReportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or advertising'**
  String get communityReportReasonSpam;

  /// No description provided for @communityReportReasonHate.
  ///
  /// In en, this message translates to:
  /// **'Hate or discrimination'**
  String get communityReportReasonHate;

  /// No description provided for @communityReportReasonSexual.
  ///
  /// In en, this message translates to:
  /// **'Sexual content'**
  String get communityReportReasonSexual;

  /// No description provided for @communityReportReasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or threats'**
  String get communityReportReasonHarassment;

  /// No description provided for @communityReportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get communityReportReasonOther;

  /// No description provided for @communityReportDetail.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get communityReportDetail;

  /// No description provided for @communityReportDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about this report.'**
  String get communityReportDetailHint;

  /// No description provided for @communityReportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get communityReportSubmit;

  /// No description provided for @communityReportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted.'**
  String get communityReportSubmitted;

  /// No description provided for @communityHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get communityHide;

  /// No description provided for @communityHidePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide this post?'**
  String get communityHidePostTitle;

  /// No description provided for @communityHidePostBody.
  ///
  /// In en, this message translates to:
  /// **'Hidden posts will not appear in your feed.'**
  String get communityHidePostBody;

  /// No description provided for @communityPostHidden.
  ///
  /// In en, this message translates to:
  /// **'Post hidden.'**
  String get communityPostHidden;

  /// No description provided for @communityBlockUser.
  ///
  /// In en, this message translates to:
  /// **'Block author'**
  String get communityBlockUser;

  /// No description provided for @communityBlockUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Block this author?'**
  String get communityBlockUserTitle;

  /// No description provided for @communityBlockUserBody.
  ///
  /// In en, this message translates to:
  /// **'Blocked users\' posts and comments will no longer be shown.'**
  String get communityBlockUserBody;

  /// No description provided for @communityUserBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked.'**
  String get communityUserBlocked;

  /// No description provided for @communityAddImages.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get communityAddImages;

  /// No description provided for @communityImageUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Only JPG, PNG, and WEBP are supported.'**
  String get communityImageUnsupportedType;

  /// No description provided for @communityImagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select images.'**
  String get communityImagePickFailed;

  /// No description provided for @communityImageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload images.'**
  String get communityImageUploadFailed;

  /// No description provided for @communityImageCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String communityImageCount(int current, int max);

  /// No description provided for @communityImageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to {max} images.'**
  String communityImageLimitReached(int max);

  /// No description provided for @communityImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Each image must be {maxMb}MB or less.'**
  String communityImageTooLarge(int maxMb);

  /// No description provided for @communityTimeAgoSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s ago'**
  String communityTimeAgoSeconds(int seconds);

  /// No description provided for @communityTimeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String communityTimeAgoMinutes(int minutes);

  /// No description provided for @communityTimeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String communityTimeAgoHours(int hours);

  /// No description provided for @communityTimeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String communityTimeAgoDays(int days);

  /// No description provided for @communityTimeAgoWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks}w ago'**
  String communityTimeAgoWeeks(int weeks);

  /// No description provided for @noticePublishedAt.
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String noticePublishedAt(Object date);

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

  /// No description provided for @homeProgramDetailSessionTypeRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get homeProgramDetailSessionTypeRest;

  /// No description provided for @homeProgramDetailScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get homeProgramDetailScheduled;

  /// No description provided for @homeProgramDetailScheduledDescription.
  ///
  /// In en, this message translates to:
  /// **'This session is not open yet.'**
  String get homeProgramDetailScheduledDescription;

  /// No description provided for @homeProgramDetailScheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Opens at {dateTime}'**
  String homeProgramDetailScheduledAt(Object dateTime);

  /// No description provided for @homeProgramDetailRestDescription.
  ///
  /// In en, this message translates to:
  /// **'Today is a recovery day. Follow light recovery activities and take enough rest.'**
  String get homeProgramDetailRestDescription;

  /// No description provided for @homeCoachInfoAction.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get homeCoachInfoAction;

  /// No description provided for @homeCoachInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach Info'**
  String get homeCoachInfoTitle;

  /// No description provided for @homeCoachInfoEmpty.
  ///
  /// In en, this message translates to:
  /// **'Coach information is not available yet.'**
  String get homeCoachInfoEmpty;

  /// No description provided for @homeCoachInfoName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get homeCoachInfoName;

  /// No description provided for @homeCoachInfoCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get homeCoachInfoCareer;

  /// No description provided for @homeCoachInfoInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get homeCoachInfoInstagram;

  /// No description provided for @homeCoachInfoInstagramOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Instagram.'**
  String get homeCoachInfoInstagramOpenFailed;

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

  /// No description provided for @profileGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGenderLabel;

  /// No description provided for @profileGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get profileGenderHint;

  /// No description provided for @profileGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender.'**
  String get profileGenderRequired;

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

  /// No description provided for @profileMyPrograms.
  ///
  /// In en, this message translates to:
  /// **'My Programs'**
  String get profileMyPrograms;

  /// No description provided for @profileMyProgramsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileMyProgramsActive;

  /// No description provided for @profileMyProgramsInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get profileMyProgramsInactive;

  /// No description provided for @profileMyProgramsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load your programs.'**
  String get profileMyProgramsLoadFailed;

  /// No description provided for @profileMyProgramsLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more programs.'**
  String get profileMyProgramsLoadMoreFailed;

  /// No description provided for @profileMyProgramsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileMyProgramsRetry;

  /// No description provided for @profileMyProgramsActivationPeriod.
  ///
  /// In en, this message translates to:
  /// **'Activation period'**
  String get profileMyProgramsActivationPeriod;

  /// No description provided for @profileMyProgramsNoStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date unavailable'**
  String get profileMyProgramsNoStartDate;

  /// No description provided for @profileMyProgramsIndefinite.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get profileMyProgramsIndefinite;

  /// No description provided for @profileMyProgramsOpenEnded.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get profileMyProgramsOpenEnded;

  /// No description provided for @profileMyProgramsExpired.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get profileMyProgramsExpired;

  /// No description provided for @profileMyProgramsEndsToday.
  ///
  /// In en, this message translates to:
  /// **'Ends today'**
  String get profileMyProgramsEndsToday;

  /// No description provided for @profileMyProgramsDday.
  ///
  /// In en, this message translates to:
  /// **'D-{days}'**
  String profileMyProgramsDday(int days);

  /// No description provided for @profileMyProgramsEmptyActive.
  ///
  /// In en, this message translates to:
  /// **'There is no active program right now.'**
  String get profileMyProgramsEmptyActive;

  /// No description provided for @profileMyProgramsEmptyInactive.
  ///
  /// In en, this message translates to:
  /// **'There are no inactive programs.'**
  String get profileMyProgramsEmptyInactive;

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

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

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

  /// No description provided for @settingsCommunitySupport.
  ///
  /// In en, this message translates to:
  /// **'Community report support'**
  String get settingsCommunitySupport;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate your account and block sign-in.'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsDeleteAccountMemberOnly.
  ///
  /// In en, this message translates to:
  /// **'Coach and owner accounts cannot be deactivated.'**
  String get settingsDeleteAccountMemberOnly;

  /// No description provided for @settingsDeleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate this account?'**
  String get settingsDeleteAccountDialogTitle;

  /// No description provided for @settingsDeleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deactivated immediately and sign-in will be blocked. Account and service usage data will be retained according to policy and applicable laws.'**
  String get settingsDeleteAccountDialogBody;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deactivate account'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settingsDeleteAccountFailed;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deactivated.'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @settingsContactOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open contact app. Please check your email app.'**
  String get settingsContactOpenFailed;

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
  /// **'Time (mm:ss)'**
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

  /// No description provided for @workoutRecordInvalidDurationFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter time in mm:ss format, e.g. 18:55.'**
  String get workoutRecordInvalidDurationFormat;

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

  /// No description provided for @workoutRecordTemplateRowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get workoutRecordTemplateRowing;

  /// No description provided for @workoutRecordTemplateRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get workoutRecordTemplateRunning;

  /// No description provided for @workoutRecordTemplateSki.
  ///
  /// In en, this message translates to:
  /// **'Ski'**
  String get workoutRecordTemplateSki;

  /// No description provided for @workoutRecordTemplateSquat.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get workoutRecordTemplateSquat;

  /// No description provided for @workoutRecordTemplateDeadlift.
  ///
  /// In en, this message translates to:
  /// **'Deadlift'**
  String get workoutRecordTemplateDeadlift;

  /// No description provided for @workoutRecordTemplateBenchPress.
  ///
  /// In en, this message translates to:
  /// **'Bench Press'**
  String get workoutRecordTemplateBenchPress;

  /// No description provided for @workoutRecordTemplateCardioDescription.
  ///
  /// In en, this message translates to:
  /// **'Record distance, duration, and date.'**
  String get workoutRecordTemplateCardioDescription;

  /// No description provided for @workoutRecordTemplateStrengthDescription.
  ///
  /// In en, this message translates to:
  /// **'Record weight, reps, and date.'**
  String get workoutRecordTemplateStrengthDescription;

  /// No description provided for @workoutRecordViewRecords.
  ///
  /// In en, this message translates to:
  /// **'View records'**
  String get workoutRecordViewRecords;

  /// No description provided for @workoutRecordViewLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'View leaderboard'**
  String get workoutRecordViewLeaderboard;

  /// No description provided for @workoutRecordEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {exercise} record'**
  String workoutRecordEntryTitle(Object exercise);

  /// No description provided for @workoutRecordListTitle.
  ///
  /// In en, this message translates to:
  /// **'{exercise} records'**
  String workoutRecordListTitle(Object exercise);

  /// No description provided for @workoutRecordDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get workoutRecordDistance;

  /// No description provided for @workoutRecordPreset.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get workoutRecordPreset;

  /// No description provided for @workoutRecordDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (mm:ss)'**
  String get workoutRecordDuration;

  /// No description provided for @workoutRecordWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get workoutRecordWeight;

  /// No description provided for @workoutRecordReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutRecordReps;

  /// No description provided for @workoutRecordEmptyByExercise.
  ///
  /// In en, this message translates to:
  /// **'No {exercise} records yet.'**
  String workoutRecordEmptyByExercise(Object exercise);

  /// No description provided for @workoutRecordDistanceAndDuration.
  ///
  /// In en, this message translates to:
  /// **'Distance {distance} · Duration {duration}'**
  String workoutRecordDistanceAndDuration(Object distance, Object duration);

  /// No description provided for @workoutRecordStrengthWeightAndReps.
  ///
  /// In en, this message translates to:
  /// **'Weight {weight} · Reps {reps}'**
  String workoutRecordStrengthWeightAndReps(Object weight, Object reps);

  /// No description provided for @workoutRecordLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'{exercise} leaderboard'**
  String workoutRecordLeaderboardTitle(Object exercise);

  /// No description provided for @workoutRecordLeaderboardFilterPreset.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get workoutRecordLeaderboardFilterPreset;

  /// No description provided for @workoutRecordLeaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard records yet.'**
  String get workoutRecordLeaderboardEmpty;

  /// No description provided for @workoutRecordLeaderboardLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load leaderboard.'**
  String get workoutRecordLeaderboardLoadFailed;

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

  /// No description provided for @onboardingGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get onboardingGenderLabel;

  /// No description provided for @onboardingGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get onboardingGenderHint;

  /// No description provided for @onboardingGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender.'**
  String get onboardingGenderRequired;

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
