import 'dart:convert';

class VacancyModel {
  final String? id;
  final String description;
  final String licensePlate;
  final DateTime entryTime;
  final DateTime? departureTime;

  VacancyModel({
    this.id,
    required this.description,
    required this.licensePlate,
    required this.entryTime,
    this.departureTime,
  });

  VacancyModel copyWith({
    String? id,
    String? description,
    String? licensePlate,
    DateTime? entryTime,
    DateTime? departureTime,
  }) {
    return VacancyModel(
      id: id ?? this.id,
      description: description ?? this.description,
      licensePlate: licensePlate ?? this.licensePlate,
      entryTime: entryTime ?? this.entryTime,
      departureTime: departureTime ?? this.departureTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'description': description});
    result.addAll({'licensePlate': licensePlate});
    result.addAll({'entryTime': entryTime.millisecondsSinceEpoch});
    if (departureTime != null) {
      result.addAll({'departureTime': departureTime!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory VacancyModel.fromMap(Map<String, dynamic> map) {
    return VacancyModel(
      id: map['id'],
      description: map['description'] ?? '',
      licensePlate: map['licensePlate'] ?? '',
      entryTime: DateTime.fromMillisecondsSinceEpoch(map['entryTime']),
      departureTime: map['departureTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['departureTime']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VacancyModel.fromJson(String source) => VacancyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VacancyModel(id: $id, description: $description, licensePlate: $licensePlate, entryTime: $entryTime, departureTime: $departureTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VacancyModel &&
        other.id == id &&
        other.description == description &&
        other.licensePlate == licensePlate &&
        other.entryTime == entryTime &&
        other.departureTime == departureTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ description.hashCode ^ licensePlate.hashCode ^ entryTime.hashCode ^ departureTime.hashCode;
  }
}
