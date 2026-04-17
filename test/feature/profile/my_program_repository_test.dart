import 'package:flutter_test/flutter_test.dart';
import 'package:xontraining/src/feature/profile/data/datasource/my_program_data_source.dart';
import 'package:xontraining/src/feature/profile/data/repository/my_program_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';

void main() {
  group('MyProgramRepositoryImpl', () {
    test('active tab returns all currently valid entitlements', () async {
      final repository = MyProgramRepositoryImpl(
        dataSource: _FakeMyProgramDataSource(
          activeProgramId: 'program-active',
          rows: [
            _row(programId: 'program-active'),
            _row(programId: 'program-unselected'),
            _row(programId: 'program-expired', endsAt: '2000-03-01T00:00:00Z'),
          ],
        ),
      );

      final result = await repository.getMyProgramsPage(
        tenantId: 'tenant-id',
        userId: 'user-id',
        status: MyProgramStatus.active,
        limit: 10,
        offset: 0,
      );

      expect(result.items.map((item) => item.program.id), [
        'program-active',
        'program-unselected',
      ]);
      expect(result.totalCount, 2);
    });

    test(
      'inactive tab returns expired future and disabled entitlements only',
      () async {
        final repository = MyProgramRepositoryImpl(
          dataSource: _FakeMyProgramDataSource(
            activeProgramId: 'program-active',
            rows: [
              _row(programId: 'program-active'),
              _row(programId: 'program-unselected'),
              _row(
                programId: 'program-expired',
                endsAt: '2000-03-01T00:00:00Z',
              ),
              _row(
                programId: 'program-future',
                startsAt: '2099-05-01T00:00:00Z',
                endsAt: '2099-06-01T00:00:00Z',
              ),
              _row(programId: 'program-disabled', isActive: false),
            ],
          ),
        );

        final result = await repository.getMyProgramsPage(
          tenantId: 'tenant-id',
          userId: 'user-id',
          status: MyProgramStatus.inactive,
          limit: 10,
          offset: 0,
        );

        expect(result.items.map((item) => item.program.id), [
          'program-expired',
          'program-future',
          'program-disabled',
        ]);
        expect(result.totalCount, 3);
      },
    );

    test('deduplicates by program id using latest entitlement row', () async {
      final repository = MyProgramRepositoryImpl(
        dataSource: _FakeMyProgramDataSource(
          activeProgramId: 'program-active',
          rows: [
            _row(
              programId: 'program-disabled',
              isActive: false,
              startsAt: '2099-03-10T00:00:00Z',
            ),
            _row(
              programId: 'program-disabled',
              isActive: true,
              startsAt: '2000-01-01T00:00:00Z',
            ),
          ],
        ),
      );

      final result = await repository.getMyProgramsPage(
        tenantId: 'tenant-id',
        userId: 'user-id',
        status: MyProgramStatus.inactive,
        limit: 10,
        offset: 0,
      );

      expect(result.items.map((item) => item.program.id), ['program-disabled']);
      expect(result.items.single.isEntitlementActive, isFalse);
    });
  });
}

Map<String, dynamic> _row({
  required String programId,
  bool isActive = true,
  String startsAt = '2020-03-01T00:00:00Z',
  String? endsAt = '2100-04-01T00:00:00Z',
}) {
  return {
    'program_id': programId,
    'is_active': isActive,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'programs': {
      'id': programId,
      'title': 'Program $programId',
      'description': 'Description $programId',
      'thumbnail_url': '',
      'difficulty': 'beginner',
      'daily_workout_minutes': 40,
      'days_per_week': 3,
      'start_date': '2020-03-01T00:00:00Z',
      'end_date': '2100-04-01T00:00:00Z',
      'created_at': '2020-02-01T00:00:00Z',
    },
  };
}

class _FakeMyProgramDataSource implements MyProgramDataSource {
  _FakeMyProgramDataSource({required this.activeProgramId, required this.rows});

  final String? activeProgramId;
  final List<Map<String, dynamic>> rows;

  @override
  Future<String?> getActiveProgramId({
    required String tenantId,
    required String userId,
  }) async {
    return activeProgramId;
  }

  @override
  Future<List<Map<String, dynamic>>> getAccessibleProgramEntitlements({
    required String tenantId,
    required String userId,
  }) async {
    return rows;
  }
}
