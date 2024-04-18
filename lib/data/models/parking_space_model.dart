import 'dart:convert';

import 'package:john_parking/data/models/vacancy_model.dart';

class ParkingSpaceModel {
  final int id;
  final VacancyModel? vacancyModel;

  ParkingSpaceModel({
    required this.id,
    this.vacancyModel,
  });

  ParkingSpaceModel copyWith({
    int? id,
    VacancyModel? vacancyModel,
  }) {
    return ParkingSpaceModel(
      id: id ?? this.id,
      vacancyModel: vacancyModel ?? this.vacancyModel,
    );
  }

  bool get isAvailable => vacancyModel == null;

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      id: map['id']?.toInt() ?? 0,
      vacancyModel: map['vacancyModel'] != null ? VacancyModel.fromMap(map['vacancyModel']) : null,
    );
  }

  factory ParkingSpaceModel.fromJson(String source) => ParkingSpaceModel.fromMap(json.decode(source));

  @override
  String toString() => 'ParkingSpaceModel(id: $id, vacancyModel: $vacancyModel)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (vacancyModel != null) {
      result.addAll({'vacancyModel': vacancyModel!.toMap()});
    }

    return result;
  }

  String toJson() => json.encode(toMap());
}
