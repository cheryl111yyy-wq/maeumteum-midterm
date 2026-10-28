import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/selectors.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({
    super.key,
    required this.data,
    required this.onStartRecord,
  });

  final AppData data;
  final Future<void> Function(
    BuildContext context,
    int? moodId,
    Set<String> situations,
  )
  onStartRecord;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  int? _selectedMoodId;
  final Set<String> _selectedSituations = {};

  MoodEntry? get _todayEntry {
    final today = apiDate(DateTime.now());
    for (final entry in widget.data.sampleRecords) {
      if (entry.date == today) return entry;
    }
    return null;
  }

  Future<void> _startRecord() async {
    await widget.onStartRecord(
      context,
      _selectedMoodId ?? _todayEntry?.moodId,
      _selectedSituations.isEmpty
          ? {...?_todayEntry?.situations}
          : _selectedSituations,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prompt = widget.data.prompts.isEmpty
        ? null
        : widget.data.prompts.first;
    final todayEntry = _todayEntry;
    final recordCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: todayEntry == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 기록',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  const EmptySection(
                    title: '아직 기록이 없어요',
                    description: '감정을 고르고 짧게 남겨 보세요.',
                  ),
                  FilledButton(
                    onPressed: _startRecord,
                    child: const Text('기록 시작하기'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        todayEntry.moodEmoji,
                        style: const TextStyle(fontSize: 34),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘의 마음 · ${todayEntry.moodLabel}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '기록을 남겼어요',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: AppColors.sage),
                    ],
                  ),
                  if (todayEntry.situations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: todayEntry.situations
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.paleSage,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(item),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (todayEntry.note.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      todayEntry.note,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: _startRecord,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('기록 수정하기'),
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
            Text('오늘', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              koreanDate(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final intro = Container(
                  padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                  decoration: BoxDecoration(
                    color: AppColors.paleLavender,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prompt?.title ?? '오늘의 마음은 어떤가요?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        prompt?.subtitle ?? '부담 없이 오늘의 감정을 골라 보세요.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          const Icon(
                            Icons.bolt_outlined,
                            size: 18,
                            color: AppColors.text,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '감정 선택은 약 10초면 충분해요',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                // P07: 유연성과 효율성 - 넓은 화면에서는 주요 정보를 나란히 보여 준다.
                if (constraints.maxWidth >= 700) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: intro),
                      const SizedBox(width: 18),
                      Expanded(flex: 4, child: recordCard),
                    ],
                  );
                }

                return Column(
                  children: [intro, const SizedBox(height: 16), recordCard],
                );
              },
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: '오늘의 마음'),
            const SizedBox(height: 12),
            MoodSelector(
              moods: widget.data.moods,
              selectedMoodId: _selectedMoodId ?? todayEntry?.moodId,
              onChanged: (id) => setState(() => _selectedMoodId = id),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: '오늘의 생활'),
            const SizedBox(height: 12),
            SituationSelector(
              situations: widget.data.situations,
              selected: _selectedSituations.isEmpty && todayEntry != null
                  ? {...todayEntry.situations}
                  : _selectedSituations,
              onChanged: (value) {
                setState(() {
                  if (!_selectedSituations.remove(value)) {
                    _selectedSituations.add(value);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            Text(
              '생활 태그와 한 줄 메모는 선택 사항이에요.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
