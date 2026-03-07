// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'XON 트레이닝';

  @override
  String get loginHeadline => 'XON 트레이닝에 오신 것을 환영합니다';

  @override
  String get loginGoogleButton => 'Google로 로그인';

  @override
  String get loginAppleButton => 'Apple로 로그인';

  @override
  String get loginLoading => '로그인 중...';

  @override
  String get loginCanceled => '로그인이 취소되었습니다.';

  @override
  String get loginConfigError => '로그인 설정이 올바르지 않습니다.';

  @override
  String get loginNetworkError => '네트워크 오류가 발생했습니다. 연결을 확인해 주세요.';

  @override
  String get loginFailed => '로그인에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get homeTitle => '홈';

  @override
  String get homeProgramsTitle => '프로그램';

  @override
  String get homeWelcome => '로그인되었습니다.';

  @override
  String get homeLoadFailed => '홈 데이터를 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  String get homeNoPrograms => '표시할 프로그램이 없습니다.';

  @override
  String get homeNoActiveProgram => '활성화된 프로그램이 없습니다.';

  @override
  String get homeCurrentProgram => '현재 프로그램';

  @override
  String homeScheduleForDate(Object date) {
    return '$date 스케줄';
  }

  @override
  String get homeNoScheduleForDate => '선택한 날짜의 스케줄이 없습니다.';

  @override
  String get homeProfile => '프로필';

  @override
  String get homeNotice => '새소식';

  @override
  String get noticeTitle => '새소식';

  @override
  String get noticeLoadFailed => '새소식을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  String get noticeLoadMoreFailed => '추가 새소식을 불러오지 못했습니다.';

  @override
  String get noticeRetry => '다시 시도';

  @override
  String get noticeEmpty => '등록된 새소식이 없습니다.';

  @override
  String get noticeNoContent => '내용이 없습니다.';

  @override
  String get communityTitle => '커뮤니티';

  @override
  String get communityWrite => '작성';

  @override
  String get communityWritePost => '게시글 작성';

  @override
  String get communityEditPost => '게시글 수정';

  @override
  String get communitySave => '저장';

  @override
  String get communitySaving => '저장 중...';

  @override
  String get communityRetry => '다시 시도';

  @override
  String get communityLoadFailed => '커뮤니티 글을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  String get communityMembershipRequired => '커뮤니티는 회원권이 활성화된 회원만 이용할 수 있습니다.';

  @override
  String get communityEmpty => '아직 게시글이 없습니다.';

  @override
  String get communityActionFailed => '처리에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get communityContentHint => '내용을 입력해 주세요.';

  @override
  String get communityContentRequired => '게시글 내용을 입력해 주세요.';

  @override
  String get communityContentRestricted => '운영 정책상 제한된 표현이 포함되어 등록할 수 없습니다.';

  @override
  String get communityEdit => '수정';

  @override
  String get communityDelete => '삭제';

  @override
  String get communityCancel => '취소';

  @override
  String get communityDeletePostTitle => '이 게시글을 삭제할까요?';

  @override
  String get communityDeletePostBody => '이 게시글은 영구적으로 삭제됩니다.';

  @override
  String get communityComments => '댓글';

  @override
  String get communityCommentHint => '댓글을 입력해 주세요';

  @override
  String get communityCommentSend => '등록';

  @override
  String get communityCommentRequired => '댓글 내용을 입력해 주세요.';

  @override
  String get communityCommentRestricted => '운영 정책상 제한된 표현이 포함되어 등록할 수 없습니다.';

  @override
  String get communityCommentLoadFailed => '댓글을 불러오지 못했습니다.';

  @override
  String get communityCommentEmpty => '아직 댓글이 없습니다.';

  @override
  String get communityCommentDeleted => '댓글이 삭제되었습니다.';

  @override
  String get communityReport => '신고';

  @override
  String get communityReportTitle => '신고하기';

  @override
  String get communityReportReason => '신고 사유';

  @override
  String get communityReportReasonSpam => '스팸/광고';

  @override
  String get communityReportReasonHate => '혐오/차별';

  @override
  String get communityReportReasonSexual => '음란/선정성';

  @override
  String get communityReportReasonHarassment => '괴롭힘/위협';

  @override
  String get communityReportReasonOther => '기타';

  @override
  String get communityReportDetail => '상세 내용 (선택)';

  @override
  String get communityReportDetailHint => '신고 사유를 자세히 적어주세요.';

  @override
  String get communityReportSubmit => '신고 접수';

  @override
  String get communityReportSubmitted => '신고가 접수되었습니다.';

  @override
  String get communityHide => '숨김';

  @override
  String get communityHidePostTitle => '이 게시글을 숨길까요?';

  @override
  String get communityHidePostBody => '숨긴 게시글은 내 피드에서 보이지 않습니다.';

  @override
  String get communityPostHidden => '게시글을 숨겼습니다.';

  @override
  String get communityBlockUser => '작성자 차단';

  @override
  String get communityBlockUserTitle => '이 작성자를 차단할까요?';

  @override
  String get communityBlockUserBody => '차단하면 해당 사용자의 게시글과 댓글이 보이지 않습니다.';

  @override
  String get communityUserBlocked => '사용자를 차단했습니다.';

  @override
  String get communityAddImages => '이미지 추가';

  @override
  String get communityImageUnsupportedType => 'JPG, PNG, WEBP 형식만 지원합니다.';

  @override
  String get communityImagePickFailed => '이미지를 선택하지 못했습니다.';

  @override
  String get communityImageUploadFailed => '이미지 업로드에 실패했습니다.';

  @override
  String communityImageCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String communityImageLimitReached(int max) {
    return '이미지는 최대 $max장까지 업로드할 수 있습니다.';
  }

  @override
  String communityImageTooLarge(int maxMb) {
    return '이미지 1장은 ${maxMb}MB 이하여야 합니다.';
  }

  @override
  String communityTimeAgoSeconds(int seconds) {
    return '$seconds초 전';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '$minutes분 전';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '$hours시간 전';
  }

  @override
  String communityTimeAgoDays(int days) {
    return '$days일 전';
  }

  @override
  String communityTimeAgoWeeks(int weeks) {
    return '$weeks주 전';
  }

  @override
  String noticePublishedAt(Object date) {
    return '등록일 $date';
  }

  @override
  String get homeProgramInfoDuration => '기간';

  @override
  String get homeProgramInfoDifficulty => '난이도';

  @override
  String get homeProgramInfoWorkoutTime => '운동시간';

  @override
  String get homeProgramInfoWeeklySessions => '주당횟수';

  @override
  String get homeProgramDifficultyBeginner => '초급';

  @override
  String get homeProgramDifficultyIntermediate => '중급';

  @override
  String get homeProgramDifficultyAdvanced => '고급';

  @override
  String get homeProgramDetailTitle => '프로그램 상세';

  @override
  String get homeProgramDetailDescription => '상세 화면 뼈대가 준비되었습니다.';

  @override
  String get homeProgramDetailComingSoon => '상세 섹션, 진행도, 액션은 추후 추가될 예정입니다.';

  @override
  String get homeProgramDetailPurchaseRequired =>
      '이 페이지는 구매 후 활성화된 사용자만 이용할 수 있습니다.';

  @override
  String get homeProgramDetailNoSessions => '아직 이 프로그램에 등록된 세션이 없습니다.';

  @override
  String get homeProgramDetailNoSessionForSelectedDate => '선택한 날짜에 세션이 없습니다.';

  @override
  String get homeCoachInfoAction => '코치';

  @override
  String get homeCoachInfoTitle => '코치 정보';

  @override
  String get homeCoachInfoEmpty => '등록된 코치 정보가 없습니다.';

  @override
  String get homeCoachInfoName => '이름';

  @override
  String get homeCoachInfoCareer => '경력';

  @override
  String get homeCoachInfoInstagram => '인스타그램';

  @override
  String get homeCoachInfoInstagramOpenFailed => '인스타그램을 열 수 없습니다.';

  @override
  String get homeProgramDetailSelectDate => '날짜 선택';

  @override
  String get homeProgramDetailToday => '오늘';

  @override
  String homeProgramDetailIdLabel(Object id) {
    return '프로그램 ID: $id';
  }

  @override
  String homeProgramDetailSessionMeta(Object date, int week, Object day) {
    return '$date · $week주차 · $day';
  }

  @override
  String homeProgramDetailSessionMetaNoDay(Object date, int week) {
    return '$date · $week주차';
  }

  @override
  String homeProgramDetailSessionMetaNoWeek(Object date, Object day) {
    return '$date · $day';
  }

  @override
  String get homeProgramValueNotAvailable => '-';

  @override
  String homeProgramDurationWeeks(int weeks) {
    return '$weeks주';
  }

  @override
  String homeProgramWorkoutMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String homeProgramWeeklySessions(int days) {
    return '주 $days회';
  }

  @override
  String get homeSignOut => '로그아웃';

  @override
  String homeSignedInAs(Object email) {
    return '로그인 계정: $email';
  }

  @override
  String get profileTitle => '프로필';

  @override
  String get profileSignOut => '로그아웃';

  @override
  String get profileSave => '저장';

  @override
  String get profileSaving => '저장 중...';

  @override
  String get profileSaveSuccess => '프로필이 업데이트되었습니다.';

  @override
  String get profileSaveFailed => '프로필 업데이트에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get profileNameLabel => '이름';

  @override
  String get profileNameHint => '이름을 입력해 주세요';

  @override
  String get profileNameRequired => '이름을 입력해 주세요.';

  @override
  String profileSignedInAs(Object email) {
    return '로그인 계정: $email';
  }

  @override
  String get profileSettings => '설정';

  @override
  String get profileEdit => '프로필 수정';

  @override
  String get profileMenuTitle => '메뉴';

  @override
  String get profileWorkoutRecord => '내 운동 능력 기록';

  @override
  String get profileEditTitle => '프로필 수정';

  @override
  String get profileEditComingSoon => '프로필 수정 화면 뼈대가 준비되었습니다.';

  @override
  String get profileEditChangePhoto => '사진 변경';

  @override
  String get profileEditImagePickFailed => '이미지를 선택하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get profileEditImageUnsupportedType =>
      'JPG, PNG, WEBP 형식의 이미지만 업로드할 수 있습니다.';

  @override
  String profileEditImageTooLarge(int maxMb) {
    return '이미지 용량이 큽니다. ${maxMb}MB 이하 파일을 선택해 주세요.';
  }

  @override
  String get profileWorkoutRecordComingSoon => '내 운동 능력 기록 화면 뼈대가 준비되었습니다.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsDescription => '설정 화면 뼈대가 준비되었습니다.';

  @override
  String get settingsSignOut => '로그아웃';

  @override
  String get settingsActionFailed => '처리에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get settingsAppVersion => '앱 버전';

  @override
  String get settingsVersionLoading => '불러오는 중...';

  @override
  String get settingsTermsOfService => '이용약관';

  @override
  String get settingsTermsOfServiceBody => '이용약관 내용은 운영 정책에 따라 제공 및 업데이트됩니다.';

  @override
  String get settingsPrivacyPolicy => '개인정보처리방침';

  @override
  String get settingsPrivacyPolicyBody =>
      '개인정보처리방침 내용은 운영 정책에 따라 제공 및 업데이트됩니다.';

  @override
  String get settingsCommunitySupport => '커뮤니티 신고 문의';

  @override
  String get settingsDeleteAccount => '계정삭제';

  @override
  String get settingsDeleteAccountSubtitle => '계정과 관련 데이터가 영구 삭제됩니다.';

  @override
  String get settingsDeleteAccountMemberOnly => '코치/오너 권한 계정은 삭제할 수 없습니다.';

  @override
  String get settingsDeleteAccountDialogTitle => '계정을 영구 삭제할까요?';

  @override
  String get settingsDeleteAccountDialogBody =>
      '탈퇴 시 계정이 즉시 삭제되며 복구할 수 없습니다. 구매 내역, 운동 기록, 프로필 정보, 작성한 오프라인 클래스 및 신청 정보가 모두 삭제됩니다. 삭제 후에는 동일 계정으로도 이전 데이터를 복원할 수 없습니다.';

  @override
  String get settingsDeleteAccountCancel => '취소';

  @override
  String get settingsDeleteAccountConfirm => '영구 삭제';

  @override
  String get settingsDeleteAccountFailed => '계정삭제에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get settingsDeleteAccountSuccess => '계정이 삭제되었습니다.';

  @override
  String get settingsContactOpenFailed => '연락 창을 열 수 없습니다. 이메일 앱을 확인해 주세요.';

  @override
  String get legalDocumentLoading => '문서를 불러오는 중입니다...';

  @override
  String get legalDocumentLoadFailed => '문서를 불러오지 못했습니다.';

  @override
  String get legalDocumentVersionLabel => '버전:';

  @override
  String get legalDocumentUpdatedAtLabel => '개정일:';

  @override
  String get workoutRecordAdd => '기록 추가';

  @override
  String get workoutRecordEdit => '수정';

  @override
  String get workoutRecordDelete => '삭제';

  @override
  String get workoutRecordEmpty => '아직 등록된 운동 기록이 없습니다.';

  @override
  String get workoutRecordLoadFailed => '운동 기록을 불러오지 못했습니다.';

  @override
  String get workoutRecordSaveFailed => '운동 기록 저장에 실패했습니다.';

  @override
  String get workoutRecordSaved => '운동 기록이 저장되었습니다.';

  @override
  String get workoutRecordDeleted => '운동 기록이 삭제되었습니다.';

  @override
  String get workoutRecordDeleteFailed => '운동 기록 삭제에 실패했습니다.';

  @override
  String get workoutRecordMetricWeight => '중량';

  @override
  String get workoutRecordMetricReps => '횟수';

  @override
  String get workoutRecordMetricDistance => '거리';

  @override
  String get workoutRecordMetricDuration => '시간';

  @override
  String get workoutRecordAddDialogTitle => '운동 기록 추가';

  @override
  String get workoutRecordEditDialogTitle => '운동 기록 수정';

  @override
  String get workoutRecordExerciseName => '운동명';

  @override
  String get workoutRecordMetricType => '측정 항목';

  @override
  String get workoutRecordValue => '값';

  @override
  String get workoutRecordValueSeconds => '시간 (mm:ss)';

  @override
  String get workoutRecordUnit => '단위';

  @override
  String get workoutRecordDate => '기록 날짜';

  @override
  String get workoutRecordMemo => '메모';

  @override
  String get workoutRecordRequired => '필수 입력 항목입니다.';

  @override
  String get workoutRecordInvalidNumber => '0보다 큰 숫자를 입력해 주세요.';

  @override
  String get workoutRecordInvalidDurationFormat =>
      'mm:ss 형식으로 입력해 주세요. 예: 18:55';

  @override
  String get workoutRecordCancel => '취소';

  @override
  String get workoutRecordSave => '저장';

  @override
  String get workoutRecordDeleteDialogTitle => '이 기록을 삭제할까요?';

  @override
  String get workoutRecordDeleteDialogBody => '이 기록은 영구적으로 삭제됩니다.';

  @override
  String get workoutRecordSearchHint => '운동명 또는 메모 검색';

  @override
  String get workoutRecordSortNewest => '최신순';

  @override
  String get workoutRecordSortOldest => '오래된순';

  @override
  String get workoutRecordNoSearchResult => '검색 결과가 없습니다.';

  @override
  String get workoutRecordUseDefaultUnit => '기본 단위 사용';

  @override
  String get workoutRecordUseDefaultUnitSubtitle => '측정 항목별 기본 단위를 자동 고정합니다.';

  @override
  String get workoutRecordTemplateRowing => '로잉';

  @override
  String get workoutRecordTemplateRunning => '러닝';

  @override
  String get workoutRecordTemplateSki => '스키';

  @override
  String get workoutRecordTemplateSquat => '스쿼트';

  @override
  String get workoutRecordTemplateDeadlift => '데드리프트';

  @override
  String get workoutRecordTemplateBenchPress => '벤치프레스';

  @override
  String get workoutRecordTemplateCardioDescription => '거리, 시간, 날짜를 입력해 기록합니다.';

  @override
  String get workoutRecordTemplateStrengthDescription =>
      '중량, 횟수, 날짜를 입력해 기록합니다.';

  @override
  String get workoutRecordViewRecords => '기록 보기';

  @override
  String workoutRecordEntryTitle(Object exercise) {
    return '$exercise 기록 입력';
  }

  @override
  String workoutRecordListTitle(Object exercise) {
    return '$exercise 기록';
  }

  @override
  String get workoutRecordDistance => '거리';

  @override
  String get workoutRecordDuration => '시간 (mm:ss)';

  @override
  String get workoutRecordWeight => '중량';

  @override
  String get workoutRecordReps => '횟수';

  @override
  String workoutRecordEmptyByExercise(Object exercise) {
    return '아직 $exercise 기록이 없습니다.';
  }

  @override
  String workoutRecordDistanceAndDuration(Object distance, Object duration) {
    return '거리 $distance · 시간 $duration';
  }

  @override
  String workoutRecordStrengthWeightAndReps(Object weight, Object reps) {
    return '중량 $weight · 횟수 $reps';
  }

  @override
  String get onboardingTitle => '환영합니다';

  @override
  String get onboardingDescription => '서비스 이용을 위해 프로필을 설정해 주세요.';

  @override
  String get onboardingNameLabel => '이름';

  @override
  String get onboardingNameHint => '이름을 입력해 주세요';

  @override
  String get onboardingNameRequired => '이름을 입력해 주세요.';

  @override
  String get onboardingContinue => '계속';

  @override
  String get onboardingSaving => '저장 중...';

  @override
  String get onboardingSaveFailed => '프로필 저장에 실패했습니다. 다시 시도해 주세요.';
}
