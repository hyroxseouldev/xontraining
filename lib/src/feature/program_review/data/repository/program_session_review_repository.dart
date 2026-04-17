import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/program_review/data/datasource/program_session_review_data_source.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';

part 'program_session_review_repository.g.dart';

abstract interface class ProgramSessionReviewRepository {
  Future<List<ProgramSessionReviewEntity>> getMySessionReviewsByProgram({
    required String tenantId,
    required String programId,
  });

  Future<void> createMySessionReview({
    required String tenantId,
    required String programId,
    required String sessionId,
    required String completionNote,
  });

  Future<void> updateMySessionReview({
    required String id,
    required String tenantId,
    required String completionNote,
  });

  Future<List<CoachProgramSessionReviewEntity>> getCoachSessionReviews({
    required String tenantId,
    ProgramSessionReviewStatus? status,
  });

  Future<void> reviewSessionReview({
    required String id,
    required String tenantId,
    required String coachFeedback,
  });
}

class ProgramSessionReviewRepositoryImpl
    implements ProgramSessionReviewRepository {
  ProgramSessionReviewRepositoryImpl({required this.dataSource});

  final ProgramSessionReviewDataSource dataSource;

  static const _statusByValue = <String, ProgramSessionReviewStatus>{
    'submitted': ProgramSessionReviewStatus.submitted,
    'reviewed': ProgramSessionReviewStatus.reviewed,
  };

  @override
  Future<List<ProgramSessionReviewEntity>> getMySessionReviewsByProgram({
    required String tenantId,
    required String programId,
  }) async {
    try {
      final rows = await dataSource.getMySessionReviewsByProgram(
        tenantId: tenantId,
        programId: programId,
      );

      return rows
          .map(_mapReview)
          .whereType<ProgramSessionReviewEntity>()
          .toList(growable: false);
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] getMySessionReviewsByProgram auth failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] getMySessionReviewsByProgram unexpected failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load session reviews.',
        cause: error,
      );
    }
  }

  @override
  Future<void> createMySessionReview({
    required String tenantId,
    required String programId,
    required String sessionId,
    required String completionNote,
  }) async {
    try {
      await dataSource.createMySessionReview(
        tenantId: tenantId,
        programId: programId,
        sessionId: sessionId,
        completionNote: completionNote,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] createMySessionReview auth failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] createMySessionReview unexpected failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to submit session review.',
        cause: error,
      );
    }
  }

  @override
  Future<void> updateMySessionReview({
    required String id,
    required String tenantId,
    required String completionNote,
  }) async {
    try {
      await dataSource.updateMySessionReview(
        id: id,
        tenantId: tenantId,
        completionNote: completionNote,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] updateMySessionReview auth failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] updateMySessionReview unexpected failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to update session review.',
        cause: error,
      );
    }
  }

  @override
  Future<List<CoachProgramSessionReviewEntity>> getCoachSessionReviews({
    required String tenantId,
    ProgramSessionReviewStatus? status,
  }) async {
    try {
      final rows = await dataSource.getCoachSessionReviews(
        tenantId: tenantId,
        status: _statusValue(status),
      );
      final items = <CoachProgramSessionReviewEntity>[];

      for (final row in rows) {
        final review = _mapReview(row);
        final program = row['programs'];
        final session = row['sessions'];
        final memberProfile = row['member_profile'];
        final sessionDate = session is Map<String, dynamic>
            ? _asDateTime(session['session_date'])
            : null;
        final sessionTitle = session is Map<String, dynamic>
            ? session['title'] as String?
            : null;
        final programTitle = program is Map<String, dynamic>
            ? program['title'] as String?
            : null;
        if (review == null ||
            sessionDate == null ||
            sessionTitle == null ||
            programTitle == null) {
          continue;
        }

        items.add(
          CoachProgramSessionReviewEntity(
            review: review,
            programTitle: programTitle,
            sessionTitle: sessionTitle,
            sessionDate: DateTime(
              sessionDate.year,
              sessionDate.month,
              sessionDate.day,
            ),
            memberName: memberProfile is Map<String, dynamic>
                ? (memberProfile['full_name'] as String?) ?? ''
                : '',
            memberAvatarUrl: memberProfile is Map<String, dynamic>
                ? (memberProfile['avatar_url'] as String?) ?? ''
                : '',
          ),
        );
      }

      return items;
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] getCoachSessionReviews auth failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] getCoachSessionReviews unexpected failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load coach review queue.',
        cause: error,
      );
    }
  }

  @override
  Future<void> reviewSessionReview({
    required String id,
    required String tenantId,
    required String coachFeedback,
  }) async {
    try {
      await dataSource.reviewSessionReview(
        id: id,
        tenantId: tenantId,
        coachFeedback: coachFeedback,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] reviewSessionReview auth failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[ProgramSessionReviewRepository] reviewSessionReview unexpected failure: $error',
      );
      debugPrint('[ProgramSessionReviewRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to save coach feedback.',
        cause: error,
      );
    }
  }

  ProgramSessionReviewEntity? _mapReview(Map<String, dynamic> row) {
    final id = row['id'];
    final programId = row['program_id'];
    final sessionId = row['session_id'];
    final userId = row['user_id'];
    final completionNote = row['completion_note'];
    final statusValue = row['status'];
    final createdAt = _asDateTime(row['created_at']);
    final updatedAt = _asDateTime(row['updated_at']);
    final reviewerProfile = row['reviewer_profile'];
    if (id is! String ||
        programId is! String ||
        sessionId is! String ||
        userId is! String ||
        completionNote is! String ||
        statusValue is! String ||
        createdAt == null ||
        updatedAt == null) {
      return null;
    }

    final status = _statusByValue[statusValue];
    if (status == null) {
      return null;
    }

    final reviewedBy = row['reviewed_by'];

    return ProgramSessionReviewEntity(
      id: id,
      programId: programId,
      sessionId: sessionId,
      userId: userId,
      completionNote: completionNote,
      status: status,
      coachFeedback: (row['coach_feedback'] as String?) ?? '',
      reviewerName: reviewerProfile is Map<String, dynamic>
          ? (reviewerProfile['full_name'] as String?) ?? ''
          : '',
      reviewerAvatarUrl: reviewerProfile is Map<String, dynamic>
          ? (reviewerProfile['avatar_url'] as String?) ?? ''
          : '',
      reviewedBy: reviewedBy is String ? reviewedBy : null,
      reviewedAt: _asDateTime(row['reviewed_at']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  DateTime? _asDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  String? _statusValue(ProgramSessionReviewStatus? status) {
    if (status == null) {
      return null;
    }
    switch (status) {
      case ProgramSessionReviewStatus.submitted:
        return 'submitted';
      case ProgramSessionReviewStatus.reviewed:
        return 'reviewed';
    }
  }
}

@riverpod
ProgramSessionReviewRepository programSessionReviewRepository(Ref ref) {
  return ProgramSessionReviewRepositoryImpl(
    dataSource: ref.read(programSessionReviewDataSourceProvider),
  );
}
