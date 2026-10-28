# 마음틈 MoodPause

대학생이 감정 하나로 기록을 시작하고, 생활 태그와 메모는 필요할 때만 추가한 뒤 최근 7일을 중립적으로 돌아보는 Flutter UI 프로토타입입니다.

期中项目定位：围绕“记录要轻，边界要清楚”这一条主线，明确一次记录的最小成功标准。DailyBean 리뷰는 제품 단서로 사용하며, 감정 선택 단계의 망설임은 실제 사용자 테스트가 필요한 설계 가설로 구분합니다.

## 功能范围

- 오늘 화면：心情选择、生活标签、今日记录状态、进入记录页。
- 기록하기 화면：必选心情、可选生活标签、可选 120 字短备注。
- 기록 화면：月历、可切换月份、有记录日期显示心情、点击日期查看详情。
- 주간 리포트：直接读取 json-server 中预先定义的 `weeklyReport` 模拟结果，不在 Flutter 内执行统计、推荐或预测。
- 数据读取：通过 `http.get()` 读取本地 `json-server`；本项目只使用 GET。
- UI 状态：初次 GET 使用 `FutureBuilder<AppData>`，处理 waiting、error、empty、success。
- 自适应：手机、较宽网页和横屏使用 `LayoutBuilder`、`Wrap`、`ConstrainedBox` 和滚动容器。
- 状态管理：初次 GET 用 `FutureBuilder`，表单与导航交互用 `StatefulWidget` + `setState()`。

## 明确不实现

- 不实现真实注册、登录、支付、社交或云端同步。
- 不实现 POST、PUT、DELETE 或永久保存。
- 不实现 Provider、Riverpod、Bloc 等复杂状态管理。
- 不提供心理诊断，也不把记录之间的关系说成因果关系。
- 当前新建记录只保存在本次运行的内存中，关闭应用后会消失。

## 技术栈

- Flutter / Dart
- Material 3
- `FutureBuilder<AppData>`
- `http` package
- `json-server` 本地模拟接口

## 快速运行

### 1. 启动模拟服务器

```bash
cd mock_server
npm install
npm start
```

默认地址为 `http://localhost:3000`。

如果 3000 端口已被占用：

```bash
npx json-server@0.17.4 db.json --port 3100
```

### 2. 启动 Flutter

```bash
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

Android 模拟器访问电脑本机时，把地址改为：

```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

iOS 模拟器：

```bash
flutter run -d ios --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

如果模拟服务器运行在 3100 端口，请同步替换端口。

## API

正常数据：

```text
GET /bootstrap
```

空数据：

```text
GET /emptyState
```

错误状态演示：

```text
GET /unreachable
```

`mock_server/db.json` 中的记录名称带 `sample-` 前缀并设置 `"isSample": true`，界面和报告页会显示“예시”。这些数据只用于演示 UI，不代表真实用户研究。

## 리뷰 근거

- R1: `★3 · 2024-06-04 · 사용자 제공 리뷰 캡처`. 앱이 자주 열리지 않고, 기분 하나를 기록하려 해도 선택할 정보가 너무 많다는 경험을 번역해 인용했습니다.
- R2·R3: 2026-10-28에 확인한 Google Play 공개 리뷰입니다.
- R1은 개선 방향을 뒷받침하는 한 사용자의 경험이며, 전체 DailyBean 사용자의 공통 문제로 확대하지 않습니다.

## 状态演示

运行 Debug 版本后，点击右上角三点菜单：

- `정상 데이터`：读取 `/bootstrap`。
- `로딩 상태`：延迟 1.4 秒后读取，便于截图。
- `빈 상태`：读取 `/emptyState`。
- `오류 상태`：请求不存在的 `/unreachable`。

截图或课堂演示时也可以直接打开对应页面：

```text
/?view=today
/?view=record
/?view=history
/?view=report
/?view=loading-preview
/?view=empty
/?view=error
```

第 8 页 셀프 논증中的 Before 图片是制作阶段从 Flutter Web 截取并保存到 `screenshots/record_before.png` 的发表比较素材，不属于最终 App 的运行路由。最终 App 只保留设计指南中的四个正常页面和所需 UI 状态。

## 目录

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
test/
  goldens/
```

## 测试

```bash
flutter analyze
flutter test
```

从实际 Flutter Web 截取的最新界面图位于 `screenshots/`：

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

如需重新生成确定性组件测试截图：

```bash
flutter test --update-goldens test/render_goldens_test.dart
```

截图位于 `test/goldens/`。

## 期中范围说明

本仓库中的 `docs/` 已包含竞品分析、改进矩阵、Persona、用户旅程、鱼骨图、5 Whys、屏幕规划、设计指南、Nielsen 原则卡片、Prompt Log、自我论证、自评与提交检查表。DailyBean 的 Google Play 评分分布和三条真实评论短引文已记录；正式提交前如老师要求，可再保存官方商店页面截图作为附加证据。Flutter 界面截图已经生成并放入 `screenshots/`，无需重新截取。

