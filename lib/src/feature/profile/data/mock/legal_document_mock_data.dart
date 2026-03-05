import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/infra/service/legal_html_parser.dart';

final _parser = LegalHtmlParser();

LegalDocumentEntity buildMockTermsOfService() {
  const html = '''
<h1>XON 트레이닝 이용약관</h1>
<p>본 약관은 XON 트레이닝 서비스 이용 조건을 규정합니다.</p>
<h2>제1조 목적</h2>
<p>본 약관은 회원과 회사 간 권리, 의무 및 책임사항을 정합니다.</p>
<h2>제2조 회원의 의무</h2>
<ul>
  <li>회원은 정확한 정보를 제공해야 합니다.</li>
  <li>회원은 타인의 계정을 도용하거나 서비스 운영을 방해해서는 안 됩니다.</li>
  <li><strong>결제 내역 및 운동 데이터</strong>는 서비스 정책에 따라 관리됩니다.</li>
</ul>
<h2>제3조 유료 서비스</h2>
<p>유료 서비스 이용 시 결제 정책 및 환불 정책이 적용됩니다. 자세한 내용은 <a href="https://example.com/terms/payments">결제 정책</a>을 확인해 주세요.</p>
''';

  return LegalDocumentEntity(
    type: LegalDocumentType.termsOfService,
    version: 'v0.1.0',
    updatedAt: DateTime(2026, 3, 1),
    rawHtml: html,
    contentJson: _parser.parseToJson(html),
  );
}

LegalDocumentEntity buildMockPrivacyPolicy() {
  const html = '''
<h1>XON 트레이닝 개인정보처리방침</h1>
<p>회사는 회원의 개인정보를 관련 법령에 따라 안전하게 처리합니다.</p>
<h2>수집 항목</h2>
<ul>
  <li>프로필 정보(이름, 아바타)</li>
  <li>운동 기록(운동명, 측정값, 기록일)</li>
  <li>결제 및 구매 내역</li>
</ul>
<h2>이용 목적</h2>
<p>수집한 정보는 서비스 제공, 사용자 맞춤 콘텐츠 제공, 고객 지원을 위해 사용됩니다.</p>
<h2>보관 및 삭제</h2>
<p>회원 탈퇴 시 관련 정책 및 법령에 따라 일부 정보는 일정 기간 보관될 수 있습니다. 자세한 내용은 <a href="https://example.com/privacy/data-retention">보관 정책</a>을 참고해 주세요.</p>
''';

  return LegalDocumentEntity(
    type: LegalDocumentType.privacyPolicy,
    version: 'v0.1.0',
    updatedAt: DateTime(2026, 3, 1),
    rawHtml: html,
    contentJson: _parser.parseToJson(html),
  );
}
