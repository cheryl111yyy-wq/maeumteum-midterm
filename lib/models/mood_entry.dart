class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.date,
    required this.moodId,
    required this.moodLabel,
    required this.moodEmoji,
    required this.situations,
    required this.note,
    required this.isSample,
  });

  final String id;
  final String date;
  final int moodId;
  final String moodLabel;
  final String moodEmoji;
  final List<String> situations;
  final String note;
  final bool isSample;

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: '${json['id']}',
      date: json['date'] as String,
      moodId: json['moodId'] as int,
      moodLabel: json['moodLabel'] as String,
      moodEmoji: json['moodEmoji'] as String,
      situations: (json['situations'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      note: json['note'] as String? ?? '',
      isSample: json['isSample'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'moodId': moodId,
      'moodLabel': moodLabel,
      'moodEmoji': moodEmoji,
      'situations': situations,
      'note': note,
      'isSample': isSample,
    };
  }
}
