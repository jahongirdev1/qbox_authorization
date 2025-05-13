class Appearance {
  const Appearance({
    required this.icon,
    required this.backgroundImages,
    required this.title,
    required this.description,
  });

  final String icon;
  final List<String> backgroundImages;
  final String title;
  final String description;

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      icon: (json['icon'] as String? ?? ""),
      backgroundImages: (json['background_images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      title: json['title'] as String? ?? 'Ai Box',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  String toString() => 'Appearance('
      'icon: $icon,'
      'backgroundImages: $backgroundImages,'
      'title: $title,'
      'description: $description)';
}
