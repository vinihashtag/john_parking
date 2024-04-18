import 'package:john_parking/shared/utils/constants.dart';

class VacancyModel {
  final int? id;
  final String description;
  final String licensePlate;
  final DateTime entryTime;
  final DateTime? departureTime;
  final int parkingSpaceId;

  VacancyModel({
    this.id,
    required this.description,
    required this.licensePlate,
    required this.entryTime,
    this.departureTime,
    required this.parkingSpaceId,
  });

  VacancyModel copyWith({
    int? id,
    String? description,
    String? licensePlate,
    DateTime? entryTime,
    DateTime? departureTime,
    int? parkingSpaceId,
  }) {
    return VacancyModel(
      id: id ?? this.id,
      description: description ?? this.description,
      licensePlate: licensePlate ?? this.licensePlate,
      entryTime: entryTime ?? this.entryTime,
      departureTime: departureTime ?? this.departureTime,
      parkingSpaceId: parkingSpaceId ?? this.parkingSpaceId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({ConstantsApp.columnDescriptionVacancy: description});
    result.addAll({ConstantsApp.columnLicensePlateVacancy: licensePlate});
    result.addAll({ConstantsApp.columnEntryTimeVacancy: entryTime.millisecondsSinceEpoch});
    if (departureTime != null) {
      result.addAll({ConstantsApp.columnDepartureTimeVacancy: departureTime!.millisecondsSinceEpoch});
    }
    result.addAll({ConstantsApp.columnParkingSpaceIdVacancy: parkingSpaceId});

    return result;
  }

  factory VacancyModel.fromMap(Map<String, dynamic> map) {
    return VacancyModel(
      id: map['id']?.toInt(),
      description: map[ConstantsApp.columnDescriptionVacancy] ?? '',
      licensePlate: map[ConstantsApp.columnLicensePlateVacancy] ?? '',
      entryTime: DateTime.fromMillisecondsSinceEpoch(map[ConstantsApp.columnEntryTimeVacancy]),
      departureTime: map[ConstantsApp.columnDepartureTimeVacancy] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[ConstantsApp.columnDepartureTimeVacancy])
          : null,
      parkingSpaceId: map[ConstantsApp.columnParkingSpaceIdVacancy] ?? 1,
    );
  }

  @override
  String toString() {
    return 'VacancyModel(id: $id, description: $description, licensePlate: $licensePlate, entryTime: $entryTime, departureTime: $departureTime)';
  }
}
