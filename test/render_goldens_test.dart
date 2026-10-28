import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maeumteum/models/app_data.dart';
import 'package:maeumteum/shell.dart';
import 'package:maeumteum/theme/app_theme.dart';
import 'package:maeumteum/widgets/common_widgets.dart';

void main() {
  final raw = File('mock_server/db.json').readAsStringSync();
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final data = AppData.fromJson(
    Map<String, dynamic>.from(json['bootstrap'] as Map),
  );

  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(780, 1688);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
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
  }

  Future<void> pumpState(
    WidgetTester tester,
    AppLoadState state,
    String errorMessage, {
    bool settle = true,
  }) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(780, 1688);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: Scaffold(
          body: AppStateView(
            state: state,
            errorMessage: errorMessage,
            onRetry: () async {},
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('render product screens', (tester) async {
    await pumpShell(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/today.png'),
    );

    await tester.tap(find.text('기록 시작하기'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/record.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpShell(tester);
    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/history.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpShell(tester);
    await tester.tap(find.text('리포트'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/report.png'),
    );
  });

  testWidgets('render request and adaptive state screens', (tester) async {
    await pumpState(tester, AppLoadState.loading, '', settle: false);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/loading.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpState(tester, AppLoadState.empty, '');
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/empty.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpState(
      tester,
      AppLoadState.error,
      'Exception: GET /unreachable 실패 (404)',
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/error.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(2000, 1480);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
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
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wide.png'),
    );
  });
}
