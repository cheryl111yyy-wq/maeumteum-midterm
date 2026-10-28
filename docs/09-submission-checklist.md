# 제출 체크리스트

## 기획 40점

- [x] DailyBean 경쟁 앱 선택 이유
- [x] 경쟁 앱 기능과 Nielsen 원칙 분석
- [x] Google Play 공개 평점과 1–5점 분포
- [x] 날짜와 별점을 유지한 실제 리뷰 3개, 작성자 이름은 비공개
- [x] R1을 2024-06-04 3점 리뷰로 교체하고 `사용자 제공 리뷰 캡처`로 표시
- [ ] 공식 스토어 화면 캡처를 증거 자료로 저장
- [x] App Summary
- [x] 가설 Persona
- [x] 6단계 사용자 여정과 감정 변화
- [x] 사용 기기, AI 활용 기회, 원칙, 필요한 데이터
- [x] 여섯 관점 피시본
- [x] 5 Whys와 근본 원인 가설
- [x] 경쟁 앱 분석에서 V2 개선으로 이어지는 대응표
- [x] 네 화면 기획
- [x] E01부터 시작하는 요소 번호, Widget, 의미, 정보 전달 기준
- [x] P01–P10 원칙과 적용 이유
- [x] 편의성 포인트
- [x] 디자인 가이드
- [x] 상태 관리 포인트

## 셀프 논증 20점

- [x] PPT 8페이지의 본문 쟁점 2개와 `[탐색]` 기록 2개
- [x] 내 주장, AI 반론, 스스로 찾은 반론, 재반론
- [x] 유지, 수정, 폐기 결론
- [x] 원칙과 근거 연결
- [x] 전·후 디자인 변화
- [x] Prompt Log
- [x] 코드의 P01·P03·P05·P08·P09 주석
- [x] PPT 8페이지의 실제 Flutter Before/After 캡처

## Flutter UI 25점

- [x] 네 화면 실행
- [x] 실제 Flutter Web 화면을 PPT에 반영
- [x] 8페이지 Before/After에 실제 Flutter Web 캡처 사용
- [x] `screenshots/`에 정상, Loading, Error, Empty, 넓은 화면 이미지 포함
- [x] 오늘 화면에서 기록 화면으로 이동
- [x] 하단 내비게이션 전환
- [x] 감정과 태그 선택 피드백
- [x] 완료 상태 표시
- [x] 기록 날짜 BottomSheet
- [x] 첫 GET에 `FutureBuilder<AppData>` 사용
- [x] 폼과 내비게이션 상태에 `setState()` 사용
- [x] 로컬 `json-server`
- [x] `http.get()`
- [x] Loading
- [x] Error
- [x] Empty
- [x] Success
- [x] 반응형 레이아웃
- [x] 로그인, 결제, `POST`, `PUT`, `DELETE` 없음
- [x] 영구 저장을 제공한다고 주장하지 않음

## 감점 방지 확인

- [x] 실제 로그인, 회원가입, 결제 없음
- [x] `POST`·`PUT`·`DELETE` 호출 없음. 앱은 `http.get()`만 사용
- [x] 영구 저장 패키지와 서버 쓰기 없음
- [x] Provider, Riverpod, Bloc 같은 복잡한 상태 관리 없음. `FutureBuilder`와 `setState()`만 사용
- [x] 추천, 예측, 통계 알고리즘 없음. 주간 요약은 `mock_server/db.json`의 `weeklyReport` 모의 결과
- [x] 최종 앱에는 디자인 가이드의 네 화면과 필수 UI 상태만 포함
- [x] 외부 유료 API 없음. 로컬 `json-server`와 기본 `http` 패키지만 사용
- [x] 실제 개인정보 없음. 모든 사용자와 기록 데이터는 예시 데이터

## GitHub와 문서

- [x] Flutter 소스 코드
- [x] `mock_server/db.json`
- [x] `README.md`의 앱 소개와 실행 방법
- [x] 디자인 가이드
- [x] 원칙 카드
- [x] Prompt Log
- [x] 셀프 논증
- [x] 자기평가
- [ ] DailyBean 공식 스토어 캡처 추가
- [x] GitHub 업로드와 공개 접근 확인

## 발표와 제출

- [x] 본문 12장 PPT와 `09 Flutter 기술` 설명
- [x] 부록 B1–B5
- [x] Widget과 API를 포함한 Flutter 기술 설명
- [x] 약 6분 발표 스크립트
- [x] 2분 질의응답 답변
- [x] 실제 Flutter Web 캡처를 PPT 4페이지와 부록에 반영
- [ ] R1 리뷰 원본과 DailyBean 공식 스토어 캡처 추가
- [x] 약 1분 데모 영상
- [x] 로그인 없이 영상 링크 접근 확인
- [x] README에 YouTube 데모 영상 링크 추가: <https://youtu.be/Z1yQUaX3Y0E>
- [ ] PPT를 PDF로 내보내기
- [ ] 마감 전 LMS에 제출
