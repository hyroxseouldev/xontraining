# AGENTS.md
Guidance for coding agents working in this repository.

## Project Snapshot
- Stack: Flutter + Dart, Riverpod, GoRouter, Supabase, Google Sign-In.
- Flutter SDK is pinned via FVM (`.fvmrc`): `3.38.9`.
- Localization is enabled (`flutter: generate: true`, `l10n.yaml`).
- Environment variables are loaded via `envied` from `.env`.
- Current codebase is app-focused with a minimal widget test suite.

## Rule Sources
- Primary source of truth: this `AGENTS.md`.
- Also follow project-level Claude guidance already injected for agents.
- Cursor rules:
  - `.cursor/rules/`: not found.
  - `.cursorrules`: not found.
- Copilot rules:
  - `.github/copilot-instructions.md`: not found.

## Setup Commands
- Install dependencies: `fvm flutter pub get`
- Verify toolchain: `fvm flutter --version`
- Generate l10n: `fvm flutter gen-l10n`
- Generate code (envied/riverpod): `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- Watch codegen: `fvm flutter pub run build_runner watch --delete-conflicting-outputs`

## Build and Run Commands
- Run app: `fvm flutter run`
- Run on Chrome: `fvm flutter run -d chrome`
- Build APK: `fvm flutter build apk`
- Build iOS (macOS): `fvm flutter build ios`
- Build macOS: `fvm flutter build macos`

## Lint, Format, and Analysis
- Analyze: `fvm flutter analyze`
- Format all Dart files: `fvm dart format .`
- CI formatting check: `fvm dart format --output=none --set-exit-if-changed .`

## Test Commands
- Run all tests: `fvm flutter test`
- Run one test file: `fvm flutter test test/widget_test.dart`
- Run one test by name (preferred first step):
  - `fvm flutter test test/widget_test.dart --plain-name "Login screen is shown"`
- Machine output mode: `fvm flutter test --machine`

## Test Execution Strategy
- Start with the smallest scope (single test name) before broader suites.
- If a named test passes, run the containing file next.
- Run full test suite only after local file-level confidence is good.
- When fixing regressions, add or update targeted tests near the changed feature.

## Environment Variable Guidance
- Required keys are documented in `.env.example`.
- App reads env via `lib/src/core/config/env/env.dart` (`envied`).
- After env schema changes, regenerate code with build_runner.
- Never paste real credentials into issues, logs, or committed fixtures.

## Recommended Pre-PR Validation
- `fvm flutter pub get`
- `fvm flutter gen-l10n` (if ARB changed)
- `fvm flutter pub run build_runner build --delete-conflicting-outputs` (if annotations changed)
- `fvm dart format .`
- `fvm flutter analyze`
- `fvm flutter test`

## Files and Codegen Rules
- Never manually edit generated files:
  - `*.g.dart`
  - `*.freezed.dart`
  - Generated files under `lib/l10n/`
- Keep real secrets out of git:
  - Do not commit `.env` with production values.
  - Use `.env.example` as the required variable template.

## Import Conventions
- Prefer absolute package imports in `lib/`:
  - Use `package:xontraining/...` (not relative imports).
- Keep imports grouped in this order:
  1) Dart SDK (`dart:*`)
  2) Flutter/framework (`package:flutter/*`)
  3) Third-party packages
  4) Local package imports (`package:xontraining/*`)
- Remove unused imports immediately.

## Formatting and Readability
- Follow `flutter_lints` from `analysis_options.yaml`.
- Use trailing commas for multi-line constructors/arguments.
- Prefer small, composable widgets over large nested trees.
- Use `const` constructors/widgets whenever possible.
- Extract helper methods/widgets when build methods become deeply nested.

## Widget Computation Rules
- Keep widgets presentation-focused; do not place business/derived calculations in widget files.
- Move derived domain values (normalization, duration calculations, etc.) to Entity getters or UseCase logic.
- Widgets should only format localized strings and render values that are already prepared by upper layers.

## Network Image Rule
- For network images in app UI, use `CachedNetworkImage` instead of `Image.network`.
- Always provide both `placeholder` and `errorWidget` states.

## Types and API Design
- Avoid `dynamic` unless required by external APIs.
- Prefer explicit return types on public methods/functions.
- Prefer `final`; use `var` only when mutable and obvious.
- Keep provider/service APIs narrow and intention-revealing.
- Favor immutable models/patterns where practical.

## Naming Conventions
- Classes/types: `PascalCase`.
- Variables/methods/functions: `camelCase`.
- Constants: project currently uses `lowerCamelCase` with `const`.
- Riverpod providers must end with `Provider`.
- Route constants should live in a dedicated route constants class (`AppRoutes`).
- Test names should be behavior-oriented and readable.

## Error Handling
- Catch errors only when you can add context or recover.
- Preserve stack traces with `rethrow` when propagating exceptions.
- Manage debug logs in Repository layer (not View/DataSource) for consistency.
- App-wide exceptions must be represented as Freezed models under `lib/src/core/exception/`.
- In async UI callbacks, guard state updates with `if (!mounted) return;`.
- User-facing error messages must be localized.

## State Management and Layering
- Use Riverpod (`hooks_riverpod`) for dependency/state access.
- Prefer Riverpod annotation/generator workflow (`riverpod_annotation`, `riverpod_generator`) for new providers/controllers.
- Access shared dependencies via providers rather than ad-hoc singletons.
- Keep side effects in services/providers, not deep in widget trees.
- Keep presentation code focused on rendering and interactions.
- Router refresh should be driven by auth stream/listenable.
- In stateful UI scenarios, consider hooks-first (`HookWidget`/`HookConsumerWidget`) before introducing `StatefulWidget`.

## Localization Rules (Hard Requirement)
- Never hard-code user-facing strings in widgets.
- Always use `AppLocalizations.of(context)!...`.
- When adding strings:
  - Add keys to both `lib/l10n/app_en.arb` and `lib/l10n/app_ko.arb`.
  - Run `fvm flutter gen-l10n`.
- For date/number formatting use runtime locale:
  - `final locale = Localizations.localeOf(context);`

## AsyncValue UI Rule
- Preferred project pattern: shared `AsyncWidget` wrapper for `AsyncValue` states.
- Avoid ad-hoc `AsyncValue.when(...)` in feature UI code.
- If `AsyncWidget` is missing in this snapshot, keep this as a forward rule.
- For one-off UI feedback (e.g., `SnackBar`) from provider state changes, use `ref.listen(...)` rather than inline imperative calls from async handlers.

## Data Layer Rule for Feature Work
- Preserve layering when implementing features:
  1) View/Widget: presentation only
  2) Controller (Riverpod provider/notifier): state exposure and UI event orchestration
  3) UseCase: business orchestration
  4) Repository: entity mapping + domain-facing interfaces
  5) DataSource: raw Supabase I/O + DTOs
- Do not expose DTOs to presentation layers.
- Do not skip layers in new feature implementations.
- Dependencies below Controller are generally stable; prefer `ref.read(...)` over `ref.watch(...)` in those layers to avoid unnecessary rebuilds/recomputations.

## Agent Execution Notes
- Prefer `fvm flutter ...` and `fvm dart ...` over global binaries.
- Run the narrowest command first (single test > file > full suite).
- Avoid unrelated refactors when handling focused requests.
- If ARB/annotations/generated bindings are touched, run required generators.
