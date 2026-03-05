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
  String get loginLoading => '로그인 중...';

  @override
  String get loginCanceled => '로그인이 취소되었습니다.';

  @override
  String get loginConfigError => 'Google 로그인 설정이 올바르지 않습니다.';

  @override
  String get loginNetworkError => '네트워크 오류가 발생했습니다. 연결을 확인해 주세요.';

  @override
  String get loginFailed => 'Google 로그인에 실패했습니다. 다시 시도해 주세요.';

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
  String homeProgramDetailIdLabel(Object id) {
    return '프로그램 ID: $id';
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
  String get profileWorkoutRecordComingSoon => '내 운동 능력 기록 화면 뼈대가 준비되었습니다.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsDescription => '설정 화면 뼈대가 준비되었습니다.';

  @override
  String get settingsSignOut => '로그아웃';

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
