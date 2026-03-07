import 'package:flutter/material.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/view/legal_document_view.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(type: LegalDocumentType.termsOfService);
  }
}
