# 마음틈 MoodPause

마음틈은 바쁜 대학생이 감정 하나로 기록을 시작하고, 생활 태그와 메모는 필요할 때만 추가한 뒤 최근 7일을 중립적으로 돌아볼 수 있도록 만든 Flutter UI 프로토타입입니다.

중간 프로젝트의 핵심은 `기록은 가볍게, 필수와 선택의 경계는 분명하게`입니다. DailyBean 리뷰는 제품을 개선할 단서로 사용했으며, 감정 선택 단계의 망설임은 실제 사용자 테스트가 필요한 설계 가설로 구분했습니다.

## 데모 영상

1분 데모 시연 영상: <https://youtu.be/Z1yQUaX3Y0E>

영상에는 오늘 기록, 기록 완료, 달력, 최근 7일 리포트, Loading·Error·Empty 상태와 넓은 화면 대응이 포함됩니다.

## 앱 소개

- 오늘 화면: 감정 선택, 생활 태그, 오늘 기록 상태, 기록 화면 시작
- 기록하기 화면: 필수 감정 1개, 선택 생활 태그, 선택 120자 메모
- 기록 화면: 월 달력, 월 이동, 기록 날짜의 감정 표시, 날짜 상세 보기
- 주간 리포트: `json-server`의 `weeklyReport` 모의 결과와 오늘 새로 남긴 기록 표시
- 데이터: `http.get()`으로 로컬 `json-server`의 데이터를 읽음
- 상태 처리: 첫 GET은 `FutureBuilder<AppData>`, waiting·error·empty·success 처리
- 반응형 UI: `LayoutBuilder`, `Wrap`, `ConstrainedBox`, 스크롤 영역 사용
- 상태 관리: 비동기 GET은 `FutureBuilder`, 선택과 이동은 `StatefulWidget`과 `setState()`

## 구현하지 않은 기능

- 실제 로그인, 회원가입, 결제, 광고, 클라우드 동기화
- `POST`, `PUT`, `DELETE` 요청과 영구 저장
- Provider, Riverpod, Bloc 같은 복잡한 상태 관리
- 심리 진단, 감정 원인 추론, 추천 알고리즘

새로 만든 기록은 현재 실행 중인 앱 메모리에만 남습니다. 앱을 새로고침하거나 종료하면 사라집니다.

## 기술 스택

- Flutter / Dart
- Material 3
- `FutureBuilder<AppData>`
- `http` package
- 로컬 `json-server`

## 실행 방법

### 1. Mock 서버 실행

```bash
cd mock_server
npm install
npm start
```

기본 주소는 `http://localhost:3000`입니다.

3000 포트를 사용할 수 없다면 다음 명령을 사용합니다.

```bash
npx json-server@0.17.4 db.json --port 3100
```

### 2. Flutter 실행

```bash
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

Android 에뮬레이터에서 컴퓨터의 로컬 서버에 접속할 때:

```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

iOS 시뮬레이터:

```bash
flutter run -d ios --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

Mock 서버를 3100 포트에서 실행했다면 `API_BASE_URL`의 포트도 함께 바꿉니다.

## API

- 정상 데이터: `GET /bootstrap`
- 빈 상태: `GET /emptyState`
- 오류 상태: `GET /unreachable`

`mock_server/db.json`의 기록에는 `sample-` 접두사와 `"isSample": true`가 설정되어 있습니다. 이 데이터는 UI 시연용이며 실제 사용자 조사를 의미하지 않습니다.

## 리뷰 근거

- R1: `★3 · 2024-06-04 · 사용자 제공 리뷰 캡처`. 앱이 자주 열리지 않고, 감정 하나를 기록하려 해도 선택할 정보가 너무 많다는 내용을 한국어로 번역해 인용했습니다.
- R2·R3: 2026-10-28에 확인한 Google Play 공개 리뷰입니다.
- R1은 개선 방향을 뒷받침하는 한 사용자의 경험입니다. 전체 DailyBean 사용자의 공통 문제로 확대하지 않습니다.

## 상태 시연

앱 오른쪽 위의 점 세 개 메뉴에서 다음 상태를 선택할 수 있습니다.

- `정상 데이터`: `/bootstrap`
- `로딩 상태`: 1.4초 지연 후 `/bootstrap`
- `빈 상태`: `/emptyState`
- `오류 상태`: 존재하지 않는 `/unreachable`

직접 화면을 열 때는 다음 경로를 사용할 수 있습니다.

```text
/?view=today
/?view=record
/?view=history
/?view=report
/?view=loading-preview
/?view=empty
/?view=error
```

`screenshots/record_before.png`는 PPT 8페이지의 비교를 위해 만든 폐기안입니다. 최종 앱의 실행 경로에는 포함하지 않았습니다.

## 프로젝트 구조

```text
lib/
  main.dart
  shell.dart
  models/
  screens/
  services/
  theme/
  utils/
  widgets/
mock_server/
  db.json
  package.json
docs/
screenshots/
test/
  goldens/
```

## 테스트

```bash
flutter analyze
flutter test
flutter build web --release --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

## 스크린샷

실제 Flutter Web 실행 화면은 `screenshots/`에 있습니다.

- `today.png`
- `record.png`
- `record_after.png`
- `record_before.png`
- `history.png`
- `report.png`
- `loading.png`
- `error.png`
- `empty.png`
- `wide.png`

## 중간 프로젝트 문서

`docs/`에는 경쟁 앱 분석, 기획, 화면 설계, 디자인 가이드, Nielsen 원칙 카드, Prompt Log, 셀프 논증, 자기평가와 제출 체크리스트가 있습니다.
