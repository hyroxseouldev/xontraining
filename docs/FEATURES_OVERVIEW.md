# 기능 문서 (프로젝트 분석 기반)

## 1) 공지사항

### 기능 요약
- 사용자에게 테넌트별 공지(새소식) 목록을 보여주고, 상세 내용을 확인할 수 있습니다.
- 목록은 페이지네이션(무한 스크롤)과 새로고침을 지원합니다.

### 사용자 플로우
- 홈 화면에서 공지 아이콘 클릭 -> `새소식` 진입
- 공지 카드 클릭 -> 상세 화면 이동
- 스크롤 하단 근처 도달 시 추가 로딩
- 실패 시 재시도 버튼 제공

### 동작 규칙
- `is_published = true` 공지만 노출
- `tenant_id` 기준으로 데이터 분리
- 상세 화면은 `initialNotice`가 있으면 로딩/에러 시에도 임시 표시 가능

### 데이터 소스
- 테이블: `notices`
- 조회 컬럼: `id, title, content_html, thumbnail_url, created_at`

### 관련 코드
- 라우트: `lib/src/core/router/app_router.dart`
- 목록 UI: `lib/src/feature/notice/presentation/view/notice_view.dart`
- 상세 UI: `lib/src/feature/notice/presentation/view/notice_detail_view.dart`
- 상태/페이징: `lib/src/feature/notice/presentation/provider/notice_provider.dart`
- 데이터 조회: `lib/src/feature/notice/data/datasource/notice_data_source.dart`

---

## 2) 프로그램에서 운동 확인하기

### 기능 요약
- 홈에서 프로그램 목록을 확인하고, 프로그램 상세에서 날짜별 세션 운동 내용을 조회합니다.

### 사용자 플로우
- 홈 진입 -> 프로그램 리스트 확인
- 프로그램 선택 -> 상세 진입
- 주간 캘린더에서 날짜 선택 -> 해당 날짜 세션 표시
- 코치 버튼 클릭 -> 코치 정보 화면 이동

### 동작 규칙
- 상세 진입 시 접근 권한 검사
- 권한 없으면 구매/활성화 필요 안내
- 권한 있으면 `sessions`를 날짜순으로 표시
- 세션 본문은 HTML 렌더링, 링크는 외부 앱 실행

### 접근 권한 기준
- `program_entitlements` 활성 권한 확인
- 또는 `user_program_states.active_program_id` 일치 시 접근 허용

### 데이터 소스
- 프로그램: `programs`
- 접근권한: `program_entitlements`, `user_program_states`
- 세션: `sessions`
- 코치정보: `tenant_branding`

### 관련 코드
- 홈 목록: `lib/src/feature/home/presentation/view/home_view.dart`
- 프로그램 카드: `lib/src/feature/home/presentation/widget/program_list_item.dart`
- 상세 화면: `lib/src/feature/home/presentation/view/program_detail_view.dart`
- 권한/세션 로딩: `lib/src/feature/home/presentation/provider/program_detail_provider.dart`
- 데이터 조회: `lib/src/feature/home/data/datasource/home_data_source.dart`

---

## 3) 숙제 기록하기 (현재 구현 기준: 운동 기록)

### 기능 요약
- 운동 종목별로 개인 수행 기록(거리/시간 또는 중량/횟수)을 입력하고 저장합니다.

### 사용자 플로우
- 프로필 -> `내 운동 능력 기록` 진입
- 운동 종목 선택(로잉/러닝/스키/스쿼트/데드리프트/벤치프레스)
- 프리셋 선택 후 값 입력
- 날짜 선택 후 저장
- 우측 상단 `기록 보기`에서 해당 종목 기록 목록 확인

### 동작 규칙
- 유산소(`time`): 거리(프리셋), 시간(mm:ss), 날짜 저장
- 근력(`weight`): 중량, 횟수(프리셋), 날짜 저장
- 저장 성공 시 목록 캐시 무효화 후 새로고침
- 사용자 미인증 상태에서는 저장/조회 불가

### 데이터 소스
- 종목: `workout_exercises`
- 프리셋: `workout_exercise_presets`
- 개인기록: `user_workout_records_v2`

### 관련 코드
- 기록 홈: `lib/src/feature/profile/presentation/view/workout_record_view.dart`
- 기록 입력: `lib/src/feature/profile/presentation/view/rowing_record_entry_view.dart`
- 기록 목록: `lib/src/feature/profile/presentation/view/rowing_record_list_view.dart`
- 상태/CRUD: `lib/src/feature/profile/presentation/provider/workout_record_provider.dart`
- 데이터 조회/저장: `lib/src/feature/profile/data/datasource/workout_record_data_source.dart`

---

## 4) 본인 TT 기록하기 (현재 구현 기준: 로잉 기록)

### 기능 요약
- TT 전용 명칭은 코드상 분리되어 있지 않고, 현재는 `rowing` 종목 기록으로 처리됩니다.
- 개인 로잉 기록(거리 + 시간)을 입력/조회할 수 있습니다.

### 사용자 플로우
- 운동 기록 화면에서 `로잉` 선택
- 프리셋 거리 선택 후 시간(mm:ss) 입력
- 저장 후 로잉 기록 리스트에서 히스토리 확인

### 동작 규칙
- `exercise_key = rowing` 기준 필터링
- 기록 리스트는 최신 날짜 우선 정렬 표시
- 표시 형식: `거리 {distance} · 시간 {duration}`

### 관련 코드
- 종목 분기: `lib/src/core/router/app_router.dart`
- 입력 화면: `lib/src/feature/profile/presentation/view/rowing_record_entry_view.dart`
- 리스트 화면: `lib/src/feature/profile/presentation/view/rowing_record_list_view.dart`
- 엔티티: `lib/src/feature/profile/infra/entity/workout_record_entity.dart`

---

## 5) 프로필 규칙 (현재 구현 기준: 약관/개인정보 + 계정 정책)

### 기능 요약
- 설정 화면에서 이용약관/개인정보처리방침을 확인할 수 있습니다.
- 계정 삭제 정책(멤버만 삭제 가능)도 설정에서 관리됩니다.

### 사용자 플로우
- 프로필 -> 설정 진입
- `이용약관` 또는 `개인정보처리방침` 클릭
- 문서 버전/개정일/본문 확인
- 계정 삭제 선택 시 확인 다이얼로그 후 삭제 실행

### 동작 규칙
- 문서는 `legal_documents`에서 `is_published = true` 최신 버전 1건 조회
- 현재 locale 우선 조회, 실패 시 한국어(`ko`) 폴백
- 계정 삭제는 `member` 권한 계정만 가능하도록 제한

### 데이터 소스
- 법적 문서: `legal_documents`
- 권한 판단(삭제 가능 여부): 프로필 테넌트 역할 값

### 관련 코드
- 설정 화면: `lib/src/feature/profile/presentation/view/settings_view.dart`
- 약관/개인정보 화면: `lib/src/feature/profile/presentation/view/legal_document_view.dart`
- 문서 로딩 Provider: `lib/src/feature/profile/presentation/provider/legal_document_provider.dart`
- 문서 조회: `lib/src/feature/profile/data/datasource/legal_document_data_source.dart`

---

## 용어 매핑 메모
- `숙제 기록하기`, `TT 기록하기`라는 표현은 코드 내 문자열로 직접 존재하지 않습니다.
- 현재 앱 구조상 가장 가까운 기능은 `내 운동 능력 기록`(workout record)과 `rowing 기록`입니다.
