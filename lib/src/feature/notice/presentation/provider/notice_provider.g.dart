// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoticeFeedController)
final noticeFeedControllerProvider = NoticeFeedControllerProvider._();

final class NoticeFeedControllerProvider
    extends $AsyncNotifierProvider<NoticeFeedController, NoticeFeedState> {
  NoticeFeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeFeedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeFeedControllerHash();

  @$internal
  @override
  NoticeFeedController create() => NoticeFeedController();
}

String _$noticeFeedControllerHash() =>
    r'f9d9195981f850c27444b5d1f780bc3ae28401e6';

abstract class _$NoticeFeedController extends $AsyncNotifier<NoticeFeedState> {
  FutureOr<NoticeFeedState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NoticeFeedState>, NoticeFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NoticeFeedState>, NoticeFeedState>,
              AsyncValue<NoticeFeedState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(noticeDetail)
final noticeDetailProvider = NoticeDetailFamily._();

final class NoticeDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<NoticeEntity>,
          NoticeEntity,
          FutureOr<NoticeEntity>
        >
    with $FutureModifier<NoticeEntity>, $FutureProvider<NoticeEntity> {
  NoticeDetailProvider._({
    required NoticeDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'noticeDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$noticeDetailHash();

  @override
  String toString() {
    return r'noticeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NoticeEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NoticeEntity> create(Ref ref) {
    final argument = this.argument as String;
    return noticeDetail(ref, noticeId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NoticeDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noticeDetailHash() => r'17b83e89fc03ccc8baa17a1790e025f9fa96b476';

final class NoticeDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NoticeEntity>, String> {
  NoticeDetailFamily._()
    : super(
        retry: null,
        name: r'noticeDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NoticeDetailProvider call({required String noticeId}) =>
      NoticeDetailProvider._(argument: noticeId, from: this);

  @override
  String toString() => r'noticeDetailProvider';
}
