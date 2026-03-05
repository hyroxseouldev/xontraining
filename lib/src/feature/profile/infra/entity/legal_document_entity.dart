enum LegalDocumentType { termsOfService, privacyPolicy }

class LegalDocumentEntity {
  const LegalDocumentEntity({
    required this.type,
    required this.version,
    required this.updatedAt,
    required this.rawHtml,
    required this.contentJson,
  });

  final LegalDocumentType type;
  final String version;
  final DateTime updatedAt;
  final String rawHtml;
  final List<Map<String, dynamic>> contentJson;
}
