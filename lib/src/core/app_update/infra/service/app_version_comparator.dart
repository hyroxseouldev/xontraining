import 'dart:math' as math;

class AppVersionComparator {
  const AppVersionComparator._();

  static int? compare(String left, String right) {
    final leftParts = _parse(left);
    final rightParts = _parse(right);
    if (leftParts == null || rightParts == null) {
      return null;
    }

    final maxLength = math.max(leftParts.length, rightParts.length);
    for (var index = 0; index < maxLength; index += 1) {
      final leftValue = index < leftParts.length ? leftParts[index] : 0;
      final rightValue = index < rightParts.length ? rightParts[index] : 0;
      if (leftValue != rightValue) {
        return leftValue.compareTo(rightValue);
      }
    }

    return 0;
  }

  static List<int>? _parse(String version) {
    final normalized = version.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final coreVersion = normalized.split('+').first.split('-').first.trim();
    if (coreVersion.isEmpty) {
      return null;
    }

    final segments = coreVersion.split('.');
    if (segments.isEmpty) {
      return null;
    }

    final values = <int>[];
    for (final segment in segments) {
      final parsed = int.tryParse(segment);
      if (parsed == null) {
        return null;
      }
      values.add(parsed);
    }

    return values;
  }
}
