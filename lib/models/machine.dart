class Machine {
  final int? id;
  String name;
  String province;
  String canton;
  String sector;
  String address;
  int userId;
  final bool active;

  Machine({
    this.id,
    required this.name,
    required this.province,
    required this.canton,
    required this.sector,
    required this.address,
    required this.userId,
    required this.active,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      province: json['province'],
      canton: json['canton'],
      sector: json['sector'],
      address: json['address'],
      userId: json['userId'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'province': province,
      'canton': canton,
      'sector': sector,
      'address': address,
      'userId': userId,
      'active': active,
    };
  }
}
