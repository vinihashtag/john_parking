import 'dart:convert';

class VacancyModel {
  final String? id;
  final String description;
  final String plate;
  final DateTime entryTime;
  final String? departureTime;
  final int vacancyNumber;

  VacancyModel({
    this.id,
    required this.description,
    required this.plate,
    required this.entryTime,
    this.departureTime,
    required this.vacancyNumber,
  });

  VacancyModel copyWith({
    String? id,
    String? description,
    String? plate,
    DateTime? entryTime,
    String? departureTime,
    int? vacancyNumber,
  }) {
    return VacancyModel(
      id: id ?? this.id,
      description: description ?? this.description,
      plate: plate ?? this.plate,
      entryTime: entryTime ?? this.entryTime,
      departureTime: departureTime ?? this.departureTime,
      vacancyNumber: vacancyNumber ?? this.vacancyNumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'description': description});
    result.addAll({'plate': plate});
    result.addAll({'entryTime': entryTime.millisecondsSinceEpoch});
    if (departureTime != null) {
      result.addAll({'departureTime': departureTime});
    }
    result.addAll({'vacancyNumber': vacancyNumber});

    return result;
  }

  factory VacancyModel.fromMap(Map<String, dynamic> map) {
    return VacancyModel(
      id: map['id'],
      description: map['description'] ?? '',
      plate: map['plate'] ?? '',
      entryTime: DateTime.fromMillisecondsSinceEpoch(map['entryTime']),
      departureTime: map['departureTime'],
      vacancyNumber: map['vacancyNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VacancyModel.fromJson(String source) => VacancyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VacancyModel(id: $id, description: $description, plate: $plate, entryTime: $entryTime, departureTime: $departureTime, vacancyNumber: $vacancyNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VacancyModel &&
        other.id == id &&
        other.description == description &&
        other.plate == plate &&
        other.entryTime == entryTime &&
        other.departureTime == departureTime &&
        other.vacancyNumber == vacancyNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        plate.hashCode ^
        entryTime.hashCode ^
        departureTime.hashCode ^
        vacancyNumber.hashCode;
  }
}
