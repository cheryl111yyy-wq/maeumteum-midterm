import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key, required this.child, this.maxWidth = 760});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    );
  }
}

class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.state,
    required this.errorMessage,
    required this.onRetry,
  });

  final AppLoadState state;
  final String errorMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state == AppLoadState.loading) {
      return const _StateLayout(
        icon: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        title: '마음을 불러오고 있어요',
        description: '잠시만 기다려 주세요.',
      );
    }

    if (state == AppLoadState.empty) {
      return _StateLayout(
        icon: const Icon(Icons.inbox_outlined, size: 42, color: AppColors.sage),
        title: '아직 표시할 기록이 없어요',
        description: '데이터가 준비되면 오늘의 마음을 남길 수 있어요.',
        action: OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('다시 불러오기'),
        ),
      );
    }

    return _StateLayout(
      icon: const Icon(
        Icons.cloud_off_outlined,
        size: 44,
        color: AppColors.peach,
      ),
      title: '데이터를 불러오지 못했어요',
      description: 'json-server가 실행 중인지 확인한 뒤 다시 시도해 주세요.',
      detail: errorMessage,
      action: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('다시 시도'),
      ),
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.title,
    required this.description,
    this.detail,
    this.action,
  });

  final Widget icon;
  final String title;
  final String description;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            if (detail != null && detail!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                detail!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 26),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: action,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptySection extends StatelessWidget {
  const EmptySection({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.edit_note_outlined,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: Column(
        children: [
          Icon(icon, size: 38, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class MoodRecordCard extends StatelessWidget {
  const MoodRecordCard({super.key, required this.entry, this.onTap});

  final MoodEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '${entry.date} ${entry.moodLabel} 기록',
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(entry.moodEmoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.moodLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.date,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    if (entry.isSample)
                      Text(
                        '예시',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColors.muted),
                      ),
                  ],
                ),
                if (entry.situations.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.situations
                        .map(
                          (label) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.paleSage,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              label,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (entry.note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    entry.note,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DemoMenu extends StatelessWidget {
  const DemoMenu({
    super.key,
    required this.currentLabel,
    required this.onSelected,
  });

  final String currentLabel;
  final Future<void> Function(DemoStatus) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DemoStatus>(
      tooltip: '발표용 상태 전환',
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: DemoStatus.normal,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.cloud_done_outlined),
            title: Text('정상 데이터'),
          ),
        ),
        PopupMenuItem(
          value: DemoStatus.loading,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.hourglass_top),
            title: Text('로딩 상태'),
          ),
        ),
        PopupMenuItem(
          value: DemoStatus.empty,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.inbox_outlined),
            title: Text('빈 상태'),
          ),
        ),
        PopupMenuItem(
          value: DemoStatus.error,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.cloud_off_outlined),
            title: Text('오류 상태'),
          ),
        ),
      ],
      child: Semantics(
        label: currentLabel,
        button: true,
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
