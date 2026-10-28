import 'mood_entry.dart';
import 'mood_option.dart';
import 'weekly_report.dart';

class AppData {
  const AppData({
    required this.moods,
    required this.situations,
    required this.prompts,
    required this.sampleRecords,
    this.weeklyReport,
  });

  final List<MoodOption> moods;
  final List<SituationOption> situations;
  final List<PromptCard> prompts;
  final List<MoodEntry> sampleRecords;
  final WeeklyReport? weeklyReport;

  bool get isEmpty =>
      moods.isEmpty &&
      situations.isEmpty &&
      prompts.isEmpty &&
      sampleRecords.isEmpty &&
      weeklyReport == null;

  factory AppData.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(String key, T Function(Map<String, dynamic>) parser) {
      return (json[key] as List<dynamic>? ?? const [])
          .map((item) => parser(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    }

    return AppData(
      moods: parseList('moods', MoodOption.fromJson),
      situations: parseList('situations', SituationOption.fromJson),
      prompts: parseList('prompts', PromptCard.fromJson),
      sampleRecords: parseList('sampleRecords', MoodEntry.fromJson),
      weeklyReport: json['weeklyReport'] is Map<String, dynamic>
          ? WeeklyReport.fromJson(
              Map<String, dynamic>.from(json['weeklyReport'] as Map),
            )
          : null,
    );
  }

  AppData copyWith({List<MoodEntry>? sampleRecords}) {
    return AppData(
      moods: moods,
      situations: situations,
      prompts: prompts,
      sampleRecords: sampleRecords ?? this.sampleRecords,
      weeklyReport: weeklyReport,
    );
  }
}

enum AppLoadState { loading, success, empty, error }

enum DemoStatus { normal, loading, empty, error }
