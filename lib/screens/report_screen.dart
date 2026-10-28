import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import '../models/weekly_report.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/common_widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({
    super.key,
    required this.report,
    this.records = const [],
  });

  final WeeklyReport? report;
  final List<MoodEntry> records;

  @override
  Widget build(BuildContext context) {
    final data = report;
    final today = apiDate(DateTime.now());
    MoodEntry? todayEntry;
    for (final entry in records.reversed) {
      if (entry.date == today) {
        todayEntry = entry;
        break;
      }
    }

    if (data == null) {
      if (todayEntry == null) {
        return const ResponsivePage(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(22),
            child: EmptySection(
              icon: Icons.insights_outlined,
              title: '아직 돌아볼 기록이 없어요',
              description: '기록이 쌓이면 최근 7일의 마음과 생활을 요약해 드려요.',
            ),
          ),
        );
      }

      return ResponsivePage(
        maxWidth: 900,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('주간 리포트', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 5),
              Text(
                '오늘 남긴 기록을 먼저 확인할 수 있어요.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 22),
              const SectionHeader(title: '오늘 남긴 기록'),
              const SizedBox(height: 10),
              MoodRecordCard(entry: todayEntry),
              const SizedBox(height: 20),
              Text(
                '최근 7일 요약 데이터는 아직 불러오지 못했어요.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      );
    }

    // P08: 미적이고 최소한의 디자인 - 주간 요약은 서버의 모의 결과만 간결하게 표시한다.
    final summary = Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '최근 7일',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (data.includesSample)
                  Text(
                    '예시 데이터 포함',
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppColors.muted),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${data.rangeStart} - ${data.rangeEnd}',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                _Metric(value: '${data.recordedDays} / 7', label: '기록한 날'),
                const SizedBox(width: 12),
                _Metric(
                  value: '${data.topMoodLabel} ${data.topMoodEmoji}',
                  label: '가장 자주 남긴 마음',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('최근 마음의 흐름', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            _MoodStrip(entries: data.moodFlow),
            if (data.recordedDays < 3) ...[
              const SizedBox(height: 16),
              Text(
                '기록이 3일 이상 쌓이면 생활 태그와 마음의 흐름을 더 안정적으로 돌아볼 수 있어요.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
    );

    final reflection = Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('자주 남긴 생활', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (data.topTags.isEmpty)
              Text(
                '선택한 생활 태그가 없어요.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted),
              )
            else
              ...data.topTags.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '${entry.count}회',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(height: 30),
            Text('이번 주 돌아보기', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(data.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text(
              '이 문장은 기록된 횟수만 보여줘요. 특정 상황이 감정의 원인이라는 결론은 내리지 않아요.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );

    return ResponsivePage(
      maxWidth: 900,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주간 리포트', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 5),
            Text(
              '기록을 평가하지 않고, 최근의 흐름만 가볍게 살펴봐요.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            if (todayEntry != null) ...[
              const SectionHeader(title: '오늘 남긴 기록'),
              const SizedBox(height: 10),
              MoodRecordCard(entry: todayEntry),
              const SizedBox(height: 20),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 720) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: summary),
                      const SizedBox(width: 18),
                      Expanded(flex: 4, child: reflection),
                    ],
                  );
                }
                return Column(
                  children: [summary, const SizedBox(height: 16), reflection],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodStrip extends StatelessWidget {
  const _MoodStrip({required this.entries});

  final List<ReportMoodDay> entries;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                Text(
                  entry.weekday,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 7),
                Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.paleSage,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.emoji,
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
