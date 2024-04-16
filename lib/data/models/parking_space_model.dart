import 'dart:convert';

class ParkingSpaceModel {
  final String id;
  final bool isAvailable;
  final int position;

  ParkingSpaceModel({
    required this.id,
    required this.isAvailable,
    required this.position,
  });

  ParkingSpaceModel copyWith({
    String? id,
    bool? isAvailable,
    int? position,
  }) {
    return ParkingSpaceModel(
      id: id ?? this.id,
      isAvailable: isAvailable ?? this.isAvailable,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'isAvailable': isAvailable});
    result.addAll({'position': position});

    return result;
  }

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      id: map['id'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
      position: map['position']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingSpaceModel.fromJson(String source) => ParkingSpaceModel.fromMap(json.decode(source));

  @override
  String toString() => 'ParkingSpaceModel(id: $id, isAvailable: $isAvailable, position: $position)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParkingSpaceModel &&
        other.id == id &&
        other.isAvailable == isAvailable &&
        other.position == position;
  }

  @override
  int get hashCode => id.hashCode ^ isAvailable.hashCode ^ position.hashCode;
}
