# 截图需求清单

## 当前状态

Flutter UI 的真实截图已经生成，并已用于 PPT：

- `screenshots/today.png`
- `screenshots/record.png`
- `screenshots/record_after.png`
- `screenshots/record_before.png`：第 8 页发表比较用 Before 证据图，不是最终 App 的运行页面。
- `screenshots/history.png`
- `screenshots/report.png`
- `screenshots/loading.png`
- `screenshots/error.png`
- `screenshots/empty.png`
- `screenshots/wide.png`

这些图片通过运行 Flutter Web 后截取，不是 PowerPoint 手绘界面，也不是组件测试 golden。提交项目时不需要你再补做 Flutter 页面截图。

## 可选补充的竞品证据

只有当老师额外要求原始商店截图作为附件时，才需要补以下图片：

1. DailyBean 官方 Google Play 详情页整屏截图。
2. Google Play 评分、评价数量与 1–5 星分布截图。
3. DailyBean 官方 App Store 详情页及评分区域截图。
4. R1 的原始评论截图：`★3 · 2024-06-04`，内容为“앱이 자주 열리지 않고, 기록할 정보가 너무 많다”는 취지.
5. R2、R3 的 Google Play 评论原文位置截图，保留日期与星级并隐藏用户名。
6. DailyBean 主要界面截图 2–3 张，用于附加对照；不能替代本项目的 Flutter 截图。

PPT 中已经使用可核验的 Google Play 评分数据和三条评论短引文。R1 来源标注为“사용자 제공 리뷰 캡처”，正式提交时最好将对应截图放入 `docs/evidence/`；商店截图仍属于补充证据。

## 项目内已包含的补充截图

- Loading、Error、Empty 状态已包含。
- 手机界面与 Web 宽屏的自适应对比已包含。
- 如需提交 GitHub，可另行截取仓库首页和 README 渲染结果。

## 命名的建议

```text
01_dailybean_google_play.png
02_dailybean_google_rating.png
03_dailybean_google_distribution.png
04_dailybean_app_store.png
05_dailybean_app_rating.png
06_review_positive_01.png
07_review_positive_02.png
08_review_neutral_01.png
09_review_neutral_02.png
10_review_negative_01.png
11_review_negative_02.png
12_dailybean_ui_home.png
13_dailybean_ui_calendar.png
14_dailybean_ui_report.png
```

