import 'package:flutter/material.dart';

import 'models/app_data.dart';
import 'models/mood_entry.dart';
import 'services/api_service.dart';
import 'shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MaeumteumApp());
}

class MaeumteumApp extends StatefulWidget {
  const MaeumteumApp({super.key});

  @override
  State<MaeumteumApp> createState() => _MaeumteumAppState();
}

class _MaeumteumAppState extends State<MaeumteumApp> {
  late Future<AppData> _dataFuture;
  AppData? _resolvedData;
  AppData? _localData;
  String _dataModeLabel = '서버 데이터';
  String _currentPath = '/bootstrap';
  bool _currentLoadingDelay = false;

  @override
  void initState() {
    super.initState();
    final view = Uri.base.queryParameters['view'];
    switch (view) {
      case 'loading-preview':
        _currentLoadingDelay = true;
        _dataModeLabel = '로딩 상태 시연';
      case 'loading':
        _currentLoadingDelay = true;
        _dataModeLabel = '로딩 상태 시연';
      case 'empty':
        _currentPath = '/emptyState';
        _dataModeLabel = '빈 상태 시연';
      case 'error':
        _currentPath = '/unreachable';
        _dataModeLabel = '오류 상태 시연';
    }
    _dataFuture = _fetchData(
      path: _currentPath,
      showLoadingDelay: _currentLoadingDelay,
    );
  }

  Future<AppData> _fetchData({
    required String path,
    required bool showLoadingDelay,
  }) async {
    // P01: 시스템 상태의 가시성 - 요청 시작과 동시에 로딩 상태를 보여 준다.
    if (showLoadingDelay) {
      await Future<void>.delayed(const Duration(milliseconds: 1400));
    }
    final data = await ApiService.instance.fetchBootstrap(path: path);
    _resolvedData = data;
    return data;
  }

  void _reloadData({
    String path = '/bootstrap',
    bool showLoadingDelay = false,
    String label = '서버 데이터',
  }) {
    setState(() {
      _currentPath = path;
      _currentLoadingDelay = showLoadingDelay;
      _dataModeLabel = label;
      _resolvedData = null;
      _localData = null;
      _dataFuture = _fetchData(path: path, showLoadingDelay: showLoadingDelay);
    });
  }

  Future<void> _retry() async {
    _reloadData(
      path: _currentPath,
      showLoadingDelay: false,
      label: _dataModeLabel,
    );
  }

  Future<void> _runDemo(DemoStatus status) async {
    switch (status) {
      case DemoStatus.normal:
        _reloadData(label: '서버 데이터');
      case DemoStatus.loading:
        _reloadData(showLoadingDelay: true, label: '로딩 상태 시연');
      case DemoStatus.empty:
        _reloadData(path: '/emptyState', label: '빈 상태 시연');
      case DemoStatus.error:
        _reloadData(path: '/unreachable', label: '오류 상태 시연');
    }
  }

  void _addEntry(MoodEntry entry) {
    final current = _localData ?? _resolvedData;
    if (current == null) return;
    final records = [...current.sampleRecords]
      ..removeWhere((item) => item.date == entry.date)
      ..add(entry);
    setState(() {
      _localData = current.copyWith(sampleRecords: records);
    });
  }

  @override
  Widget build(BuildContext context) {
    final view = Uri.base.queryParameters['view'];
    return FutureBuilder<AppData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        final data = _localData ?? snapshot.data;
        // P01: FutureBuilder의 waiting 상태를 명시적인 Loading 화면으로 연결한다.
        // P09: hasError를 숨기지 않고 재시도 가능한 Error 화면으로 전환한다.
        final loadState = snapshot.connectionState == ConnectionState.waiting
            ? AppLoadState.loading
            : snapshot.hasError
            ? AppLoadState.error
            : data == null || data.isEmpty
            ? AppLoadState.empty
            : AppLoadState.success;

        return MaterialApp(
          title: '마음틈',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: MaeumteumShell(
            data: data,
            loadState: loadState,
            errorMessage: snapshot.error?.toString() ?? '',
            dataModeLabel: _dataModeLabel,
            initialIndex: view == 'history'
                ? 1
                : view == 'report'
                ? 2
                : 0,
            autoOpenRecord: view == 'record',
            onRetry: _retry,
            onDemoChanged: _runDemo,
            onAddEntry: _addEntry,
          ),
        );
      },
    );
  }
}
