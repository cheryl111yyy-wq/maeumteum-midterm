import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/selectors.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({
    super.key,
    required this.data,
    this.initialMoodId,
    this.initialSituations = const {},
  });

  final AppData data;
  final int? initialMoodId;
  final Set<String> initialSituations;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late int? _selectedMoodId = widget.initialMoodId;
  late final Set<String> _selectedSituations = {...widget.initialSituations};
  final TextEditingController _noteController = TextEditingController();
  bool _showMoodError = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _completeRecord() {
    final moodId = _selectedMoodId;
    // P05: 오류 예방 - 필수 정보가 없으면 제출 전에 멈추고 수정 방법을 알려 준다.
    if (moodId == null) {
      setState(() => _showMoodError = true);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('오늘의 마음을 먼저 선택해 주세요.')));
      return;
    }

    final mood = widget.data.moods.firstWhere((item) => item.id == moodId);
    final now = DateTime.now();
    Navigator.of(context).pop(
      MoodEntry(
        id: 'local-${now.microsecondsSinceEpoch}',
        date: apiDate(now),
        moodId: mood.id,
        moodLabel: mood.label,
        moodEmoji: mood.emoji,
        situations: _selectedSituations.toList(growable: false),
        note: _noteController.text.trim(),
        isSample: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기록하기'), centerTitle: false),
      body: ResponsivePage(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                koreanDate(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 6),
              Text(
                '오늘의 마음을 남겨볼까요?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '필요한 만큼만 적어도 괜찮아요.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 28),
              SectionHeader(
                title: '1. 오늘의 마음',
                trailing: Text(
                  '필수',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.lavender),
                ),
              ),
              const SizedBox(height: 12),
              MoodSelector(
                moods: widget.data.moods,
                selectedMoodId: _selectedMoodId,
                onChanged: (id) {
                  setState(() {
                    _selectedMoodId = id;
                    _showMoodError = false;
                  });
                },
              ),
              if (_showMoodError) ...[
                const SizedBox(height: 8),
                Text(
                  '감정을 하나 선택해 주세요.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.peach),
                ),
              ],
              const SizedBox(height: 28),
              SectionHeader(
                title: '2. 오늘의 상황',
                // P03: 사용자 통제와 자유 - 생활 태그는 선택 사항이며 언제든 해제할 수 있다.
                trailing: Text(
                  '선택',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 12),
              SituationSelector(
                situations: widget.data.situations,
                selected: _selectedSituations,
                onChanged: (value) {
                  setState(() {
                    if (!_selectedSituations.remove(value)) {
                      _selectedSituations.add(value);
                    }
                  });
                },
              ),
              const SizedBox(height: 28),
              SectionHeader(
                title: '3. 한 줄 메모',
                trailing: Text(
                  '선택',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                maxLength: 120,
                decoration: const InputDecoration(
                  hintText: '기억하고 싶은 순간을 짧게 적어보세요.',
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _completeRecord,
                icon: const Icon(Icons.check),
                label: const Text('기록 완료'),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  '이 화면의 기록은 발표용 임시 상태이며 서버에 저장되지 않습니다.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
