class TankUpdateRequest {
  final int machineId;
  final String product;
  final int level;

  TankUpdateRequest({
    required this.machineId,
    required this.product,
    required this.level,
  });

  factory TankUpdateRequest.fromJson(Map<String, dynamic> json) {
    return TankUpdateRequest(
      machineId: json['machineId'],
      product: json['product'],
      level: (json['level'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'machineId': machineId,
      'product': product,
      'level': level,
    };
  }
}

class Piston {
  final String name;
  final String product;
  int level;

  Piston({
    required this.name,
    required this.product,
    required this.level,
  });

  factory Piston.fromJson(Map<String, dynamic> json) {
    return Piston(
      name: json['name'],
      product: json['product'],
      level: (json['level'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product': product,
      'level': level,
    };
  }
}
