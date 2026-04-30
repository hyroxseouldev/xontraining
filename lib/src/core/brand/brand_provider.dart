import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/brand/brand.dart';
import 'package:xontraining/src/core/brand/brand_config.dart';

final brandProvider = Provider<Brand>((ref) {
  throw UnimplementedError(
    'brandProvider must be overridden during bootstrap.',
  );
});

final brandConfigProvider = Provider<BrandConfig>((ref) {
  final brand = ref.watch(brandProvider);
  return BrandConfig.fromBrand(brand);
});
