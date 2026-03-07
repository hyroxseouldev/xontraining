enum LegalDocumentType { termsOfService, privacyPolicy }

class LegalDocumentEntity {
  const LegalDocumentEntity({
    required this.type,
    required this.locale,
    required this.title,
    required this.version,
    required this.updatedAt,
    required this.rawHtml,
    required this.contentJson,
  });

  final LegalDocumentType type;
  final String locale;
  final String title;
  final String version;
  final DateTime updatedAt;
  final String rawHtml;
  final List<Map<String, dynamic>> contentJson;
}
