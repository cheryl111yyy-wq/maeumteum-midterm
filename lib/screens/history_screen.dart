import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/common_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.records});

  final List<MoodEntry> records;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  Map<String, MoodEntry> get _recordsByDate => {
    for (final record in widget.records) record.date: record,
  };

  List<MoodEntry> get _sortedRecords {
    final result = [...widget.records]
      ..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  void _moveMonth(int offset) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + offset,
      );
    });
  }

  void _showRecord(MoodEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.date, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(entry.moodEmoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Text(
                    entry.moodLabel,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              if (entry.situations.isNotEmpty) ...[
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.situations
                      .map((item) => Chip(label: Text(item)))
                      .toList(),
                ),
              ],
              if (entry.note.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(entry.note, style: Theme.of(context).textTheme.bodyLarge),
              ],
              const SizedBox(height: 20),
              Text(
                entry.isSample ? '예시 데이터' : '이번 실행에서 입력한 기록',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final byDate = _recordsByDate;
    final calendar = Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: '이전 달',
                  onPressed: () => _moveMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    '${_visibleMonth.year}년 ${_visibleMonth.month}월',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: '다음 달',
                  onPressed: () => _moveMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: koreanMonthWeekdays
                  .map(
                    (weekday) => Expanded(
                      child: Center(
                        child: Text(
                          weekday,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            _MonthGrid(
              month: _visibleMonth,
              recordsByDate: byDate,
              onSelect: _showRecord,
            ),
          ],
        ),
      ),
    );

    final recent = Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 기록', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_sortedRecords.isEmpty)
              const EmptySection(
                title: '기록이 없어요',
                description: '오늘 화면에서 첫 기록을 남겨보세요.',
              )
            else
              ..._sortedRecords
                  .take(4)
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _showRecord(entry),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                entry.moodEmoji,
                                style: const TextStyle(fontSize: 25),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.moodLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    if (entry.situations.isNotEmpty)
                                      Text(
                                        entry.situations.join(' · '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: AppColors.muted),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                entry.date.substring(5).replaceAll('-', '.'),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
            Text('나의 기록', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 5),
            Text(
              '날짜를 눌러 그날의 마음을 확인해 보세요.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 720) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: calendar),
                      const SizedBox(width: 18),
                      Expanded(flex: 3, child: recent),
                    ],
                  );
                }
                return Column(
                  children: [calendar, const SizedBox(height: 16), recent],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.recordsByDate,
    required this.onSelect,
  });

  final DateTime month;
  final Map<String, MoodEntry> recordsByDate;
  final ValueChanged<MoodEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final leading = firstDay.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        final day = index - leading + 1;
        if (day < 1 || day > daysInMonth) {
          return const SizedBox.shrink();
        }
        final date = DateTime(month.year, month.month, day);
        final key = apiDate(date);
        final entry = recordsByDate[key];
        final isToday = apiDate(today) == key;

        return Semantics(
          button: entry != null,
          label: entry == null ? '$day일 기록 없음' : '$day일 ${entry.moodLabel} 기록',
          child: Material(
            color: isToday ? AppColors.paleLavender : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isToday ? AppColors.lavender : Colors.transparent,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: entry == null ? null : () => onSelect(entry),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry?.moodEmoji ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
