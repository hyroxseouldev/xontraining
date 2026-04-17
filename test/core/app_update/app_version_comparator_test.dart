import 'package:flutter_test/flutter_test.dart';
import 'package:xontraining/src/core/app_update/infra/service/app_version_comparator.dart';

void main() {
  group('AppVersionComparator', () {
    test('compares semantic versions by numeric segments', () {
      expect(AppVersionComparator.compare('1.0.10', '1.0.9'), greaterThan(0));
      expect(AppVersionComparator.compare('1.0.1', '1.0.1'), 0);
      expect(AppVersionComparator.compare('1.0.0', '1.0.1'), lessThan(0));
    });

    test('ignores build and prerelease suffixes', () {
      expect(AppVersionComparator.compare('1.0.1+5', '1.0.1'), 0);
      expect(
        AppVersionComparator.compare('1.0.2-beta', '1.0.1'),
        greaterThan(0),
      );
    });

    test('returns null for invalid version strings', () {
      expect(AppVersionComparator.compare('1.a.0', '1.0.0'), isNull);
      expect(AppVersionComparator.compare('', '1.0.0'), isNull);
    });
  });
}
