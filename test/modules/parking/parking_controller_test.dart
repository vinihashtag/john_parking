import 'package:flutter_test/flutter_test.dart';
import 'package:john_parking/data/models/response_model.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import 'package:john_parking/modules/parking/parking_controller.dart';
import 'package:john_parking/shared/errors/custom_error.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/class_fake.dart';
import '../../mocks/class_mocks.dart';
import '../../mocks/parking_space_mock.dart';

void main() {
  late IParkingRepository parkingRepository;
  late ParkingController controller;

  setUp(() {
    registerFallbackValue(ParkingSpaceFake());
    parkingRepository = ParkingRepositoryMock();
    controller = ParkingController(parkingRepository);
  });
  group('[GET LIST OF PARKING SPACE]', () {
    test('should returns a list of parking space', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listParkingSpace));

      //Act
      await controller.getListParkingSpace();

      //Assert
      expect(controller.listParkingSpace.isNotEmpty, true);
      expect(controller.statusParkingSpace.isSuccess, true);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
    });

    test('should returns a exception when an error occurs in the database', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(error: CustomException()));

      //Act
      await controller.getListParkingSpace();

      //Assert
      expect(controller.listParkingSpace.isEmpty, true);
      expect(controller.statusParkingSpace.isFailure, true);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
    });
  });

  group('[SAVE PARKING SPACE]', () {
    test('should saves a parking space', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listParkingSpace));
      when(() => parkingRepository.saveParkingSpace(any()))
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.existParkingSpace));

      //Act
      await controller.getListParkingSpace();
      final response = await controller.createParkingReservation(ParkingSpaceMock.listParkingSpace.last);

      //Assert
      expect(response.isSuccess, true);
      expect(controller.listParkingSpace.isNotEmpty, true);
      expect(controller.statusParkingSpace.isSuccess, true);
      expect(controller.listParkingSpace.last.vacancyModel?.id != null, true);
      expect(controller.listParkingSpace.last.vacancyModel?.parkingSpaceId, ParkingSpaceMock.existParkingSpace.id);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
      verify(() => parkingRepository.saveParkingSpace(any())).called(1);
    });

    test('should returns a exception when an error occurs in the database', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listParkingSpace));
      when(() => parkingRepository.saveParkingSpace(any()))
          .thenAnswer((_) async => ResponseModel(error: CustomException()));

      //Act
      await controller.getListParkingSpace();
      final response = await controller.createParkingReservation(ParkingSpaceMock.listParkingSpace.last);

      //Assert
      expect(response.isError, true);
      expect(controller.listParkingSpace.isNotEmpty, true);
      expect(controller.statusParkingSpace.isSuccess, true);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
      verify(() => parkingRepository.saveParkingSpace(any())).called(1);
    });
  });

  group('[REMOVE PARKING SPACE]', () {
    test('should removes a vacancy on parking space', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listParkingSpace));
      when(() => parkingRepository.saveParkingSpace(any())).thenAnswer((_) async => ResponseModel(
          data: ParkingSpaceMock.existParkingSpace.copyWith(id: ParkingSpaceMock.listParkingSpace.last.id)));
      when(() => parkingRepository.removeParkingSpace(any())).thenAnswer((_) async => ResponseModel());

      //Act
      await controller.getListParkingSpace();
      await controller.createParkingReservation(ParkingSpaceMock.listParkingSpace.last);
      final response = await controller.finalizeParkingReservation(controller.listParkingSpace.last);

      //Assert
      expect(response.isSuccess, true);
      expect(controller.listParkingSpace.isNotEmpty, true);
      expect(controller.statusParkingSpace.isSuccess, true);
      expect(controller.listParkingSpace.last.vacancyModel, null);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
      verify(() => parkingRepository.saveParkingSpace(any())).called(1);
      verify(() => parkingRepository.removeParkingSpace(any())).called(1);
    });

    test('should returns a exception when an error occurs in the database', () async {
      //Arrange
      when(() => parkingRepository.getAllParkingSpace())
          .thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listParkingSpace));
      when(() => parkingRepository.saveParkingSpace(any())).thenAnswer((_) async => ResponseModel(
          data: ParkingSpaceMock.existParkingSpace.copyWith(id: ParkingSpaceMock.listParkingSpace.last.id)));
      when(() => parkingRepository.removeParkingSpace(any()))
          .thenAnswer((_) async => ResponseModel(error: CustomException()));

      //Act
      await controller.getListParkingSpace();
      await controller.createParkingReservation(ParkingSpaceMock.listParkingSpace.last);
      final response = await controller.finalizeParkingReservation(controller.listParkingSpace.last);

      //Assert
      expect(response.isError, true);
      expect(controller.listParkingSpace.isNotEmpty, true);
      expect(controller.statusParkingSpace.isSuccess, true);
      expect(controller.listParkingSpace.last.vacancyModel != null, true);
      verify(() => parkingRepository.getAllParkingSpace()).called(1);
      verify(() => parkingRepository.saveParkingSpace(any())).called(1);
      verify(() => parkingRepository.removeParkingSpace(any())).called(1);
    });
  });

  group('[GET HISTORIC]', () {
    test('should returns a historic list of vacancies', () async {
      //Arrange
      when(() => parkingRepository.getHistoricParkingByPeriod(
          initDate: any(named: 'initDate'),
          endDate: any(named: 'endDate'))).thenAnswer((_) async => ResponseModel(data: ParkingSpaceMock.listVancacy));

      //Act
      await controller.filterHistoric();

      //Assert
      expect(controller.listVacancy.isNotEmpty, true);
      expect(controller.statusHistoric.isSuccess, true);
      verify(() => parkingRepository.getHistoricParkingByPeriod(
          initDate: any(named: 'initDate'), endDate: any(named: 'endDate'))).called(1);
    });

    test('should returns a exception when an error occurs in the database', () async {
      //Arrange
      when(() => parkingRepository.getHistoricParkingByPeriod(
          initDate: any(named: 'initDate'),
          endDate: any(named: 'endDate'))).thenAnswer((_) async => ResponseModel(error: CustomException()));

      //Act
      await controller.filterHistoric();

      //Assert
      expect(controller.listVacancy.isEmpty, true);
      expect(controller.statusHistoric.isFailure, true);
      verify(() => parkingRepository.getHistoricParkingByPeriod(
          initDate: any(named: 'initDate'), endDate: any(named: 'endDate'))).called(1);
    });
  });
}
