import 'package:john_parking/data/models/parking_space_model.dart';
import 'package:john_parking/data/models/response_model.dart';
import 'package:john_parking/data/repositories/parking/parking_repository.dart';
import 'package:john_parking/shared/errors/custom_error.dart';
import 'package:mocktail/mocktail.dart';

import 'parking_space_mock.dart';

class ParkingSpaceFake extends Fake implements ParkingSpaceModel {}

class ParkingRepositoryFake extends Fake implements ParkingRepository {
  @override
  Future<ResponseModel<List<ParkingSpaceModel>, CustomException>> getAllParkingSpace() async {
    return ResponseModel(data: ParkingSpaceMock.listParkingSpace);
  }

  @override
  Future<ResponseModel<ParkingSpaceModel, CustomException>> saveParkingSpace(ParkingSpaceModel parking) async {
    return ResponseModel(data: ParkingSpaceMock.existParkingSpace);
  }

  @override
  Future<ResponseModel<void, CustomException>> removeParkingSpace(ParkingSpaceModel parking) async {
    return ResponseModel();
  }
}

class ParkingRepositoryEmptyFake extends Fake implements ParkingRepository {
  @override
  Future<ResponseModel<List<ParkingSpaceModel>, CustomException>> getAllParkingSpace() async {
    return ResponseModel(data: []);
  }
}

class ParkingRepositoryFailureFake extends Fake implements ParkingRepository {
  @override
  Future<ResponseModel<List<ParkingSpaceModel>, CustomException>> getAllParkingSpace() async {
    return ResponseModel(error: CustomException());
  }
}
