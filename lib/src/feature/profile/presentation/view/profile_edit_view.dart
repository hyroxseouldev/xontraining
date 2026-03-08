import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

const int _maxAvatarBytes = 3 * 1024 * 1024;
const Set<String> _allowedAvatarExtensions = <String>{
  'jpg',
  'jpeg',
  'png',
  'webp',
};

class ProfileEditView extends ConsumerStatefulWidget {
  const ProfileEditView({super.key});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  late final TextEditingController _nameController;
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _selectedAvatarBytes;
  String? _selectedAvatarFileName;
  bool _didHydrateName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onPickImagePressed() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 90,
      );

      if (pickedFile == null) {
        return;
      }

      final extension = _extractExtension(pickedFile.name);
      if (!_allowedAvatarExtensions.contains(extension)) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileEditImageUnsupportedType)),
        );
        return;
      }

      final fileLength = await pickedFile.length();
      if (fileLength > _maxAvatarBytes) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileEditImageTooLarge(3))),
        );
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      if (bytes.lengthInBytes > _maxAvatarBytes) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileEditImageTooLarge(3))),
        );
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedAvatarBytes = bytes;
        _selectedAvatarFileName = pickedFile.name;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileEditImagePickFailed)));
    }
  }

  Future<void> _onSavePressed() async {
    final l10n = AppLocalizations.of(context)!;
    final fullName = _nameController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileNameRequired)));
      return;
    }

    final success = await ref
        .read(profileControllerProvider.notifier)
        .saveProfile(
          fullName: fullName,
          avatarBytes: _selectedAvatarBytes,
          avatarFileName: _selectedAvatarFileName,
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileSaveFailed)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.profileSaveSuccess)));
    Navigator.of(context).pop();
  }

  String _extractExtension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return '';
    }

    return fileName.substring(dot + 1).trim().toLowerCase();
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
    final session = ref.watch(authSessionProvider);
    final profileState = ref.watch(profileControllerProvider);
    final fullNameState = ref.watch(profileFullNameProvider);
    final avatarUrl = ref.watch(profileAvatarUrlProvider).asData?.value ?? '';

    fullNameState.whenData((fullName) {
      if (_didHydrateName) {
        return;
      }

      _nameController.text = fullName;
      _didHydrateName = true;
    });

    final email = session.asData?.value?.email ?? '-';

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
                l10n.profileEditTitle,
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: _EditableAvatar(
                currentAvatarUrl: avatarUrl,
                selectedAvatarBytes: _selectedAvatarBytes,
                onPickImagePressed: profileState.isLoading
                    ? null
                    : _onPickImagePressed,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: profileState.isLoading ? null : _onPickImagePressed,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.profileEditChangePhoto),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.profileNameLabel,
                hintText: l10n.profileNameHint,
                filled: false,
                enabledBorder: minimalEnabledBorder,
                focusedBorder: minimalFocusedBorder,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.profileSignedInAs(email),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: profileState.isLoading ? null : _onSavePressed,
              child: Text(
                profileState.isLoading ? l10n.profileSaving : l10n.profileSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({
    required this.currentAvatarUrl,
    required this.selectedAvatarBytes,
    required this.onPickImagePressed,
  });

  final String currentAvatarUrl;
  final Uint8List? selectedAvatarBytes;
  final VoidCallback? onPickImagePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 112,
          height: 112,
          child: ClipOval(child: _buildAvatarImage(context)),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPickImagePressed,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage(BuildContext context) {
    if (selectedAvatarBytes != null) {
      return Image.memory(selectedAvatarBytes!, fit: BoxFit.cover);
    }

    if (currentAvatarUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: currentAvatarUrl,
        fit: BoxFit.cover,
        placeholder: (context, imageUrl) => _avatarFallback(context),
        errorWidget: (context, imageUrl, error) => _avatarFallback(context),
      );
    }

    return _avatarFallback(context);
  }

  Widget _avatarFallback(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      child: Icon(
        Icons.person,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
