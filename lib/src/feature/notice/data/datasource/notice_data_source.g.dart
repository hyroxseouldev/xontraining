// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(noticeDataSource)
final noticeDataSourceProvider = NoticeDataSourceProvider._();

final class NoticeDataSourceProvider
    extends
        $FunctionalProvider<
          NoticeDataSource,
          NoticeDataSource,
          NoticeDataSource
        >
    with $Provider<NoticeDataSource> {
  NoticeDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeDataSourceHash();

  @$internal
  @override
  $ProviderElement<NoticeDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoticeDataSource create(Ref ref) {
    return noticeDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoticeDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoticeDataSource>(value),
    );
  }
}

String _$noticeDataSourceHash() => r'6d6ea62bfb0cf3a764885d50c8e5976a93220514';
