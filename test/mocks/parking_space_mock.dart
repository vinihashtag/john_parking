import 'package:john_parking/data/models/parking_space_model.dart';
import 'package:john_parking/data/models/vacancy_model.dart';

class ParkingSpaceMock {
  ParkingSpaceMock._();

  static ParkingSpaceModel newParkingSpace = ParkingSpaceModel(
    id: 1,
    vacancyModel: VacancyModel(
      description: 'description',
      licensePlate: 'licensePlate',
      entryTime: DateTime.now(),
      parkingSpaceId: 1,
    ),
  );

  static ParkingSpaceModel existParkingSpace = ParkingSpaceModel(
    id: 1,
    vacancyModel: VacancyModel(
      id: 1,
      description: 'description',
      licensePlate: 'licensePlate',
      entryTime: DateTime.now(),
      parkingSpaceId: 1,
    ),
  );

  static List<ParkingSpaceModel> get listParkingSpace => [
        ParkingSpaceModel(id: 1),
        ParkingSpaceModel(
          id: 2,
          vacancyModel: VacancyModel(
            description: 'description',
            licensePlate: 'licensePlate',
            entryTime: DateTime.now(),
            parkingSpaceId: 2,
          ),
        ),
        ParkingSpaceModel(id: 3),
        ParkingSpaceModel(id: 4),
        ParkingSpaceModel(
          id: 5,
          vacancyModel: VacancyModel(
            description: 'description2',
            licensePlate: 'licensePlate2',
            entryTime: DateTime.now(),
            departureTime: DateTime.now(),
            parkingSpaceId: 5,
          ),
        ),
        ParkingSpaceModel(id: 6),
      ];

  static List<Map<String, Object?>> get listParkingSpaceMap => listParkingSpace.map((e) => e.toMap()).toList();

  static List<VacancyModel> get listVancacy => [
        VacancyModel(
          description: 'description',
          licensePlate: 'licensePlate',
          entryTime: DateTime.now(),
          parkingSpaceId: 2,
        ),
        VacancyModel(
          description: 'description2',
          licensePlate: 'licensePlate2',
          entryTime: DateTime.now(),
          departureTime: DateTime.now(),
          parkingSpaceId: 5,
        ),
      ];

  static List<Map<String, Object?>> get listVancacyMap => listVancacy.map((e) => e.toMap()).toList();
}
