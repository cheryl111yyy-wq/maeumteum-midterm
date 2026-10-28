import 'package:flutter/material.dart';

import '../models/mood_option.dart';
import '../theme/app_theme.dart';

Color colorFromHex(String value) {
  final normalized = value.replaceFirst('#', '');
  return Color(int.parse('FF$normalized', radix: 16));
}

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.moods,
    required this.selectedMoodId,
    required this.onChanged,
  });

  final List<MoodOption> moods;
  final int? selectedMoodId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 5 : 3;
        const spacing = 10.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: moods.map((mood) {
            final selected = mood.id == selectedMoodId;
            final color = colorFromHex(mood.colorHex);
            return Semantics(
              button: true,
              selected: selected,
              label: '${mood.label} 감정 선택',
              child: SizedBox(
                width: width,
                child: Material(
                  color: selected
                      ? color.withValues(alpha: 0.2)
                      : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: selected ? color : AppColors.border,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onChanged(mood.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 13,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 27),
                              ),
                              if (selected)
                                Positioned(
                                  right: -12,
                                  top: -5,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: AppColors.text,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            mood.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SituationSelector extends StatelessWidget {
  const SituationSelector({
    super.key,
    required this.situations,
    required this.selected,
    required this.onChanged,
  });

  final List<SituationOption> situations;
  final Set<String> selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: situations.map((item) {
        final isSelected = selected.contains(item.label);
        return FilterChip(
          selected: isSelected,
          showCheckmark: true,
          checkmarkColor: AppColors.text,
          avatar: Icon(
            situationIcon(item.icon),
            size: 18,
            color: isSelected ? AppColors.text : AppColors.muted,
          ),
          label: Text(item.label),
          onSelected: (_) => onChanged(item.label),
        );
      }).toList(),
    );
  }
}

IconData situationIcon(String name) {
  return switch (name) {
    'class' => Icons.school_outlined,
    'assignment' => Icons.assignment_outlined,
    'exam' => Icons.quiz_outlined,
    'part_time' => Icons.work_outline,
    'friends' => Icons.people_outline,
    'rest' => Icons.self_improvement_outlined,
    'sleep' => Icons.bedtime_outlined,
    _ => Icons.more_horiz,
  };
}
