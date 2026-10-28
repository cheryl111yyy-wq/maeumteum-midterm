import 'package:flutter/material.dart';

import 'models/app_data.dart';
import 'models/mood_entry.dart';
import 'screens/history_screen.dart';
import 'screens/record_screen.dart';
import 'screens/report_screen.dart';
import 'screens/today_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

class MaeumteumShell extends StatefulWidget {
  const MaeumteumShell({
    super.key,
    required this.data,
    required this.loadState,
    required this.errorMessage,
    required this.dataModeLabel,
    this.initialIndex = 0,
    this.autoOpenRecord = false,
    required this.onRetry,
    required this.onDemoChanged,
    required this.onAddEntry,
  });

  final AppData? data;
  final AppLoadState loadState;
  final String errorMessage;
  final String dataModeLabel;
  final int initialIndex;
  final bool autoOpenRecord;
  final Future<void> Function() onRetry;
  final Future<void> Function(DemoStatus status) onDemoChanged;
  final ValueChanged<MoodEntry> onAddEntry;

  @override
  State<MaeumteumShell> createState() => _MaeumteumShellState();
}

class _MaeumteumShellState extends State<MaeumteumShell> {
  late int _selectedIndex = widget.initialIndex.clamp(0, 2);
  bool _didAutoOpenRecord = false;

  @override
  void initState() {
    super.initState();
    _maybeOpenRecord();
  }

  @override
  void didUpdateWidget(covariant MaeumteumShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeOpenRecord();
  }

  void _maybeOpenRecord() {
    if (!widget.autoOpenRecord ||
        _didAutoOpenRecord ||
        widget.data == null ||
        !mounted) {
      return;
    }
    _didAutoOpenRecord = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openRecord(context, null, <String>{});
    });
  }

  Future<void> _openRecord(
    BuildContext context,
    int? moodId,
    Set<String> situations,
  ) async {
    final data = widget.data;
    if (data == null) return;
    final entry = await Navigator.of(context).push<MoodEntry>(
      MaterialPageRoute(
        builder: (context) => RecordScreen(
          data: data,
          initialMoodId: moodId,
          initialSituations: situations,
        ),
      ),
    );
    if (entry == null || !mounted) return;
    widget.onAddEntry(entry);
    setState(() => _selectedIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final records = data?.sampleRecords ?? const <MoodEntry>[];
    final isSuccess = widget.loadState == AppLoadState.success && data != null;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 22,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.text,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.eco_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '마음틈',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontSize: 20),
            ),
          ],
        ),
        actions: [
          if (isSuccess)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Text(
                  widget.dataModeLabel,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ),
            ),
          DemoMenu(
            currentLabel: widget.dataModeLabel,
            onSelected: widget.onDemoChanged,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isSuccess
          ? IndexedStack(
              index: _selectedIndex,
              children: [
                TodayScreen(data: data, onStartRecord: _openRecord),
                HistoryScreen(records: records),
                ReportScreen(report: data.weeklyReport, records: records),
              ],
            )
          : AppStateView(
              state: widget.loadState,
              errorMessage: widget.errorMessage,
              onRetry: widget.onRetry,
            ),
      bottomNavigationBar: isSuccess
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.today_outlined),
                  selectedIcon: Icon(Icons.today),
                  label: '오늘',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: '기록',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: '리포트',
                ),
              ],
            )
          : null,
    );
  }
}
