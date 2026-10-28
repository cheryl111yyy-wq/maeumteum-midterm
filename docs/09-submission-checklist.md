# 제출 체크리스트

## 기획 40점

- [x] DailyBean 竞品选择理由。
- [x] 竞品功能与 Nielsen 原则分析。
- [x] 官方 Google Play 评分与 1–5 星分布数据。
- [x] 3 条真实评论短引文，保留日期与星级并隐藏姓名。
- [x] R1 已替换为用户提供的 2024-06-04 三星评论，并标注为“사용자 제공 리뷰 캡처”。
- [ ] 保存官方商店页面截图作为附件证据。
- [x] App Summary。
- [x] 假设 Persona。
- [x] 六阶段用户旅程与情绪变化。
- [x] 사용 기기、AI 활용 기회、원칙、필요 데이터四行。
- [x] 六视角鱼骨图。
- [x] 5 Whys 与根因假设。
- [x] 竞品发现到 V2 改进的对应表。
- [x] 四页屏幕规划。
- [x] E01 起的元素编号、Widget、业务含义、信息传递规则。
- [x] P01–P10 原则及理由。
- [x] 편의성 포인트。
- [x] 디자인 가이드。
- [x] 상태관리 포인트。

## 셀프 논증 20점

- [x] 第 8 页两个正式设计争议，以及两个标注为 `[탐색]` 的非主线记录。
- [x] 主张、AI 反方、自主反方、再论证。
- [x] 维持、修改、放弃三类结论。
- [x] 原则与证据引用。
- [x] 前后设计变化说明。
- [x] Prompt Log。
- [x] 代码中的 P01/P03/P05/P08/P09 注释。
- [x] 第 8 页使用真实 Flutter Before/After 截图。

## Flutter UI 25점

- [x] 四个页面可打开。
- [x] PPT 中已加入真实 Flutter Web 截图（오늘、기록하기、주간 리포트）。
- [x] 第 8 页 Before/After 均使用真实 Flutter Web 截图；Before 明确标注为 폐기안。
- [x] `screenshots/` 已包含 실제 화면과 Loading、Error、Empty、와宽屏图像。
- [x] 首页进入记录页。
- [x] 底部导航切换。
- [x] 心情与标签选中反馈。
- [x] 完成状态。
- [x] 历史日期 BottomSheet。
- [x] 初次 GET 使用 `FutureBuilder<AppData>`。
- [x] 表单与导航交互使用 `setState()`。
- [x] 本地 `json-server`。
- [x] `http.get()`。
- [x] Loading。
- [x] Error。
- [x] Empty。
- [x] Success。
- [x] 自适应布局。
- [x] 无登录、支付、POST、PUT、DELETE。
- [x] 明确不声称永久保存。

## 감점 방지 확인

- [x] 실제 로그인·회원가입·결제 없음.
- [x] `POST`·`PUT`·`DELETE` 호출 없음. Flutter 앱은 `http.get()`만 사용.
- [x] 영구 저장 패키지와 서버 쓰기 없음.
- [x] Provider·Riverpod·Bloc 등 복잡한 상태관리 패키지 없음. `FutureBuilder`와 `setState()`만 사용.
- [x] 추천·예측·통계 알고리즘 없음. 주간 리포트는 `mock_server/db.json`의 `weeklyReport` 모의 결과를 그대로 표시.
- [x] 최종 App에는 디자인 가이드의 오늘·기록하기·기록·리포트 화면과 필수 UI 상태만 포함.
- [x] 외부 유료 API 없음. 로컬 `json-server`와 기본 `http` 패키지만 사용.
- [x] 실제 개인정보 없음. 모든 사용자·기록 데이터는 명시된 예시 데이터.

## GitHub와 문서

- [x] Flutter 源码。
- [x] `mock_server/db.json`。
- [x] README。
- [x] 设计指南。
- [x] 原则卡片。
- [x] Prompt Log。
- [x] 셀프 논증。
- [x] 자기평가。
- [ ] 补入 DailyBean 证据截图。
- [ ] 上传 GitHub 并确认公开或教师可访问。

## 발표와 제출

- [x] 正文 12 页 PPT，并在正文中补入 `09 Flutter 기술` 页。
- [x] 附录 B1–B5。
- [x] `09 · Flutter 기술을 활용한 기능 설명` 기술 페이지와 Widget/API 설명.
- [x] 约 6 分钟发表稿。
- [x] 2 分钟问答稿。
- [x] 把真实 Flutter Web 截图放入第 4 页及附录。
- [ ] 如需额外证据，再补 R1 리뷰 캡처와 DailyBean 공식 스토어 스크린샷.
- [x] 录制约 1 分钟演示视频。
- [x] 检查视频链接在无登录状态下可访问。
- [x] README에 YouTube 데모 영상 링크 추가: <https://youtu.be/Z1yQUaX3Y0E>
- [ ] 导出 PPT 为 PDF。
- [ ] 截止前上传 LMS。

