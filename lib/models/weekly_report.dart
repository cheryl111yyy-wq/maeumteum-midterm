class WeeklyReport {
  const WeeklyReport({
    required this.rangeStart,
    required this.rangeEnd,
    required this.recordedDays,
    required this.topMoodLabel,
    required this.topMoodEmoji,
    required this.topTags,
    required this.moodFlow,
    required this.summary,
    required this.includesSample,
  });

  final String rangeStart;
  final String rangeEnd;
  final int recordedDays;
  final String topMoodLabel;
  final String topMoodEmoji;
  final List<ReportTagCount> topTags;
  final List<ReportMoodDay> moodFlow;
  final String summary;
  final bool includesSample;

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      rangeStart: json['rangeStart'] as String,
      rangeEnd: json['rangeEnd'] as String,
      recordedDays: json['recordedDays'] as int,
      topMoodLabel: json['topMoodLabel'] as String,
      topMoodEmoji: json['topMoodEmoji'] as String,
      topTags: (json['topTags'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                ReportTagCount.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
      moodFlow: (json['moodFlow'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                ReportMoodDay.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
      summary: json['summary'] as String,
      includesSample: json['includesSample'] as bool? ?? false,
    );
  }
}

class ReportTagCount {
  const ReportTagCount({required this.label, required this.count});

  final String label;
  final int count;

  factory ReportTagCount.fromJson(Map<String, dynamic> json) {
    return ReportTagCount(
      label: json['label'] as String,
      count: json['count'] as int,
    );
  }
}

class ReportMoodDay {
  const ReportMoodDay({required this.weekday, required this.emoji});

  final String weekday;
  final String emoji;

  factory ReportMoodDay.fromJson(Map<String, dynamic> json) {
    return ReportMoodDay(
      weekday: json['weekday'] as String,
      emoji: json['emoji'] as String,
    );
  }
}
