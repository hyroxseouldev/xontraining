import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/onboarding_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  ProfileGender? _selectedGender;

  Future<void> _onContinuePressed() async {
    final l10n = AppLocalizations.of(context)!;
    final gender = _selectedGender;
    if (gender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.onboardingGenderRequired)));
      return;
    }

    final success = await ref
        .read(onboardingControllerProvider.notifier)
        .completeOnboarding(gender: gender);

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.onboardingSaveFailed)));
      return;
    }

    context.goNamed(AppRoutes.homeName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<ProfileGender>(
                initialValue: _selectedGender,
                decoration: InputDecoration(
                  labelText: l10n.onboardingGenderLabel,
                  hintText: l10n.onboardingGenderHint,
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                ),
                items: ProfileGender.values.map((gender) {
                  return DropdownMenuItem<ProfileGender>(
                    value: gender,
                    child: Text(_genderLabel(l10n, gender)),
                  );
                }).toList(),
                onChanged: onboardingState.isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onboardingState.isLoading
                      ? null
                      : _onContinuePressed,
                  child: Text(
                    onboardingState.isLoading
                        ? l10n.onboardingSaving
                        : l10n.onboardingContinue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _genderLabel(AppLocalizations l10n, ProfileGender gender) {
    return switch (gender) {
      ProfileGender.male => l10n.genderMale,
      ProfileGender.female => l10n.genderFemale,
      ProfileGender.other => l10n.genderOther,
      ProfileGender.preferNotToSay => l10n.genderPreferNotToSay,
    };
  }
}
