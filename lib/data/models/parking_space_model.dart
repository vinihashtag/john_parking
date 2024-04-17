import 'dart:convert';

import 'package:john_parking/data/models/vacancy_model.dart';

class ParkingSpaceModel {
  final int position;
  final VacancyModel? vacancyModel;

  ParkingSpaceModel({
    required this.position,
    this.vacancyModel,
  });

  ParkingSpaceModel copyWith({
    bool? isAvailable,
    int? position,
    VacancyModel? vacancyModel,
  }) {
    return ParkingSpaceModel(
      position: position ?? this.position,
      vacancyModel: vacancyModel ?? this.vacancyModel,
    );
  }

  bool get isAvailable => vacancyModel == null;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'position': position});
    if (vacancyModel != null) {
      result.addAll({'vacancyModel': vacancyModel!.toMap()});
    }

    return result;
  }

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      position: map['position']?.toInt() ?? 0,
      vacancyModel: map['vacancyModel'] != null ? VacancyModel.fromMap(map['vacancyModel']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingSpaceModel.fromJson(String source) => ParkingSpaceModel.fromMap(json.decode(source));

  @override
  String toString() => 'ParkingSpaceModel(position: $position, vacancyModel: $vacancyModel)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParkingSpaceModel && other.position == position && other.vacancyModel == vacancyModel;
  }

  @override
  int get hashCode => position.hashCode ^ vacancyModel.hashCode;
}
