class MoodOption {
  const MoodOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.colorHex,
  });

  final int id;
  final String label;
  final String emoji;
  final String colorHex;

  factory MoodOption.fromJson(Map<String, dynamic> json) {
    return MoodOption(
      id: json['id'] as int,
      label: json['label'] as String,
      emoji: json['emoji'] as String,
      colorHex: json['colorHex'] as String? ?? '#A79BC8',
    );
  }
}

class SituationOption {
  const SituationOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final int id;
  final String label;
  final String icon;

  factory SituationOption.fromJson(Map<String, dynamic> json) {
    return SituationOption(
      id: json['id'] as int,
      label: json['label'] as String,
      icon: json['icon'] as String,
    );
  }
}

class PromptCard {
  const PromptCard({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final int id;
  final String title;
  final String subtitle;

  factory PromptCard.fromJson(Map<String, dynamic> json) {
    return PromptCard(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}
