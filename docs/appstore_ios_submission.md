# iOS(App Store) 심사용 제출 문서

이 문서는 **iOS만 업로드**하는 기준으로, App Store 심사 제출에 필요한 텍스트/스크린샷 준비 항목을 정리한 문서입니다.

## 1) iOS 전용 제출 전제

- iPad 스크린샷 요구를 피하려면 iOS 타깃을 iPhone 전용으로 설정
- 확인 파일
  - `ios/Runner.xcodeproj/project.pbxproj`
  - `ios/Runner/Info.plist`
- 체크 포인트
  - `TARGETED_DEVICE_FAMILY = "1"` (iPhone only)
  - `UISupportedInterfaceOrientations~ipad` 항목 제거 또는 iPad 미지원 설정과 일치

## 2) App Store 등록 텍스트 (한국어)

### 앱 이름

- `XON 트레이닝`

### 부제 (30자 이내)

- `운동 프로그램과 기록 관리`

### 키워드 (100자 이내, 쉼표 구분)

- `운동,트레이닝,운동기록,피트니스,홈트,근력운동,유산소,운동루틴,코칭,커뮤니티,헬스`

### 설명

```text
XON 트레이닝은 운동 프로그램 확인, 날짜별 세션 체크, 커뮤니티 소통, 운동 기록 관리를 한 곳에서 할 수 있는 트레이닝 앱입니다.

주요 기능
• 간편 로그인 (Google / Apple)
• 프로그램 목록 및 상세 정보 확인
• 날짜별 운동 세션 확인
• 커뮤니티 게시글 작성, 이미지 첨부, 좋아요/댓글
• 운동 기록 입력 및 조회 (유산소/근력)
• 프로필/설정, 약관/개인정보처리방침, 계정 삭제 지원

이런 분께 추천해요
• 정해진 프로그램으로 꾸준히 운동하고 싶은 분
• 운동 기록을 남기고 성과를 관리하고 싶은 분
• 커뮤니티에서 동기부여를 받고 싶은 분
```

## 3) 앱 미리보기(영상) 구성안 (15~25초)

- 0~3초: 로그인 화면 + 문구 `간편 로그인으로 빠르게 시작`
- 3~7초: 홈 프로그램 목록 + 문구 `내 프로그램을 한눈에 확인`
- 7~12초: 프로그램 상세(날짜별 세션) + 문구 `날짜별 운동 세션 확인`
- 12~17초: 커뮤니티 피드/상세 + 문구 `커뮤니티에서 함께 성장`
- 17~22초: 운동 기록 화면 + 문구 `운동 기록을 꾸준히 관리`
- 22~25초: 프로필/설정 + 문구 `프로필과 계정 설정까지 간편하게`

## 4) 최소 스크린샷 5장 (촬영 가이드)

> 권장: 한 기기에서 모두 촬영 (예: iPhone 15 Pro Max)

### 1. 로그인 화면

- 화면: 로그인 뷰
- 반드시 보이게: Google/Apple 로그인 버튼
- 캡션 예시: `간편 로그인으로 빠르게 시작`
- 파일명: `01_login.png`

### 2. 홈 프로그램 목록

- 화면: 홈 뷰(프로그램 카드 리스트)
- 반드시 보이게: 썸네일 + 기간/난이도/주간 횟수
- 캡션 예시: `내 운동 프로그램을 한눈에 확인`
- 파일명: `02_home_programs.png`

### 3. 프로그램 상세(날짜별 세션)

- 화면: 프로그램 상세 뷰
- 반드시 보이게: 날짜 선택 UI + 세션 내용
- 캡션 예시: `날짜별 운동 세션을 체계적으로 확인`
- 파일명: `03_program_detail.png`

### 4. 커뮤니티 피드

- 화면: 커뮤니티 목록
- 반드시 보이게: 게시글 카드, 좋아요/댓글, 작성 버튼
- 캡션 예시: `커뮤니티에서 기록과 동기부여 공유`
- 파일명: `04_community.png`

### 5. 운동 기록

- 화면: 운동 기록 템플릿 또는 기록 입력 폼
- 반드시 보이게: 유산소/근력 기록 구조
- 캡션 예시: `운동 기록을 꾸준히 관리`
- 파일명: `05_workout_record.png`

## 5) 스크린샷 촬영 방법 (시뮬레이터)

### 기본 방법

- 시뮬레이터 실행: Xcode > Open Developer Tool > Simulator
- 앱 실행: `fvm flutter run -d ios`
- 캡처: `Cmd + S` 또는 Simulator 메뉴 `File > Save Screen Shot`

### CLI 방법 (선택)

```bash
xcrun simctl io booted screenshot "01_login.png"
```

## 6) 촬영 품질 체크리스트

- 로딩 스피너/스낵바 노출 순간 피하기
- 실명/개인 이메일 대신 테스트 계정 사용
- 화면별 데이터가 비어 있지 않게 준비
  - 커뮤니티: 게시글 2개 이상
  - 운동기록: 샘플 기록 1~2개 이상
- 파일명 순서 통일 (`01`~`05`)

## 7) 최종 업로드 전 확인

- App Store Connect에 iPad 스크린샷 요구가 없는지 확인
- 부제/키워드/설명 최종 맞춤법 확인
- 개인정보처리방침/이용약관 URL 동작 확인
- 심사용 테스트 계정 로그인 가능 상태 확인

## 8) App Review Notes (UGC 심사 대응용)

아래 문구를 App Store Connect의 **App Review Information > Notes**에 그대로 붙여 넣어 제출합니다.

```text
This app includes user-generated community content and moderation tools required by App Review Guideline 1.2.

Implemented moderation features:
1) Users can report posts and comments with reason categories (spam, hate/discrimination, sexual content, harassment/threats, other).
2) Users can hide posts from their own feed.
3) Users can block authors, and blocked users' posts/comments are filtered out.
4) Basic restricted-term filtering is applied before posting content.

Support contact for moderation inquiries:
vividxxxxx@gmail.com

Guideline references:
- 1.2 User-Generated Content
- 1.5 Developer Information
```

제출 전 점검:

- 심사용 계정으로 커뮤니티 피드 진입 가능
- 게시글 상세에서 신고/숨김/작성자 차단 메뉴가 노출됨
- 댓글 메뉴에서 신고 기능이 노출됨
- 설정 화면에 `커뮤니티 신고 문의` 항목과 이메일이 표시됨
