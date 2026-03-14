enum ProfileGender {
  male('male'),
  female('female'),
  other('other'),
  preferNotToSay('prefer_not_to_say');

  const ProfileGender(this.databaseValue);

  final String databaseValue;

  static ProfileGender? fromDatabaseValue(String? value) {
    for (final gender in values) {
      if (gender.databaseValue == value) {
        return gender;
      }
    }

    return null;
  }
}

class ProfileEntity {
  const ProfileEntity({
    this.fullName,
    this.avatarUrl,
    this.gender,
    this.onboardingCompleted = false,
    this.fallbackFullName,
    this.fallbackAvatarUrl,
  });

  final String? fullName;
  final String? avatarUrl;
  final ProfileGender? gender;
  final bool onboardingCompleted;
  final String? fallbackFullName;
  final String? fallbackAvatarUrl;

  String get normalizedFullName => fullName?.trim() ?? '';

  String get normalizedFallbackFullName => fallbackFullName?.trim() ?? '';

  String get displayName {
    if (normalizedFullName.isNotEmpty) {
      return normalizedFullName;
    }

    if (normalizedFallbackFullName.isNotEmpty) {
      return normalizedFallbackFullName;
    }

    return '-';
  }

  String get normalizedAvatarUrl => avatarUrl?.trim() ?? '';

  String get normalizedFallbackAvatarUrl => fallbackAvatarUrl?.trim() ?? '';

  String get displayAvatarUrl {
    if (normalizedAvatarUrl.isNotEmpty) {
      return normalizedAvatarUrl;
    }

    return normalizedFallbackAvatarUrl;
  }
}

class CompleteOnboardingParams {
  const CompleteOnboardingParams({required this.gender});

  final ProfileGender gender;
}

class UpdateProfileParams {
  const UpdateProfileParams({
    required this.fullName,
    required this.gender,
    this.avatarUrl,
  });

  final String fullName;
  final ProfileGender gender;
  final String? avatarUrl;
}
