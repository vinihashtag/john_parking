import 'package:flutter_test/flutter_test.dart';
import 'package:john_parking/data/database/database_provider.dart';
import 'package:john_parking/data/repositories/parking/parking_repository.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import 'package:john_parking/shared/errors/custom_error.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import '../../../mocks/class_mocks.dart';
import '../../../mocks/parking_space_mock.dart';

void main() {
  late Database db;
  late DatabaseProvider databaseProvider;
  late IParkingRepository parkingRepository;

  setUp(() {
    db = DatabaseMock();
    databaseProvider = DatabaseProviderMock();
    parkingRepository = ParkingRepository(databaseProvider);
  });

  group('[GET ALL PARKING SPACE]', () {
    test('should returns a list of parking space', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenAnswer((_) async => ParkingSpaceMock.listParkingSpaceMap);

      //Act
      final response = await parkingRepository.getAllParkingSpace();

      //Assert
      expect(response.isSuccess, true);
      expect(response.data!.length, ParkingSpaceMock.listParkingSpaceMap.length);
      verify(() => databaseProvider.database).called(1);
      verify(() => db.rawQuery(any())).called(1);
    });

    test('should returns a empty list of parking space', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenAnswer((_) async => []);

      //Act
      final response = await parkingRepository.getAllParkingSpace();

      //Assert
      expect(response.isSuccess, true);
      expect(response.data!.isEmpty, true);
      verify(() => databaseProvider.database).called(1);
      verify(() => db.rawQuery(any())).called(1);
    });

    test('should returns a exception when an error occurs in the local database', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenThrow(Exception('Error on database'));

      //Act
      final response = await parkingRepository.getAllParkingSpace();

      //Assert
      expect(response.isError, true);
      expect(response.error is CustomException, true);
      verify(() => databaseProvider.database).called(1);
      verify(() => db.rawQuery(any())).called(1);
    });
  });

  group('[SAVE PARKING SPACE]', () {
    test('should saves a parking space', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.transaction<int>(any())).thenAnswer((_) async => 1);

      //Act
      final response = await parkingRepository.saveParkingSpace(ParkingSpaceMock.newParkingSpace);

      //Assert
      expect(response.isSuccess, true);
      expect(response.data!.vacancyModel!.id != null, true);
      expect(response.data!.vacancyModel!.id, 1);
      verify(() => db.transaction<int>(any())).called(1);
    });

    test('should returns a exception when an error occurs in the local database', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.transaction<int>(any())).thenThrow(Exception('Error on database'));

      //Act
      final response = await parkingRepository.saveParkingSpace(ParkingSpaceMock.newParkingSpace);

      //Assert
      expect(response.isError, true);
      expect(response.error is CustomException, true);
      verify(() => db.transaction<int>(any())).called(1);
    });
  });

  group('[REMOVE PARKING SPACE]', () {
    test('should removes a vacancy of the parking space', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.transaction<void>(any())).thenAnswer((_) => Future.value());

      //Act
      final response = await parkingRepository.removeParkingSpace(ParkingSpaceMock.existParkingSpace);

      //Assert
      expect(response.isError, false);
      verify(() => db.transaction<void>(any())).called(1);
    });

    test('should returns a exception when an error occurs in the local database', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.transaction<void>(any())).thenThrow(Exception('Error on database'));

      //Act
      final response = await parkingRepository.removeParkingSpace(ParkingSpaceMock.newParkingSpace);

      //Assert
      expect(response.isError, true);
      expect(response.error is CustomException, true);
      verify(() => db.transaction<void>(any())).called(1);
    });
  });

  group('[GET HISTORIC PARKING]', () {
    test('should returns a list of vacancy by filter date initial and date final', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenAnswer((_) async => ParkingSpaceMock.listVancacyMap);

      //Act
      final response = await parkingRepository.getHistoricParkingByPeriod(
          initDate: DateTime.now().subtract(const Duration(days: 1)), endDate: DateTime.now());

      //Assert
      expect(response.isSuccess, true);
      expect(response.data!.isNotEmpty, true);
      verify(() => db.rawQuery(any())).called(1);
    });

    test('should returns a empty list of vacancy by filter when filtering current records by lower date', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenAnswer((_) async => []);

      //Act
      final response = await parkingRepository.getHistoricParkingByPeriod(
        initDate: DateTime.now().subtract(const Duration(days: 3)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      //Assert
      expect(response.isSuccess, true);
      expect(response.data!.isEmpty, true);
      verify(() => db.rawQuery(any())).called(1);
    });

    test('should returns a exception when an error occurs in the local database', () async {
      //Arrange
      when(() => databaseProvider.database).thenAnswer((_) async => db);
      when(() => db.rawQuery(any())).thenThrow(Exception('Error on database'));

      //Act
      final response = await parkingRepository.getHistoricParkingByPeriod(
          initDate: DateTime.now().subtract(const Duration(days: 1)), endDate: DateTime.now());

      //Assert
      expect(response.isError, true);
      expect(response.error is CustomException, true);
      verify(() => db.rawQuery(any())).called(1);
    });
  });
}
