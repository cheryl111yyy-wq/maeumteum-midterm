import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maeumteum/models/app_data.dart';
import 'package:maeumteum/models/mood_entry.dart';
import 'package:maeumteum/models/mood_option.dart';
import 'package:maeumteum/models/weekly_report.dart';
import 'package:maeumteum/screens/report_screen.dart';
import 'package:maeumteum/shell.dart';
import 'package:maeumteum/theme/app_theme.dart';
import 'package:maeumteum/utils/date_utils.dart';

void main() {
  testWidgets('successful shell switches between the three main sections', (
    tester,
  ) async {
    const data = AppData(
      moods: [MoodOption(id: 1, label: '평온', emoji: '😌', colorHex: '#A8B8A0')],
      situations: [SituationOption(id: 1, label: '수업', icon: 'class')],
      prompts: [
        PromptCard(id: 1, title: '오늘의 마음은 어떤가요?', subtitle: '천천히 골라보세요.'),
      ],
      sampleRecords: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: MaeumteumShell(
          data: data,
          loadState: AppLoadState.success,
          errorMessage: '',
          dataModeLabel: '서버 데이터',
          onRetry: () async {},
          onDemoChanged: (_) async {},
          onAddEntry: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 마음은 어떤가요?'), findsOneWidget);

    await tester.tap(find.text('리포트'));
    await tester.pumpAndSettle();
    expect(find.text('아직 돌아볼 기록이 없어요'), findsOneWidget);
  });

  testWidgets('weekly report shows the newly added record for today', (
    tester,
  ) async {
    final today = apiDate(DateTime.now());
    final report = WeeklyReport(
      rangeStart: today,
      rangeEnd: today,
      recordedDays: 1,
      topMoodLabel: '평온',
      topMoodEmoji: '😌',
      topTags: const [],
      moodFlow: const [],
      summary: '오늘의 기록입니다.',
      includesSample: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: ReportScreen(
          report: report,
          records: [
            MoodEntry(
              id: 'local-today',
              date: today,
              moodId: 1,
              moodLabel: '평온',
              moodEmoji: '😌',
              situations: const ['시험'],
              note: '발표 준비를 마쳤다.',
              isSample: false,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘 남긴 기록'), findsOneWidget);
    expect(find.text('발표 준비를 마쳤다.'), findsOneWidget);
  });

  testWidgets('weekly report keeps today record when summary data is missing', (
    tester,
  ) async {
    final today = apiDate(DateTime.now());

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: ReportScreen(
          report: null,
          records: [
            MoodEntry(
              id: 'local-today',
              date: today,
              moodId: 1,
              moodLabel: '평온',
              moodEmoji: '😌',
              situations: const ['시험'],
              note: '오늘 기록을 확인했다.',
              isSample: false,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘 남긴 기록'), findsOneWidget);
    expect(find.text('오늘 기록을 확인했다.'), findsOneWidget);
    expect(find.text('최근 7일 요약 데이터는 아직 불러오지 못했어요.'), findsOneWidget);
  });
}
