import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/feature/community/presentation/provider/community_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

const int _maxCommunityImages = 4;
const int _maxCommunityImageBytes = 8 * 1024 * 1024;
const Set<String> _allowedCommunityImageExtensions = <String>{
  'jpg',
  'jpeg',
  'png',
  'webp',
};
const List<String> _restrictedCommunityTerms = <String>[
  'porn',
  'nude',
  '성인',
  '음란',
  '혐오',
  'kill',
];

class CommunityWriteView extends ConsumerStatefulWidget {
  const CommunityWriteView({
    this.postId,
    this.initialContent,
    this.initialImageUrls = const [],
    super.key,
  });

  final String? postId;
  final String? initialContent;
  final List<String> initialImageUrls;

  bool get isEditMode => postId != null;

  @override
  ConsumerState<CommunityWriteView> createState() => _CommunityWriteViewState();
}

class _CommunityWriteViewState extends ConsumerState<CommunityWriteView> {
  late final TextEditingController _contentController;
  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _initialRemoteImageUrls = <String>[];
  final List<String> _remoteImageUrls = <String>[];
  final List<_SelectedImage> _selectedImages = <_SelectedImage>[];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.initialContent ?? '',
    );
    _remoteImageUrls
      ..clear()
      ..addAll(widget.initialImageUrls);
    _initialRemoteImageUrls
      ..clear()
      ..addAll(widget.initialImageUrls);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final minimalEnabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );
    final minimalFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
    );
    final accessState = ref.watch(communityAccessProvider);
    final actionState = ref.watch(communityActionControllerProvider);
    final isLoading = actionState.isLoading;

    ref.listen<AsyncValue<void>>(communityActionControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.communityActionFailed)));
        },
      );
    });

    final totalImageCount = _remoteImageUrls.length + _selectedImages.length;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                widget.isEditMode
                    ? l10n.communityEditPost
                    : l10n.communityWritePost,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: accessState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            EmptyState(message: l10n.communityLoadFailed),
        data: (canAccess) {
          if (!canAccess) {
            return EmptyState(
              message: l10n.communityMembershipRequired,
              icon: Icons.lock_outline,
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : _onPickImagesPressed,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(l10n.communityAddImages),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.communityImageCount(
                          totalImageCount,
                          _maxCommunityImages,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (totalImageCount > 0) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: totalImageCount,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index < _remoteImageUrls.length) {
                            final imageUrl = _remoteImageUrls[index];
                            return _CommunityImageChip(
                              image: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, imageUrl) =>
                                    const ColoredBox(color: Colors.black12),
                                errorWidget: (context, imageUrl, error) =>
                                    const Icon(Icons.broken_image_outlined),
                              ),
                              onRemove: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _remoteImageUrls.removeAt(index);
                                      });
                                    },
                            );
                          }

                          final localIndex = index - _remoteImageUrls.length;
                          final local = _selectedImages[localIndex];
                          return _CommunityImageChip(
                            image: Image.memory(local.bytes, fit: BoxFit.cover),
                            onRemove: isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _selectedImages.removeAt(localIndex);
                                    });
                                  },
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.communityWriteGuidelineTitle,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSecondaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.communityWriteGuidelineBody,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      enabled: !isLoading,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: l10n.communityContentHint,
                        filled: false,
                        enabledBorder: minimalEnabledBorder,
                        focusedBorder: minimalFocusedBorder,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _onSubmitPressed,
                      child: Text(
                        isLoading ? l10n.communitySaving : l10n.communitySave,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onPickImagesPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final remainingSlots =
        _maxCommunityImages - _remoteImageUrls.length - _selectedImages.length;
    if (remainingSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.communityImageLimitReached(_maxCommunityImages)),
        ),
      );
      return;
    }

    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (pickedFiles.isEmpty || !mounted) {
        return;
      }

      final selected = <_SelectedImage>[];
      for (final file in pickedFiles.take(remainingSlots)) {
        final extension = _extractExtension(file.name);
        if (!_allowedCommunityImageExtensions.contains(extension)) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.communityImageUnsupportedType)),
          );
          continue;
        }

        final fileLength = await file.length();
        if (fileLength > _maxCommunityImageBytes) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.communityImageTooLarge(8))),
          );
          continue;
        }

        final bytes = await file.readAsBytes();
        if (bytes.lengthInBytes > _maxCommunityImageBytes) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.communityImageTooLarge(8))),
          );
          continue;
        }

        selected.add(_SelectedImage(fileName: file.name, bytes: bytes));
      }

      if (!mounted || selected.isEmpty) {
        return;
      }

      setState(() {
        _selectedImages.addAll(selected);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityImagePickFailed)));
    }
  }

  Future<void> _onSubmitPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityContentRequired)));
      return;
    }
    if (_containsRestrictedTerms(content)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityContentRestricted)));
      return;
    }

    final imageUrls = List<String>.from(_remoteImageUrls);
    try {
      final storage = ref.read(storageServiceProvider);
      for (final image in _selectedImages) {
        final imageUrl = await storage.uploadCommunityImage(
          bytes: image.bytes,
          fileName: image.fileName,
        );
        imageUrls.add(imageUrl);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityImageUploadFailed)));
      return;
    }

    if (widget.isEditMode) {
      await ref
          .read(communityActionControllerProvider.notifier)
          .updatePost(
            postId: widget.postId!,
            content: content,
            imageUrls: imageUrls,
          );
    } else {
      await ref
          .read(communityActionControllerProvider.notifier)
          .createPost(content: content, imageUrls: imageUrls);
    }

    if (!mounted) {
      return;
    }

    if (!ref.read(communityActionControllerProvider).hasError) {
      if (widget.isEditMode) {
        final removedUrls = _initialRemoteImageUrls
            .where((url) => !imageUrls.contains(url))
            .toList(growable: false);
        for (final removedUrl in removedUrls) {
          try {
            await ref
                .read(storageServiceProvider)
                .removeCommunityMediaByPublicUrl(publicUrl: removedUrl);
          } catch (_) {}
        }
      }
      if (!mounted) {
        return;
      }
      navigator.pop();
    }
  }

  String _extractExtension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dot + 1).trim().toLowerCase();
  }

  bool _containsRestrictedTerms(String content) {
    final normalized = content.toLowerCase();
    for (final term in _restrictedCommunityTerms) {
      if (normalized.contains(term)) {
        return true;
      }
    }
    return false;
  }
}

class _CommunityImageChip extends StatelessWidget {
  const _CommunityImageChip({required this.image, required this.onRemove});

  final Widget image;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image,
            ),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedImage {
  const _SelectedImage({required this.fileName, required this.bytes});

  final String fileName;
  final Uint8List bytes;
}
