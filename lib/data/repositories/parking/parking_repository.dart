import 'package:john_parking/data/models/parking_space_model.dart';
import 'package:john_parking/data/models/response_model.dart';
import 'package:john_parking/data/models/vacancy_model.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import 'package:john_parking/shared/errors/custom_error.dart';
import 'package:john_parking/shared/utils/custom_logger.dart';

import '../../../shared/utils/constants.dart';
import '../../database/database_provider.dart';

class ParkingRepository implements IParkingRepository {
  final DatabaseProvider _dbProvider;

  ParkingRepository(this._dbProvider);

  @override
  Future<ResponseModel<List<ParkingSpaceModel>, CustomException>> getAllParkingSpace() async {
    try {
      final db = await _dbProvider.database;

      final response = await db.rawQuery('''
          SELECT a.id,a.${ConstantsApp.columnVacancyIdVacancy},b.${ConstantsApp.columnDescriptionVacancy},
          b.${ConstantsApp.columnLicensePlateVacancy},b.${ConstantsApp.columnEntryTimeVacancy},
          b.${ConstantsApp.columnDepartureTimeVacancy},b.${ConstantsApp.columnParkingSpaceIdVacancy}
          FROM ${ConstantsApp.tableParkingSpace} AS a
          LEFT JOIN ${ConstantsApp.tableVacancy} AS b
          ON a.vacancyId == b.id
      ''');

      final listParkingSpace = response.map(
        (item) {
          return ParkingSpaceModel(
            id: item['id'] as int,
            vacancyModel: item[ConstantsApp.columnVacancyIdVacancy] == null
                ? null
                : VacancyModel(
                    id: item[ConstantsApp.columnVacancyIdVacancy] as int?,
                    description: item[ConstantsApp.columnDescriptionVacancy] as String,
                    licensePlate: item[ConstantsApp.columnLicensePlateVacancy] as String,
                    entryTime: DateTime.fromMillisecondsSinceEpoch(item[ConstantsApp.columnEntryTimeVacancy] as int),
                    departureTime: item[ConstantsApp.columnDepartureTimeVacancy] != null
                        ? DateTime.fromMillisecondsSinceEpoch(item[ConstantsApp.columnDepartureTimeVacancy] as int)
                        : null,
                    parkingSpaceId: item[ConstantsApp.columnParkingSpaceIdVacancy] as int,
                  ),
          );
        },
      ).toList();

      return ResponseModel(data: listParkingSpace);
    } catch (e, s) {
      LoggerApp.error('[Error on getAllParkingSpace]', e, s);
      return ResponseModel(
        error: CustomException(
          message: 'Erro ao retornar as vagas, verifique e tente novamente.',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<ResponseModel<ParkingSpaceModel, CustomException>> saveParkingSpace(ParkingSpaceModel parking) async {
    try {
      final db = await _dbProvider.database;

      final int id = await db.transaction<int>((txn) async {
        final insertId = await txn.insert(ConstantsApp.tableVacancy, parking.vacancyModel!.toMap());
        await txn.update(ConstantsApp.tableParkingSpace, {ConstantsApp.columnVacancyIdVacancy: insertId},
            where: 'id = ?', whereArgs: [parking.id]);
        return insertId;
      });

      final VacancyModel updatedVacancy = parking.vacancyModel!.copyWith(id: id);
      final ParkingSpaceModel updatedParkingSpace = parking.copyWith(vacancyModel: updatedVacancy);

      return ResponseModel(data: updatedParkingSpace);
    } catch (e, s) {
      LoggerApp.error('[Error on saveParkingSpace]', e, s);
      return ResponseModel(
        error: CustomException(
          message: 'Erro ao salvar reserva, verifique e tente novamente.',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<ResponseModel<void, CustomException>> removeParkingSpace(ParkingSpaceModel parking) async {
    try {
      final db = await _dbProvider.database;

      await db.transaction<void>((txn) async {
        await txn.update(
            ConstantsApp.tableVacancy, parking.vacancyModel!.copyWith(departureTime: DateTime.now()).toMap(),
            where: 'id = ?', whereArgs: [parking.vacancyModel!.id!]);

        await txn.update(ConstantsApp.tableParkingSpace, {ConstantsApp.columnVacancyIdVacancy: null},
            where: 'id = ?', whereArgs: [parking.id]);
      });

      return ResponseModel();
    } catch (e, s) {
      LoggerApp.error('[Error on removeParkingSpace]', e, s);
      return ResponseModel(
        error: CustomException(
          message: 'Erro ao finalizar reserva, verifique e tente novamente.',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<ResponseModel<List<VacancyModel>, CustomException>> getHistoricParkingByPeriod(
      {required DateTime initDate, required DateTime endDate}) async {
    try {
      final DateTime initialDateFormatted = DateTime(initDate.year, initDate.month, initDate.day);
      final DateTime endDateFormatted = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);

      final db = await _dbProvider.database;

      final response = await db.rawQuery('''
          SELECT * FROM ${ConstantsApp.tableVacancy}
          WHERE (${ConstantsApp.columnEntryTimeVacancy} >= ${initialDateFormatted.millisecondsSinceEpoch}
               AND ${ConstantsApp.columnDepartureTimeVacancy} IS NULL
               AND ${ConstantsApp.columnEntryTimeVacancy} <= ${endDateFormatted.millisecondsSinceEpoch})
               OR (${ConstantsApp.columnEntryTimeVacancy} >= ${initialDateFormatted.millisecondsSinceEpoch}
                  AND ${ConstantsApp.columnDepartureTimeVacancy} IS NOT NULL
                  AND ${ConstantsApp.columnDepartureTimeVacancy} <= ${endDateFormatted.millisecondsSinceEpoch})
      ''');

      return ResponseModel(data: response.map((e) => VacancyModel.fromMap(e)).toList());
    } catch (e, s) {
      LoggerApp.error('[Error on getHistoricParkingByPeriod]', e, s);
      return ResponseModel(
          error: CustomException(
        message: 'Erro ao filtrar histórico, verifique e tente novamente.',
        exception: e,
        stackTrace: s,
      ));
    }
  }
}
