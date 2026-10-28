# 화면 기획

## 화면 범위

| 화면 | 한국어 이름 | 핵심 목적 | Flutter 파일 |
|---|---|---|---|
| 홈 | 오늘 | 오늘 상태를 보여 주고 기록을 시작 | `lib/screens/today_screen.dart` |
| 기록 입력 | 기록하기 | 감정, 생활 태그, 선택 메모 입력 | `lib/screens/record_screen.dart` |
| 기록 보기 | 기록 | 달력에서 지난 기록 찾기 | `lib/screens/history_screen.dart` |
| 주간 회고 | 주간 리포트 | 최근 7일 기록 요약 | `lib/screens/report_screen.dart` |

요소 번호는 `E01`부터 시작하며 Nielsen 원칙 번호 `P01–P10`과 구분합니다.

## 1. 오늘

화면 목적: 앱을 열자마자 오늘의 감정 선택과 기록 상태를 확인하게 합니다.

| 요소 | UI 요소 | Flutter Widget | 의미 | 정보 전달 기준 | 원칙 | 편의성 | 상태 관리 |
|---|---|---|---|---|---|---|---|
| E01 | 앱 이름 | `Text` | 제품 식별 | `마음틈` 고정 | P04 | 현재 제품을 알 수 있음 | 없음 |
| E02 | 현재 날짜 | `Text` | 시간 맥락 | `koreanDate(DateTime.now())` | P01 | 날짜를 직접 확인할 필요 없음 | 시스템 시간 |
| E03 | 오늘 안내 | `Text` + API | 빈 화면 부담 감소 | `/bootstrap`의 prompt | P02 | 바로 시작점을 확인 | `AppData.prompts[0]` |
| E04 | 오늘 기록 요약 | `Card` | 기록 여부 표시 | 미기록·기록 완료 | P01 | 다음 행동을 바로 판단 | `date == today` |
| E05 | 시작·수정 버튼 | `FilledButton` / `OutlinedButton` | 기록 화면 진입 | 미기록이면 `기록 시작하기` | P03 | 주요 행동이 명확 | `Navigator.push` |
| E06 | 감정 선택 | `MoodSelector` + `Wrap` | 오늘의 감정 | 아이콘, 글자, 체크 | P01·P06 | 홈에서 바로 선택 | `setState`로 `int?` 갱신 |
| E07 | 생활 태그 | `SituationSelector` + `FilterChip` | 생활 맥락 | 선택 시 체크 표시 | P03 | 자주 쓰는 태그를 바로 확인 | `setState`로 `Set<String>` 갱신 |
| E08 | 선택 안내 | `Text` | 필수로 오해하지 않게 함 | `생활 태그와 한 줄 메모는 선택 사항` | P05 | 선택 부담 감소 | 없음 |
| E09 | 하단 탐색 | `NavigationBar` | 오늘·기록·리포트 이동 | 현재 항목 강조 | P04 | 주요 영역을 한 번에 이동 | `_selectedIndex` |

반응형 기준:

- 700px 미만: 안내 영역과 오늘 기록 카드를 세로로 배치합니다.
- 700px 이상: 두 열로 배치해 가로 화면의 과도한 확장을 막습니다.
- 전체 내용은 `SingleChildScrollView`에 넣어 작은 화면의 잘림을 방지합니다.

## 2. 기록하기

화면 목적: 최소 정보로 기록을 완료하고 필수와 선택 항목을 분명히 보여 줍니다.

| 요소 | UI 요소 | Flutter Widget | 의미 | 정보 전달 기준 | 원칙 | 편의성 | 상태 관리 |
|---|---|---|---|---|---|---|---|
| E10 | 뒤로 가기 | `AppBar` 기본 버튼 | 기록 취소와 복귀 | 시스템 뒤로 가기 유지 | P03 | 완료를 강요하지 않음 | `Navigator.pop` |
| E11 | 날짜 | `Text` | 기록 대상 날짜 확인 | 오늘 화면과 같은 형식 | P04 | 날짜를 다시 고르지 않아도 됨 | 현재 날짜 |
| E12 | 제목과 설명 | `Text` | 현재 작업 설명 | `오늘의 마음을 남겨볼까요?` | P02 | 한 가지 작업에 집중 | 고정 문구 |
| E13 | 감정 영역 | `MoodSelector` | 유일한 필수 정보 | 제목 옆에 `필수` | P05 | 선택 즉시 체크 표시 | `int? _selectedMoodId` |
| E14 | 감정 검증 | 조건 `Text` + `SnackBar` | 빈 제출 방지 | `감정을 하나 선택해 주세요` | P09 | 수정 방법을 알려 줌 | `_showMoodError` |
| E15 | 생활 태그 | `SituationSelector` | 선택 배경 정보 | 제목 옆에 `선택` | P03 | 전부 선택하지 않아도 됨 | `Set<String>` |
| E16 | 한 줄 메모 | `TextField` | 선택 개인 표현 | `선택`, `maxLength: 120` | P08 | 작성하지 않아도 완료 | `TextEditingController` |
| E17 | 완료 버튼 | `FilledButton.icon` | 실행 중 기록 저장 | `기록 완료`와 체크 아이콘 | P01 | 화면 아래의 큰 버튼 | `MoodEntry` 생성 후 반환 |
| E18 | 저장 범위 안내 | `Text` | 프로토타입 한계 설명 | 실행 중 임시 상태이며 서버에 저장하지 않음 | P10 | 오해 방지 | 없음 |

검증 규칙:

1. 감정이 없으면 제출하지 않고 짧은 안내를 표시합니다.
2. 감정이 있으면 태그와 메모는 비어 있어도 됩니다.
3. 완료 후 오늘 화면으로 돌아가 요약을 바로 표시합니다.
4. 같은 날짜에 다시 기록하면 실행 중인 오늘 기록을 교체하며 `PUT`·`DELETE`는 호출하지 않습니다.

## 3. 기록

화면 목적: 날짜별 기록을 찾고 달력 표시를 이해하게 합니다.

| 요소 | UI 요소 | Flutter Widget | 의미 | 정보 전달 기준 | 원칙 | 편의성 | 상태 관리 |
|---|---|---|---|---|---|---|---|
| E20 | 화면 제목 | `Text` | 기록 화면 식별 | `나의 기록` | P04 | 하단 탐색과 이름 일치 | 고정 |
| E21 | 월 제목 | `Text` | 현재 조회 월 | `2026년 10월` | P01 | 현재 범위를 바로 확인 | `_visibleMonth` |
| E22 | 월 이동 | `IconButton` | 이전·다음 월 | 좌우 화살표와 tooltip | P03 | 한 손으로 이동 | `setState`로 1개월 이동 |
| E23 | 요일 행 | `Text` | 날짜 위치 파악 | 일월화수목금토 | P02 | 날짜 구조를 바로 이해 | 고정 |
| E24 | 달력 격자 | `GridView.builder` | 날짜와 감정 표시 | 기록 날짜에 emoji 표시 | P01·P06 | 한 화면에서 월 전체 확인 | `recordsByDate` 사용 |
| E25 | 오늘 표시 | `Material` 테두리와 배경 | 현재 날짜 식별 | 일반 날짜와 명확히 구분 | P01 | 오늘을 빠르게 찾음 | `apiDate(now)` 비교 |
| E26 | 날짜 상세 | `showModalBottomSheet` | 기록 내용 확인 | 날짜, 감정, 태그, 메모 | P03 | 달력 맥락을 유지하며 닫기 가능 | 날짜 클릭 시 열기 |
| E27 | 최근 기록 | `ListView` + `InkWell` | 최근 내용 빠르게 열기 | 최대 4개 | P07 | 월을 먼저 찾지 않아도 됨 | 날짜 역순 상위 4개 |
| E28 | 기록 없음 | `EmptySection` | 빈 화면 방지 | 홈에서 기록하도록 안내 | P09 | 다음 행동 제시 | `records.isEmpty` |

반응형 기준:

- 넓은 화면: 달력과 최근 기록을 두 열로 배치합니다.
- 좁은 화면: 세로로 배치합니다.
- `GridView`는 `shrinkWrap`과 외부 스크롤을 사용해 중첩 스크롤 충돌을 막습니다.

## 4. 주간 리포트

화면 목적: 최근 7일 기록 상태를 적은 정보로 설명하고 심리 진단은 하지 않습니다.

| 요소 | UI 요소 | Flutter Widget | 의미 | 정보 전달 기준 | 원칙 | 편의성 | 상태 관리 |
|---|---|---|---|---|---|---|---|
| E30 | 화면 제목 | `Text` | 리포트 범위 식별 | `주간 리포트` | P04 | 작업이 명확 | 고정 |
| E31 | 날짜 범위 | `Text` | 집계 범위 | `weeklyReport.rangeStart - rangeEnd` | P01 | 자연월로 오해하지 않음 | json-server 고정 값 |
| E32 | 기록 일수 | `_Metric` | 예시 기록 빈도 | `weeklyReport.recordedDays / 7` | P02 | 숫자의 의미가 명확 | 모의 결과 직접 표시 |
| E33 | 주요 감정 | `_Metric` | 미리 정한 대표 감정 | 감정 라벨 + emoji | P01 | 빠르게 확인 | `topMoodLabel` |
| E34 | 감정 흐름 | `Row` + `_MoodStrip` | 최근 예시 순서 | `weeklyReport.moodFlow` | P06 | 한눈에 확인 | 고정 목록 |
| E35 | 데이터 부족 안내 | `Text` | 과도한 일반화 방지 | 3일 미만일 때 안내 | P09 | 더 많은 기록 필요 | `recordedDays < 3` |
| E36 | 주요 생활 태그 | 텍스트 행 | 감정과 대학 생활 연결 | 태그 + 횟수 | P08 | 상위 3개만 표시 | `topTags` |
| E37 | 중립 회고 | `Text` | 기록 설명, 인과 결론 없음 | `이번 주에는 ... 기록했어요` | P02·P09 | 바로 읽을 수 있음 | `summary` |
| E38 | 인과 경계 | `Text` | 심리 진단이 아님을 설명 | 특정 상황이 원인이라는 결론을 내리지 않음 | P10 | 시스템 범위 이해 | 고정 문구 |
| E39 | 빈 리포트 | `EmptySection` | `weeklyReport` 없음 | 먼저 기록하도록 안내 | P09 | 복구 가능 | `report == null` |

반응형 기준:

- 넓은 화면: 요약과 생활 회고를 두 열로 배치합니다.
- 좁은 화면: 세로로 배치합니다.
- 숫자 카드는 같은 높이와 구조를 사용해 내용 변화로 레이아웃이 흔들리지 않게 합니다.

## 전체 상태 설계

| 상태 | 발생 조건 | 화면 | 사용자 행동 |
|---|---|---|---|
| Loading | 첫 요청 또는 상태 메뉴 | 진행 표시와 `마음을 불러오고 있어요` | 기다림 |
| Success | `/bootstrap` 정상 응답 | 네 화면 표시 | 기록, 탐색 |
| Empty | `/emptyState` 빈 응답 | `아직 표시할 기록이 없어요` | 다시 시도 또는 상태 변경 |
| Error | 서버 미실행 또는 `/unreachable` 404 | 오류 설명과 재시도 버튼 | 서버 실행 후 재시도 |
| Selected | 감정 또는 태그 클릭 | 테두리, 체크, 글자 굵기 변화 | 계속 선택 |
| Completed | 기록 완료 | 오늘 화면에 감정 요약 표시 | 수정 또는 기록 보기 |

## Widget 대응

| 요구 사항 | Widget / API |
|---|---|
| 화면 이동 | `Navigator.push` |
| 주요 영역 전환 | `NavigationBar` + `IndexedStack` |
| 날짜 상세 | `showModalBottomSheet` |
| 첫 GET 상태 | `FutureBuilder<AppData>` |
| 간단한 상태 변경 | `StatefulWidget` + `setState` |
| 반응형 | `LayoutBuilder`, `ConstrainedBox`, `Expanded`, `Wrap` |
| 네트워크 | `http.get` |
| 로딩 | `CircularProgressIndicator` |
| 오류·빈 상태 | 조건부 렌더링 + `OutlinedButton` / `FilledButton` |
| 목록 | `SingleChildScrollView`, `ListView`, `GridView.builder` |

## 디자인 요약

- 배경: `#F8F7F3`
- 기본 글자: `#292A2D`
- 보조 글자: `#85858B`
- 포인트 색: `#A79BC8`
- 보조 색: `#A8B8A0`
- 카드: 흰색, 18px 라운드, `#E8E5DE` 테두리
- 화면 좌우 여백: 22px
- 주요 버튼 높이: 52px
- 본문 크기: 14–16px
- 복잡한 애니메이션, 유리 효과, 장식용 그라데이션은 사용하지 않음
