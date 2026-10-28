import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maeumteum/models/app_data.dart';
import 'package:maeumteum/models/mood_option.dart';
import 'package:maeumteum/shell.dart';
import 'package:maeumteum/theme/app_theme.dart';

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
}
