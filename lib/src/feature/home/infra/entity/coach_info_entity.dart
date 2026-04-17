class CoachInfoEntity {
  const CoachInfoEntity({
    required this.isPrimary,
    required this.imageUrl,
    required this.name,
    required this.career,
    required this.instagram,
  });

  final bool isPrimary;
  final String imageUrl;
  final String name;
  final List<String> career;
  final String instagram;

  bool get hasImageUrl => imageUrl.trim().isNotEmpty;

  bool get hasInstagram => instagram.trim().isNotEmpty;
}
