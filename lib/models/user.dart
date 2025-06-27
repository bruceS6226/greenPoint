class User {
  final int id;
  String email;
  String name;
  String identification;
  String phone;
  final bool naturalPerson;
  String gender;
  String address;
  String role;
  bool active;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.identification,
    required this.phone,
    required this.gender,
    required this.address,
    required this.naturalPerson,
    required this.role,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'identification': identification,
        'phone': phone,
        'gender': gender,
        'address': address,
        'naturalPerson': naturalPerson,
        'role': role,
        'active': active,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        identification: json['identification'],
        phone: json['phone'],
        gender: json['gender'],
        address: json['address'],
        naturalPerson: json['naturalPerson'],
        role: json['role'],
        active: json['active'],
      );
}


class UserRequest {
  final int id;
  final String email;
  final String name;
  final String password;
  final String identification;
  final String phone;
  final bool isNaturalPerson;
  final String gender;
  final String address;
  final String role;
  final bool isActive;

  UserRequest({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.identification,
    required this.phone,
    required this.gender,
    required this.address,
    required this.isNaturalPerson,
    required this.role,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        //'id': id,
        'email': email,
        'name': name,
        'password': password,
        'identification': identification,
        'phone': phone,
        'gender': gender,
        'address': address,
        'naturalPerson': isNaturalPerson,
        'role': role,
        'active': isActive,
      };

  factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        password: json['password'],
        identification: json['identification'],
        phone: json['phone'],
        gender: json['gender'],
        address: json['address'],
        isNaturalPerson: json['naturalPerson'],
        role: json['role'],
        isActive: json['active'],
      );
}
